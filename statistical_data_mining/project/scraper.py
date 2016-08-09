import csv
import re
from urllib2 import urlopen

from bs4 import BeautifulSoup


def make_soup(url):
    return BeautifulSoup(urlopen(url), "lxml")


def clean_country(country):
    if "korea" in country.lower() and "," in country:
        korea, direction = country.split(",")
        country = "{} {}".format(direction, korea)
    country = country.lower().split(",")[0].strip()
    if country == "american samoa":
        country = "samoa"
    elif country == "czechia":
        country = "czech republic"
    elif "congo" in country:
        country = "congo"
    elif "micronesia" in country:
        country = "micronesia"
    elif country.endswith("ncipe"):
        country = "soa tome and principe"
    return country.title()


def clean_government(government):
    government = re.sub("\(.+\)", "", government).strip()
    government = re.sub("note:.*", "", government).strip(" \n")
    return government.title()


def get_government_types():
    """As per CIA World Factbook retrieved August 9th 2016."""
    url = "https://www.cia.gov/library/publications/the-world-factbook/fields/2128.html"
    soup = make_soup(url)
    rows = soup.findAll("tr")[1:]
    data = {}
    for row in rows:
        country = clean_country(row.find("a").text)
        government = row.find("td", "fieldData").text.split(";")[0].strip("\n ")
        data[country] = {"government": clean_government(government)}
    return data


def get_government_tax_expenditure():
    """As per 2014 Index of Economic Freedom by The heritage foundation and
    the wallstreet journal."""
    url = "https://en.wikipedia.org/wiki/Government_spending#As_a_percentage_of_GDP"
    soup = make_soup(url)
    rows = soup.findAll("table")[1].findAll("tr")[1:]
    data = {}
    for row in rows:
        tds = row.findAll("td")
        country = clean_country(tds[0].find("a").text)
        try:
            burden = float(tds[1].text)
            expend = float(tds[2].text)
        except:
            continue
        else:
            data[country] = {
                "tax_burden": burden,
                "gov_expend": expend,
                "expend_to_burden_ratio": expend / burden,
            }
    return data


def get_quality_of_life_data():
    """From Numbeo Quality of Life Index 2016."""
    url = "http://www.numbeo.com/quality-of-life/rankings_by_country.jsp?title=2016"
    soup = make_soup(url)
    rows = soup.findAll("table")[2].findAll("tr")[1:]
    data = {}
    for row in rows:
        tds = row.findAll("td")
        country = clean_country(tds[1].text)
        data[country] = {
            "quality_of_life_index": tds[2].text,
            "purchasing_power_index": tds[3].text,
            "safety_index": tds[4].text,
            "health_care_index": tds[5].text,
            "cost_of_living_index": tds[6].text,
            "property_price_to_income_ratio": tds[7].text,
            "traffic_commute_time_index": tds[8].text,
            "pollution_index": tds[9].text,
            "climate_index": tds[10].text,
        }
    return data


def update_data(data, more_data):
    for country, more in more_data.items():
        for k, v in more.items():
            data[country][k] = v
    return data


def get_data():
    data = get_government_types()
    expend = get_government_tax_expenditure()
    quality = get_quality_of_life_data()
    for key in set(data.keys()) - set(expend.keys()):
        del data[key]
    for key in set(expend.keys()) - set(data.keys()):
        del expend[key]
    data = update_data(data, expend)
    for key in set(data.keys()) - set(quality.keys()):
        del data[key]
    data = update_data(data, quality)
    return data


def write_csv(countries):
    with open("world_data.csv", "wb") as csvfile:
        writer = csv.writer(csvfile)
        keys = None
        for country, data in countries.items():
            if not keys:
                keys = data.keys()
                writer.writerow(["country"] + keys)
            row = [country]
            for k in keys:
                row.append(data[k])
            writer.writerow(row)


if __name__ == "__main__":
    write_csv(get_data())

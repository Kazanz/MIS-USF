figure out why 3a needs interaction.
Know how speicifc graphs can be drawn, by looking at the model. interaction etc.
Go read about 1 tail or 2 tail tests and when to worry about them.

You can recognize multicollinearity when the overall p value is very very low, but a lot of variables are not.
10 is a rough cutoff of the variance inflation.

Remedial Measures:

1) Drop 1 or more of highly correlated xs
2) Keeps xs, but avoid inferences on betas and restrict predictions to range of sample data
3) In "POLYNOMIAL" (only polynomial) regression, standardize xs
- IN other words create a z-score for x.  x - mean(x) / std  value of variable - sample mean of variable / standard deviation of the variable
- bo + b1x + b2x^2 becomes bo + b1z + b2z^2
4) Ridge Regression


# Exam Details
Find a 3 hour block between 9am-4pm. Take your exam at any point for 3 hours and put the exam back where you got it.
Will not need to know anythin about SAS.

Unless he specifically says graph the specific betas
Curvature doesnt matter.
Just draw out the general lines.


Question 4a from practive exam:
Your sample size is really really big.  But when you do a confidence interval on the data, the range gets just above zero.

4b: See above and below
A confidence interval kind of simultaneously tells you if the beta is different from zero, but also the magnitude of the coefficient.


Question 3A:

E(y) = Bo + B1*x1 + B2*x2 + B3x1x2
Start with a gloabl F-Test and get the P-value
Then test Interaction Results
Make sure it is at least positive (because we are increasing)

T-Test on null hypothesis where beta 2 is zero
T-Test on null hypothesis where beta 3 is positive

Draw out the graph next time:

E(y) = Bo + B1*x1 + B2*x2 + B3x1x2

           After     Before
Big 6   [bo+b1+b2+b3, b0+b1]  b2+b3 > 0
!Big6   [bo + b2    , b0   ]  b2 = 0


Ho: (b2 + b3) = 0
Ha: (b2 + b3) > 0


Ho: (b3) = 0
Ha: (b3) > 0

had to include beta 2 = 0

When you run a stepwise regressoin there is way too high a chance of a type 1 error because of all the t tests

Use the stepwise on just the main effects. You are going to get some results out, now you can start building your model by adding interactoin or curvature terms 

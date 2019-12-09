# Bertie 
### Your Budget Buddy

![](bertie.jpg)

Only one repo used 

## A Look at the App

## About the App
### The Problem We're Tackling 
Keeping track of money is hard, so we normally take to using budgeting apps. However, all the ones we've tried so far force you to connect to your bank account and do all the expense logging for you. While this is fine for a week or so, once our drive to save money dies down a little, there's nothing to keep up going back to the app. Since the app does everything for us, as users our role is completely passive and we still don't think about our expenses any differently. Finding a good budgeting app is hard, but making our own is easy! (just jokes) 

### Our Solution
Bertie is a budgeting app that makes keeping track of your money as simple as possible. We've removed all the noise that makes expense tracking scary. Just let Bertie know how much you plan to spend for the month and each time you make an expense in that category. He'll keep track of it all for you and give you a simple overview of your progress each month. We know, logging an expense everytime you make one sounds like a lot of work, but bare with us, we're confident that this will help you become more aware of your spending, and hopefully help you stick with your budgets in the long run! 

### Who's a Good Boy !?
![](meetbertie.png)

Bertie is the MAN (read: DOG) when it comes to money. He's not like other boys. Yes, he's good with money, but he's also good with a fun time. He's here to keep budgeting fun with little messages to encourage you, but he's also not afraid to give you a little wake up call when you're spending a little too much. 

## Meeting the Requirements
### Backend
For the backend portion of our app, we deployed it using google cloud. The database was designed with three classes: User, Expense, and Budget. In order to effectively keep track of expense and budgets, the user-expense and user-budget table was modeled a one to many relationship. In addition, Tag was initially a class in our database, however to simplify the implementation, tag was changed to be linked to both expenses and budgets which were defined simply as fields since only one tag corresponded to a budget or an expense.

### iOS



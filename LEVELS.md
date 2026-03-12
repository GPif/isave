# Levels

Version en Français [ici](LEVELS.fr.md).

---

Below you'll find all the levels mentioned above, each with one or more _UserStory_ that needs to be implemented.

## Level 1 - Setting up the base

**As a customer (`Customer`), I want to be able to list all my portfolios (`Portfolio`).**
- For a given portfolio, I want to see its name, total amount and type.
- My portfolio may be of the “CTO”, “PEA”, “Assurance Vie” or “Livret A” type.
- My “CTO”, “PEA” and “Assurance Vie” portfolios can have investments in instruments (`Instrument`).

**As a client, I want to see the investments in my portfolios.**
- A eligible portfolio can only invest once in a given instrument.
- Several eligible portfolios can invest in the same instrument.
- An instrument is characterized by its ISIN (unique global identifier), type, name, price and SRI (risk level).
- An instrument can be a “stock”, a “bond” or a “euro_fund”.
- If my portfolio has investments, I want to see the amount invested in each instrument, as well as the weight this amount represents in the portfolio.

Write the necessary code for an endpoint that returns the contents of `data/level_1/portfolios.json` in JSON.


## Level 2 - Make changes

**As a customer, I want to arbitrate my investments within an eligible portfolio.**
- A portfolio is eligible for transactions if its type is “CTO” or “PEA”.
- I can deposit money into an existing investment.
- I can withdraw money from an existing investment.
- I can transfer money from one of my investments to another.

Write the code needed to expose an API allowing the customer to make changes to their investments.

## Level 3 - Understanding your investments

iSave gives customers a clearer picture of their investments, by calculating their overall risk level and the breakdown of their investments by financial sector.

**As a client, I want to see indicators on my investments.**
- I want to see the risk level of each portfolio, so I know how much risk I'm taking on each set of investments. This risk is calculated by taking into account the weight of each investment in the portfolio and its risk index (SRI).
- I want to see the breakdown of my Portfolio by investment type (stock, bond, etc.) to understand how my money is invested.
- I want to know the overall risk I'm taking by considering all my portfolios, so I can get a complete picture of my financial risks.
- I want to see the overall breakdown of all my investments by type, to understand where all my money is spread across all my portfolios.


Write the code needed to expose an API allowing the customer to obtain the indicators mentioned above.

## Level 4 - fees

iSave charges a monthly fee for hosting customer portfolios with investments on its servers. The fees are as follows:

- 5% for amounts between 0 and 5000
- 3% for amounts between 5000 and 7500
- 2% for amounts between 7500 and 10000
- 0.8% for amounts over 10,000

Regarding these fees, **as a customer, I'd like to see the fees associated with my use of iSave.**
- The current amount of fees applied to each of my portfolios.
- The current percentage of fees applied to each of my portfolios.
- The above values, but globally on all my investments.

Write the code needed to expose an API allowing the customer to view his fees.

## Level 5 - History predicts the future

The customer has been investing on iSave for some time and would like to know how it has evolved over time. To do this, iSave saves the historical values of portfolios hosted on the platform.

**As a customer, I want to see the historical performance of my portfolios.**
- I want to see the historical valuation of each of my portfolios.
- I want to see the returns (percentage growth) of my portfolios globally and at a given date in the past.

The _return_ is calculated as follows:

$$Y = (\dfrac{Vc}{Vi} - 1) \times 100$$

**As a customer, I want to see the fees I've paid in the past.**
- I want to see all level 4 charges, but at a given date in the past.
- I want to see the amount of fees I've paid globally per portfolio since they were added to the platform.


The weekly valuation of the client's portfolios can be found in `data/level_4/historical_values.json`.

Write the code needed to expose an API to access this information.

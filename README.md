# BlockChainPOC

Scenario: We have two consultant companies working for one client. Change requests are filed and both consulting firms are made aware. Each firm may make different estimates for both time and cost. Each firm may indicate when change requests are completed, at which time smart contracts can disperse funds to the appropriate firm.

Client would accept a change request. In accepting they would budget for it by placing the budget amount into a wallet (almost like a down payment or escrow). Payment will come out of this bucket as the change request is completed and accepted. Could be a single bucket of funds or individual buckets per change request.

Creation of change requests will result in the creation of contracts. Change requests could have multiple features or tasks that may pay out individually, pulling from the escrow wallet account as they're completed. Could also disperse funds on a timed interval (i.e. end of month) for what has been completed but not yet paid out.


Why this over traditional app development? Answer: No one company/person holds the data or the power to disperse funds. No one has to trust each other. Rates are set by the original contract agreement and cannot be changed by any one group since no one owns the application. If this was a permissioned block chain, only these three parties are part of the chain. It would be easier for two parties to collude against the third and change the block chain. In this case, it might make sense to have an outside party with no stake in it make sure that no one can try to collude against the other party. The third party might supply a number of nodes to keep everyone else from surpassing the chain with illegitimate transactions.


What's it look like?

Two firms: Firm A and Firm B.

Firm A creates a change request that specifies the rate and estimated hours. Client review and accepts which pulls funds from client into escrow wallet. The change request requires additional work from Firm B so a second CR is created for Firm B. The two firms need to know expected completion dates and statuse but should not see each other's rates or estimated/worked hours.

Client sees a table of CR and can see full details including hours worked, estimated hours, rate, and ETA completion date.
Firm A can see full details of their CR and additionally may see the CR for firm B but only the name of the CR and the ETA.
Same for firm B.

Fast forward in time and Firm A completed work....

Firm A enters the application and marks CR as completed.

Client is notified, enters application, and approves the completed CR.

Funds are transferred from escrow account into Firm A's account.

Firm B can see the CR was completed but has no details other than the status.

Technical TODOs:
- [React] We will need a page/form to create a CR. Fields include - estimated hours, rate, description, name, estimated completion date. 
- [Web3] On successful submission of a valid CR form we will use web3 (JS) to interact with block chain server to intialize the creation of a new contract.
- [Solidity] Need methods to create new CR contract. Each contract could have a creator address and client address.
- [Solidity] Need a contract that has a collection of addresses which are the users and each address has a collection of contracts which represent the CRs they have access to.
- [React] Need a page that displays all of a users CRs (contracts).
- [Solidity] Need method to rerieve and pass down CR details. Examines each contract to see if you're a Creator or Client or Vendor and pass back details appropriately.















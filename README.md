# BlockChainPOC

## Etherum
> Ethereum is a decentralized platform that runs smart contracts: applications that run exactly as programmed without any possibility of downtime, censorship, fraud or third party interference. - https://www.ethereum.org/



## Terminology
### Wallet
A secure digit wallet or account used to store, send, or receive digital currency such as Ether, Bitcoin, etc.

### Ether
Ether is the official cryptocurrency issued by Ethereum.

### DAPPs
**D**ecentralized **App**lications run on blockchains and consist of a user interface and a decentralized back-end.

### Smart Contracts
DAPPs contains one more smart contracts which facilitate the transfer of assets (may or may not be currencies) between two parties under certain contractual conditions.

### Solidity
The programming language used to write ethereum smart contracts.

## Proof of Concept
We are creating a client/vendor DAPP that will manage bids for projects. We are currently building this on the Etherum network because of its ease of use, although the concepts presented in this app can be ported to different blockchain technologies including permissioned (private) blockchains such as JP Morgan's Quorum or IBM's Fabric.

## Example Scenario
We have two consultant companies bidding on a single client project. The client will create the project via the user interfance, and both consulting firms will place their bid via the user interface by providing the estimated tie and cost.

The client will use the UI to view the proposed bids, and for the sake of simplicity, will accept a single bid on any given project.
Once a bid has been accepted, funds equal to the estimated cost are drawn from the client's wallet and placed into an "escrow" wallet account ensuring that the funds are available and payment can be made at the time of project completion.

Via the UI, the vendor will indicate when a project has been completed and the client will accept the completed work, at which time the funds from the escrow wallet are immediately transferred to the vendor.

Client would accept a change request. In accepting they would budget for it by placing the budget amount into a wallet (almost like a down payment or escrow). Payment will come out of this bucket as the change request is completed and accepted. Could be a single bucket of funds or individual buckets per change request.

## Blockchain vs. Traditional Application
The benefit of using a blockchain technology is that no one company/person has the data or the power to disperse funds. Parties do not have to trust eachother. Rates are set by the original contract agreement and cannot be changed by any one group since no one owns the application. 














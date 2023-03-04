// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
/// @title ERC20 Contract
import "./Sponsors.sol";
import "../utils/StructSerialization.sol";

contract Agents is Sponsors {
        constructor(){
    }

     /// @notice insert sponsors Agent
    /// @param _accountKey public Sponsor Coin Account Key
    /// @param _sponsorKey public account key to get sponsor array
    /// @param _agentKey new sponsor to add to account list
    function insertSponsorAgent(address _accountKey, address _sponsorKey, address _agentKey)
            public onlyOwnerOrRootAdmin(msg.sender) 
            nonRedundantAgent ( _accountKey, _sponsorKey, _agentKey) {
        insertAccountSponsor(_accountKey, _sponsorKey);
        addNetworkAccount(_agentKey);

        SponsorStruct storage sponsorAccountRec = getSponsorRec(_accountKey, _sponsorKey);
        AccountStruct storage agentAccountRec = accountMap[_sponsorKey];
        AgentStruct storage  agentRec = getAgentRec(_accountKey, _sponsorKey, _agentKey);

        if (!agentRec.inserted) {
            agentRec.index = sponsorAccountRec.agentKeys.length;
            agentRec.insertionTime = block.timestamp;
            agentRec.account  = _accountKey;
            agentRec.agent    = _agentKey;
            agentRec.inserted = true;
            sponsorAccountRec.agentKeys.push(_agentKey);
            agentAccountRec.agentKeys.push(_agentKey);
        }
    }

    /// @notice determines if agent address is inserted in account.sponsor.agent.map
    /// @param _accountKey public account key validate Insertion
    /// @param _sponsorKey public sponsor account key validate Insertion
    /// @param _agentKey public agent account key validate Insertion
    function isAgentInserted(address _accountKey,address _sponsorKey,address _agentKey) public onlyOwnerOrRootAdmin(_accountKey) view returns (bool) {
        if (getAgentRec(_accountKey, _sponsorKey, _agentKey).inserted)
            return true;
        else
            return false;
    }

    function getAgentIndex(address _accountKey, address _sponsorKey, address _agentKey) public onlyOwnerOrRootAdmin(_accountKey) view returns (uint) {
        if (isAgentInserted(_accountKey, _sponsorKey, _agentKey)) {
            //uint256 agentIndex = accountMap[_accountKey].sponsorMap[_sponsorKey].agentMap[_agentKey].index;
            // console.log(_accountKey, _sponsorKey, _agentKey);
            // console.log("Index = ", agentIndex);
            return accountMap[_accountKey].sponsorMap[_sponsorKey].agentMap[_agentKey].index;
        }
        else
            return 0;
        }

    function getAgentInsertionTime(address _accountKey, address _sponsorKey, address _agentKey) public onlyOwnerOrRootAdmin(_accountKey) view returns (uint) {
        if (isAgentInserted(_accountKey, _sponsorKey, _agentKey))
            return accountMap[_accountKey].sponsorMap[_sponsorKey].agentMap[_agentKey].insertionTime;
        else
            return 0;
    }

    function getValidAgentRec(address _accountKey, address _sponsorKey, address _agentKey) internal onlyOwnerOrRootAdmin(_accountKey) returns (AgentStruct storage) {
        if (!isAgentInserted(_accountKey, _sponsorKey, _agentKey)) {
            insertSponsorAgent(_accountKey, _sponsorKey, _agentKey);
        }
        return getAgentRec(_accountKey, _sponsorKey, _agentKey);
     }

    function getAgentRec(address _accountKey, address _sponsorKey, address _agentKey) internal view onlyOwnerOrRootAdmin(_accountKey) returns (AgentStruct storage) {
        SponsorStruct storage sponsorRec = getSponsorRec(_accountKey, _sponsorKey);
        AgentStruct storage agentRec = sponsorRec.agentMap[_agentKey];
        return agentRec;
     }

    /// @notice get address for an account sponsor
    /// @param _sponsorKey public account key to get agent array
    /// @param _agentIdx new agent to add to account list
    function getSponsorAgentKeyAddress(address _accountKey, address _sponsorKey, uint _agentIdx ) public view onlyOwnerOrRootAdmin(msg.sender) returns (address) {
        address[] memory agentList = getAgentList(_accountKey, _sponsorKey);
        address agentAddress = agentList[_agentIdx];
        return agentAddress;
    }

    /// @notice retreives the sponsor array record size a specific address.
    /// @param _sponsorKey public account key to get Sponsor Record Length
    function getSponsorAgentRecordCount(address _accountKey, address _sponsorKey) public view onlyOwnerOrRootAdmin(_sponsorKey) returns (uint) {
        return getAgentList(_accountKey, _sponsorKey).length;
    }

    /// @notice retreives the sponsor array records from a specific account address.
    /// @param _sponsorKey public account key to get Sponsors
    function getAgentList(address _accountKey, address _sponsorKey) internal view onlyOwnerOrRootAdmin(_sponsorKey) returns (address[] memory) {
        SponsorStruct storage sponsorRec = getSponsorRec(_accountKey, _sponsorKey);
        address[] memory agentKeys = sponsorRec.agentKeys;
        return agentKeys;
    }
}

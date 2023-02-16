// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
/// @title ERC20 Contract
import "./Sponsors.sol";

contract Agents is Sponsors {
        constructor(){
    }

    /// @notice insert sponsors Agent
    /// @param _accountKey public Sponsor Coin Account Key
    /// @param _sponsorKey public account key to get sponsor array
    /// @param _agentKey new sponsor to add to account list
    function insertSponsorAgent(address _accountKey, address _sponsorKey, address _agentKey) public onlyOwnerOrRootAdmin(msg.sender) returns (bool) {
        insertAccount(_agentKey);
        insertAccount(_sponsorKey);
        insertAccount(_agentKey);

        sponsorStruct storage sponsorRec = getSponsorRec(_accountKey, _sponsorKey);
        agentStruct storage  agentRec = getAgentRec(_accountKey, _sponsorKey, _agentKey);

        if (agentRec.account == burnAddress) {
           agentRec.account = _accountKey;
           agentRec.sponsor = _sponsorKey;
           agentRec.agent = _agentKey;
           sponsorRec.agentKeys.push(_agentKey);
           return true;
        }

//        accountRec.agents.push(_agentKey);
        return true;
    }

    function getAgentRec(address _accountKey, address _sponsorKey, address _agentKey) internal view onlyOwnerOrRootAdmin(_accountKey) returns (agentStruct storage) {
        sponsorStruct storage sponsorRec = getSponsorRec(_accountKey, _sponsorKey);
        agentStruct storage agentRec = sponsorRec.agentMap[_agentKey];
        return agentRec;
     }

    /// @notice get address for an account sponsor
    /// @param _sponsorKey public account key to get agent array
    /// @param _agentIdx new agent to add to account list
    function getAgentKeyAddress(address _accountKey, address _sponsorKey, uint _agentIdx ) public view onlyOwnerOrRootAdmin(msg.sender) returns (address) {
        address[] memory agentList = getAgentList(_accountKey, _sponsorKey);
        address agentAddress = agentList[_agentIdx];
        return agentAddress;
    }

    /// @notice retreives the sponsor array record size a specific address.
    /// @param _sponsorKey public account key to get Sponsor Record Length
    function getAgentRecordCount(address _accountKey, address _sponsorKey) public view onlyOwnerOrRootAdmin(_sponsorKey) returns (uint) {
        return getAgentList(_accountKey, _sponsorKey).length;
    }

    /// @notice retreives the sponsor array records from a specific account address.
    /// @param _sponsorKey public account key to get Sponsors
    function getAgentList(address _accountKey, address _sponsorKey) internal view onlyOwnerOrRootAdmin(_sponsorKey) returns (address[] memory) {
        sponsorStruct storage sponsorRec = getSponsorRec(_accountKey, _sponsorKey);
        address[] memory agentKeys = sponsorRec.agentKeys;
        return agentKeys;
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Ladderit {
    struct User {
        address client;
        string name;
        string[] tasks;
        mapping(uint256 => bool) dailyTasks;
    }

    mapping(address => User) public users;
    mapping(string => bool) public isTaken;

    event TaskCompleted(uint256 indexed taskID);
    event UserName(string indexed name);

    function addTask(string calldata _task) external {
        require(
            msg.sender == users[msg.sender].client,
            "You have to register first"
        );
        User storage user = users[msg.sender];
        require(
            users[msg.sender].tasks.length < 5,
            "Maximum task limit reached"
        );
        user.tasks.push(_task);
    }

    function getTasks() public view returns (string[] memory) {
        return users[msg.sender].tasks;
    }

    function delTask(uint256 taskIndex) external returns (string memory) {
        User storage user = users[msg.sender];
        require(taskIndex <= user.tasks.length, "Invalid task index");
        require(user.client == msg.sender, "You are not allowed");
        string memory selectedTask = user.tasks[taskIndex];
        user.tasks[taskIndex] = "";
        return selectedTask;
    }

    function getUserName(string calldata _name) external {
        User storage user = users[msg.sender];
        require(!isTaken[_name], "Name is already taken");
        require(bytes(user.name).length == 0, "User already registered");
        user.name = _name;
        user.client = msg.sender;
        isTaken[_name] = true;

        emit UserName(user.name);
    }

    function completeTask(uint256 taskID) external {
        User storage user = users[msg.sender];
        require(user.dailyTasks[taskID] == false, "Task already completed.");
        user.dailyTasks[taskID] = true;

        emit TaskCompleted(taskID);
    }

    function isTaskCompleted(uint256 taskID) public view returns (bool) {
        return users[msg.sender].dailyTasks[taskID];
    }
}

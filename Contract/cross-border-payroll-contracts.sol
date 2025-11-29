// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
 Cross Border Payroll Contract
 Author: Your Name
 Description:
  A simplified smart contract to manage payroll payments
  across borders using blockchain.
*/

contract Project {
    
    address public owner;

    struct Employee {
        address wallet;
        uint256 salary;
        bool isActive;
    }

    mapping(address => Employee) public employees;

    event EmployeeAdded(address indexed employee, uint256 salary);
    event SalaryUpdated(address indexed employee, uint256 newSalary);
    event SalaryPaid(address indexed employee, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // ---------------------------------------------------
    // CORE FUNCTION 1 — Add employee
    // ---------------------------------------------------
    function addEmployee(address _wallet, uint256 _salary) external onlyOwner {
        require(_wallet != address(0), "Invalid address");
        require(!employees[_wallet].isActive, "Employee already exists");

        employees[_wallet] = Employee(_wallet, _salary, true);

        emit EmployeeAdded(_wallet, _salary);
    }

    // ---------------------------------------------------
    // CORE FUNCTION 2 — Update salary
    // ---------------------------------------------------
    function updateSalary(address _wallet, uint256 _newSalary) external onlyOwner {
        require(employees[_wallet].isActive, "Employee not found");

        employees[_wallet].salary = _newSalary;
        emit SalaryUpdated(_wallet, _newSalary);
    }

    // ---------------------------------------------------
    // CORE FUNCTION 3 — Pay salary
    // ---------------------------------------------------
    function paySalary(address _wallet) external payable onlyOwner {
        Employee memory emp = employees[_wallet];
        require(emp.isActive, "Employee not found");
        require(msg.value == emp.salary, "Incorrect salary amount");

        payable(emp.wallet).transfer(msg.value);
        emit SalaryPaid(_wallet, msg.value);
    }
}


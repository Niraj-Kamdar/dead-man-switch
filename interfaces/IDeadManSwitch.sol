interface DeadManSwitch {
    function lastVisitedBlock() external view virtual returns (uint);

    function guardian() external view virtual returns (address);

    function stillAlive() external;

    function transferFundsToGuardian() external;

    function transferFundsToOwner() external virtual;

    function changeGuardian(address newGuardian) external;
}

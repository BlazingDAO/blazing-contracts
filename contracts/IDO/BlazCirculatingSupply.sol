// SPDX-License-Identifier: AGPL-3.0-or-later\
pragma solidity 0.7.5;

import "../interfaces/IERC20.sol";

import "../libraries/SafeMath.sol";

contract BlazCirculatingSupply {
    using SafeMath for uint;

    bool public isInitialized;

    address public BLAZ;
    address public owner;
    address[] public nonCirculatingBLAZAddresses;

    constructor( address _owner ) {
        owner = _owner;
    }

    function initialize( address _blaz ) external returns ( bool ) {
        require( msg.sender == owner, "caller is not owner" );
        require( isInitialized == false );

        BLAZ = _blaz;

        isInitialized = true;

        return true;
    }

    function BLAZCirculatingSupply() external view returns ( uint ) {
        uint _totalSupply = IERC20( BLAZ ).totalSupply();

        uint _circulatingSupply = _totalSupply.sub( getNonCirculatingBLAZ() );

        return _circulatingSupply;
    }

    function getNonCirculatingBLAZ() public view returns ( uint ) {
        uint _nonCirculatingBLAZ;

        for( uint i=0; i < nonCirculatingBLAZAddresses.length; i = i.add( 1 ) ) {
            _nonCirculatingBLAZ = _nonCirculatingBLAZ.add( IERC20( BLAZ ).balanceOf( nonCirculatingBLAZAddresses[i] ) );
        }

        return _nonCirculatingBLAZ;
    }

    function setNonCirculatingBLAZAddresses( address[] calldata _nonCirculatingAddresses ) external returns ( bool ) {
        require( msg.sender == owner, "Sender is not owner" );
        nonCirculatingBLAZAddresses = _nonCirculatingAddresses;

        return true;
    }

    function transferOwnership( address _owner ) external returns ( bool ) {
        require( msg.sender == owner, "Sender is not owner" );

        owner = _owner;

        return true;
    }
}

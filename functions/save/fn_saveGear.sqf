/*    Saves an item in custom gear array
*
*     remote executed from dialog
*/

if (!isServer) exitWith {};
params ["_mode", "_uid", "_item"];
private ["_playerGear"];

private _gearArray = profileNamespace getVariable ["mcd_coTemplate_customGearArray", []];
private _id = [_gearArray, _uid] call grad_customGear_fnc_findUID;

if (_id == -1) then {
    _gearArray pushBack [_uid, "", "", "", "", "", "", ""];
    _id = [_gearArray, _uid] call grad_customGear_fnc_findUID;
};

private _playerGear = _gearArray select _id;

private _gearID = switch (_mode) do {
    case "HELMET": {1};
    case "GOGGLES": {2};
    case "USSCOPE1": {3};
    case "USSCOPE4": {4};
    case "USSCOPEM": {5};
    case "RUSSCOPE1": {6};
    case "RUSSCOPE4": {7};
    default {-1};
};
if (_gearID == -1) exitWith {["Mode not found.","GRAD Custom Gear: ERROR"] call grad_customGear_fnc_notificationAndLog};

_playerGear set [_gearID, _item];
_gearArray set [_id, _playerGear];
saveProfileNamespace;

mcd_coTemplate_customGearArray = profileNamespace getVariable ["mcd_coTemplate_customGearArray", []];
publicVariable "mcd_coTemplate_customGearArray";

[_uid] remoteExec ["grad_customGear_fnc_updateDialog", 0, false];

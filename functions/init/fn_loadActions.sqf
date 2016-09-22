/*  Adds load actions to player and removes them after time
*
*/

[] spawn {
  private ["_action"];

  //wait until other loadout scripts are done
  waitUntil {!isNull player};
  sleep 10;

  //get config values
  _allowHelmet = getNumber (missionConfigFile >> "grad_customGear" >> "allowHelmet") == 1;
  _allowGoggles = getNumber (missionConfigFile >> "grad_customGear" >> "allowGoggles") == 1;
  _allowSimpleScopes = getNumber (missionConfigFile >> "grad_customGear" >> "allowSimpleScopes") == 1;
  _allowMagnifyingScopes = getNumber (missionConfigFile >> "grad_customGear" >> "allowMagnifyingScopes") == 1;
  _allowMarksmanScopes = getNumber (missionConfigFile >> "grad_customGear" >> "allowMarksmanScopes") == 1;

  //add actions
  _id1 = -1; _id2 = -1; _id3 = -1;
  if (_allowHelmet) then {
    _action = {player removeAction (_this select 2); player setVariable ["grad_customGear_HelmetLoaded", true]; ["HELMET"] call grad_customGear_fnc_loadGear};
    _id1 = player addAction ["<t color='#00ff00'>Persönlichen Helm laden</t>", _action, [], 2, false, true];
  };

  if (_allowGoggles) then {
    _action = {player removeAction (_this select 2); player setVariable ["grad_customGear_GogglesLoaded", true]; ["GOGGLES"] call grad_customGear_fnc_loadGear};
    _id2 = player addAction ["<t color='#00ff00'>Persönliche Gesichtsbekleidung laden</t>", _action, [], 2, false, true];
  };

  _currentZoomFactor = [(player weaponAccessories (primaryWeapon player)) select 2] call grad_customGear_fnc_getZoomFactor;
  if (_allowSimpleScopes && _currentZoomFactor == 1) then {
    _action = {player removeAction (_this select 2); player setVariable ["grad_customGear_ScopeLoaded", true]; ["SCOPE1", (_this select 3) select 0, (_this select 3) select 0] call grad_customGear_fnc_loadGear};
    _id3 = player addAction ["<t color='#00ff00'>Persönliches Visier laden</t>", _action, [_allowMagnifyingScopes, _allowMarksmanScopes], 2, false, true];
  };
  if (_allowMagnifyingScopes && _currentZoomFactor > 1 && _currentZoomFactor < 4) then {
    _action = {player removeAction (_this select 2); player setVariable ["grad_customGear_ScopeLoaded", true]; ["SCOPE4", (_this select 3) select 0, (_this select 3) select 0] call grad_customGear_fnc_loadGear};
    _id3 = player addAction ["<t color='#00ff00'>Persönliches Visier laden</t>", _action, [_allowMagnifyingScopes, _allowMarksmanScopes], 2, false, true];
  };
  if (_allowMarksmanScopes && _currentZoomFactor >= 4) then {
    _action = {player removeAction (_this select 2); player setVariable ["grad_customGear_ScopeLoaded", true]; ["SCOPEM", (_this select 3) select 0, (_this select 3) select 0] call grad_customGear_fnc_loadGear};
    _id3 = player addAction ["<t color='#00ff00'>Persönliches Visier laden</t>", _action, [_allowMagnifyingScopes, _allowMarksmanScopes], 2, false, true];
  };


  //exit if no actions added
  if ({_x != -1} count [_id1, _id2, _id3] == 0) exitWith {};
  systemChat "Persönliches Equipment kann jetzt geladen werden.";


  //remove action after time
  sleep 120;
  params ["_id1", "_id2", "_id3"];

  if (_id1 != -1) then {
    if !(player getVariable ["grad_customGear_HelmetLoaded", false]) then {
      player removeAction _id1;
    };
  };

  if (_id2 != -1) then {
    if !(player getVariable ["grad_customGear_GogglesLoaded", false]) then {
      player removeAction _id2;
    };
  };

  if (_id3 != -1) then {
    if !(player getVariable ["grad_customGear_ScopeLoaded", false]) then {
      player removeAction _id3;
    };
  };



};
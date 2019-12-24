/*

| DIA DE CREACION: 18/12/19 
| ULTIMO DIA DE MODIFICACION: 24/12/19
| META PRINCIPAL: NO LOGRADA.
| SISTEMA DE REGISTRO: LOGRADO (19/12/2019).
| SISTEMA DE ENTRADA: LOGRADO (19/12/2019).
*/

#include <a_samp>
#include <a_mysql>
#include <izcmd>
#include <foreach>
#include <sscanf2>

// MYSQL
#define IP 		"localhost"
#define User 	"root"
#define database "servidor"
#define pass ""


#define DIALOG_LOGIN 1
#define DIALOG_REGISTER 2
#define DIALOG_EDAD 3
#define DIALOG_GENERO 4

enum info
{
	Name[MAX_PLAYER_NAME],
	Password[65],
	ID,
	Genero,
	Edad,
	Nivel,
	Indumencia,
	Especie,
	Float: Vida,
	Float: Chaleco,
	Mundo,
	Interior,
	Float: Angulo,
	Float: X_Pos,
	Float: Y_Pos,
	Float: Z_Pos,
	Dinero,

	Cache: Cache_ID

};
new InfoPlayer[MAX_PLAYERS][info];
main()
{
	print("\n----------------------------------");
	print(" Creando un sistema de registro y login sencillo v1.0");
	print("----------------------------------\n");
}

new MySQL:conexion, Corrupt_Check[MAX_PLAYERS];


public OnGameModeInit()
{
	new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true);
	printf("Iniciado base de datos...\nServidor: '%s'\nUsuario: '%s'\n", IP, User);
	
	conexion = mysql_connect(IP, User, pass, database);
	
	if (conexion == MYSQL_INVALID_HANDLE || mysql_errno() != 0){
	    print("La base de datos no fue cargada correctamente");
		mysql_close();
		SendRconCommand("exit");
	}
    
	print("La base de datos fue cargada correctamente");

	mysql_tquery(conexion, "CREATE TABLE IF NOT EXISTS `USUARIOS` (`ID` int(11) NOT NULL AUTO_INCREMENT,`NOMBRE` varchar(24) NOT NULL,`PASSWORD` char(65) NOT NULL,`GENERO` mediumint(5) NOT NULL,`EDAD` mediumint(7), `NIVEL` mediumint(7), `INDUMENCIA` mediumint(7) NOT NULL DEFAULT '0',`ESPECIE` mediumint(7) NOT NULL DEFAULT '0', `VIDA` float(4) NOT NULL DEFAULT '100', `CHALECO` float(4) NOT NULL DEFAULT '0', `MUNDO` mediumint(7) NOT NULL DEFAULT '0',`INTERIOR` mediumint(7) NOT NULL DEFAULT '0',`ANGULO` float(4) NOT NULL DEFAULT '90.0',`POSX` float(4) NOT NULL DEFAULT '0',`POSY` float(4) NOT NULL DEFAULT '0',`POSZ` float(4) NOT NULL DEFAULT '0',`DINERO` int(11) NOT NULL DEFAULT '1000', PRIMARY KEY (`ID`), UNIQUE KEY `NOMBRE` (`NOMBRE`))");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	foreach(new i: Player){
		if(IsPlayerConnected(i)){
			SaveData(i);
		}

	}
	mysql_close(conexion);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{

	return 1;
}

public OnPlayerConnect(playerid)
{
	CheckPlayer(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SaveData(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerPos(playerid, InfoPlayer[playerid][X_Pos], InfoPlayer[playerid][Y_Pos], InfoPlayer[playerid][Z_Pos]);
	SetPlayerVirtualWorld(playerid, InfoPlayer[playerid][Mundo]);
	SetPlayerInterior(playerid, InfoPlayer[playerid][Interior]);
	SetPlayerFacingAngle(playerid, InfoPlayer[playerid][Angulo]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_LOGIN:{
			if(!response) return Kick(playerid);
			if(strcmp(InfoPlayer[playerid][Password], inputtext, true, 65) == 0){
				//RECUPERAMOS LOS DATOS

				cache_set_active(InfoPlayer[playerid][Cache_ID]);
				//ENTEROS
				cache_get_value_int(0, "ID", InfoPlayer[playerid][ID]);
				cache_get_value_int(0, "DINERO", InfoPlayer[playerid][Dinero]);
				cache_get_value_int(0, "EDAD", InfoPlayer[playerid][Edad]);
				cache_get_value_int(0, "NIVEL", InfoPlayer[playerid][Nivel]);
				cache_get_value_int(0, "MUNDO", InfoPlayer[playerid][Mundo]);
				cache_get_value_int(0, "INTERIOR", InfoPlayer[playerid][Interior]);
				cache_get_value_int(0, "INDUMENCIA", InfoPlayer[playerid][Indumencia]);
				cache_get_value_int(0, "ESPECIE", InfoPlayer[playerid][Especie]);
				cache_get_value_int(0, "GENERO", InfoPlayer[playerid][Genero]);
				//FLOATS
				cache_get_value_float(0, "VIDA", InfoPlayer[playerid][Vida]);
				cache_get_value_float(0, "CHALECO", InfoPlayer[playerid][Chaleco]);
				cache_get_value_float(0, "POSX", InfoPlayer[playerid][X_Pos]);
				cache_get_value_float(0, "POSY", InfoPlayer[playerid][Y_Pos]);
				cache_get_value_float(0, "ANGULO", InfoPlayer[playerid][Angulo]);
				cache_get_value_float(0, "POSZ", InfoPlayer[playerid][Z_Pos]);
				
				
				SetPlayerHealth(playerid, InfoPlayer[playerid][Vida]);
				
				SetPlayerArmour(playerid, InfoPlayer[playerid][Chaleco]);
				ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid, InfoPlayer[playerid][Dinero]);
				SetPlayerScore(playerid, InfoPlayer[playerid][Nivel]);

				cache_delete(InfoPlayer[playerid][Cache_ID]);
				InfoPlayer[playerid][Cache_ID] = MYSQL_INVALID_CACHE;

				SetSpawnInfo(playerid, NO_TEAM, 0, InfoPlayer[playerid][X_Pos], InfoPlayer[playerid][Y_Pos], InfoPlayer[playerid][Z_Pos], InfoPlayer[playerid][Angulo], 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);

			} else {
					SendClientMessage(playerid, -1, "¡Contraseña incorrecta!");
					Kick(playerid);
			}   
		}  
		case DIALOG_REGISTER:{
			if(!response){
				Kick(playerid);} 
				else{
					if(!strlen(inputtext)){
						Kick(playerid);}
					new str[65], str2[65];
					format(str, sizeof(str), "%s", inputtext); 
					InfoPlayer[playerid][Password] = str;
					InfoPlayer[playerid][Vida] = 100.0;
					InfoPlayer[playerid][Chaleco] = 100.0;
					InfoPlayer[playerid][Angulo] = 90.0;
					InfoPlayer[playerid][Dinero] = 100;
					InfoPlayer[playerid][X_Pos] = 1958.3;
					InfoPlayer[playerid][Y_Pos] = 1343.15;
					InfoPlayer[playerid][Z_Pos] = 15.37;
					InfoPlayer[playerid][Mundo] = 0;
					InfoPlayer[playerid][Interior] = 0;
					InfoPlayer[playerid][Nivel] = 1;
					format(str2, sizeof(str2), "Elige la edad de %s, recuerda que es de 18 en adelante.", InfoPlayer[playerid][Name]);
					ShowPlayerDialog(playerid, DIALOG_EDAD, DIALOG_STYLE_INPUT, "Edad de tu PJ", str2, "Aceptar", "Rechazar");
			}
		}   
		case DIALOG_EDAD:{
			if(!response){
				Kick(playerid);
			}else{
				new edad = strval(inputtext);
				if(edad < 17){
					ShowPlayerDialog(playerid, DIALOG_EDAD, DIALOG_STYLE_INPUT, "Edad de tu PJ", "La edad es incorrecta, debe ser mayor o igual a 18 de edad!", "Aceptar", "");
				} else{
					InfoPlayer[playerid][Edad] = edad;
					ShowPlayerDialog(playerid, DIALOG_GENERO, DIALOG_STYLE_MSGBOX, "Genero del personaje.","Elige el genero del personaje.", "Masculino", "Femenino");
				}

			}
		}
		case DIALOG_GENERO:{
			new Query[225];
			if(response){InfoPlayer[playerid][Genero] = 0;}else{InfoPlayer[playerid][Genero] = 1;}
			mysql_format(conexion, Query, sizeof(Query), "INSERT INTO `usuarios`(`NOMBRE`, `PASSWORD`, `POSX`, `POSY`, `POSZ`, `EDAD`, `GENERO`, `NIVEL`) VALUES ('%e', '%s', '%f', '%f', '%f', '%d', '%d', '%d')",InfoPlayer[playerid][Name], InfoPlayer[playerid][Password], InfoPlayer[playerid][X_Pos], InfoPlayer[playerid][Y_Pos], InfoPlayer[playerid][Z_Pos], InfoPlayer[playerid][Edad], InfoPlayer[playerid][Genero], InfoPlayer[playerid][Nivel]);
			mysql_tquery(conexion, Query, "OnPlayerRegisted", "d", playerid);
			}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

//========================================FORWARDS=============================
forward OnPlayerDataLoaded(playerid, corrupt_check);
public OnPlayerDataLoaded(playerid, corrupt_check){

	if (corrupt_check != Corrupt_Check[playerid]) return Kick(playerid);
	new str[150];
	if(cache_num_rows() > 0){

		cache_get_value(0, "PASSWORD", InfoPlayer[playerid][Password], 65);

		InfoPlayer[playerid][Cache_ID] = cache_save();

		format(str, sizeof(str), "La cuenta: %s se encuentra registrada. Inicia sesion.", InfoPlayer[playerid][Name]);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Iniciar Sesion", str, "Aceptar", "Cerrar");
	
	}else{

		format(str, sizeof(str), "La cuenta %s no se encuentra registrada, por lo tanto ingrese una clave para registrarse.", InfoPlayer[playerid][Name]);
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registrarse", str, "Aceptar", "Cerrar");
	}
	return 1;
}


forward CheckPlayer(playerid);
public CheckPlayer(playerid){

	new Query[128];
	GetPlayerName(playerid, InfoPlayer[playerid][Name], 24);
	Corrupt_Check[playerid]++;
	mysql_format(conexion, Query, sizeof(Query), "SELECT * FROM `usuarios` WHERE `NOMBRE` ='%e' LIMIT 1", InfoPlayer[playerid][Name]);
	mysql_tquery(conexion, Query, "OnPlayerDataLoaded", "ii", playerid,  Corrupt_Check[playerid]); 
	return 1;

}

forward SaveData(playerid);
public SaveData(playerid){


	GetPlayerHealth(playerid, InfoPlayer[playerid][Vida]);
	GetPlayerArmour(playerid, InfoPlayer[playerid][Chaleco]);
	GetPlayerPos(playerid, InfoPlayer[playerid][X_Pos], InfoPlayer[playerid][Y_Pos], InfoPlayer[playerid][Z_Pos]);
	GetPlayerFacingAngle(playerid, InfoPlayer[playerid][Angulo]);
	InfoPlayer[playerid][Dinero] = GetPlayerMoney(playerid);
	InfoPlayer[playerid][Interior] = GetPlayerInterior(playerid);
	InfoPlayer[playerid][Mundo] = GetPlayerVirtualWorld(playerid);
	new Query[500];
	printf("Nivel: %d", InfoPlayer[playerid][Nivel]);
	printf("ID: %d", InfoPlayer[playerid][ID]);
	printf("X: %f, Y: %f, Z: %f", InfoPlayer[playerid][X_Pos], InfoPlayer[playerid][Y_Pos], InfoPlayer[playerid][Z_Pos]);
	printf("vida: %f ",InfoPlayer[playerid][Vida]);
	mysql_format(conexion, Query, sizeof(Query), "UPDATE `usuarios` SET `VIDA` = %f, `CHALECO` = %f,`DINERO` = %d, `POSX` = %f, `POSY` = %f, `POSZ` = %f, `ANGULO` = %f, `INTERIOR` = %d, `MUNDO` = %d, `ESPECIE` = %d, `INDUMENCIA` = %d WHERE `ID` = %d LIMIT 1", InfoPlayer[playerid][Vida], InfoPlayer[playerid][Chaleco], InfoPlayer[playerid][Dinero], InfoPlayer[playerid][X_Pos], InfoPlayer[playerid][Y_Pos], InfoPlayer[playerid][Z_Pos], InfoPlayer[playerid][Angulo],InfoPlayer[playerid][Interior],InfoPlayer[playerid][Mundo], InfoPlayer[playerid][Especie], InfoPlayer[playerid][Indumencia], InfoPlayer[playerid][ID]);
	mysql_tquery(conexion, Query); 
	mysql_format(conexion, Query, sizeof(Query), "UPDATE `usuarios` SET `NIVEL` = %d WHERE `ID` = %d LIMIT 1", GetPlayerScore(playerid), InfoPlayer[playerid][ID]);
	mysql_tquery(conexion, Query);

	if (cache_is_valid(InfoPlayer[playerid][Cache_ID])){
		cache_delete(InfoPlayer[playerid][Cache_ID]);
		InfoPlayer[playerid][Cache_ID] = MYSQL_INVALID_CACHE;

	}
	
	return 1;
}
forward OnPlayerRegisted(playerid);
public OnPlayerRegisted(playerid){
	new str[70];
	InfoPlayer[playerid][ID] = cache_insert_id();
	format(str, sizeof(str), "%s se ha registrado correctamente, seras tpeado", InfoPlayer[playerid][Name]);
	SendClientMessage(playerid, -1, str);
	SetSpawnInfo(playerid,0,0,InfoPlayer[playerid][X_Pos], InfoPlayer[playerid][Y_Pos], InfoPlayer[playerid][Z_Pos],0,0,0,0,0,0,0);
	SetPlayerHealth(playerid, InfoPlayer[playerid][Vida]);
	SetPlayerArmour(playerid, InfoPlayer[playerid][Chaleco]);
	GivePlayerMoney(playerid, InfoPlayer[playerid][Dinero]);
	SetPlayerScore(playerid, InfoPlayer[playerid][Nivel]);
	SetPlayerVirtualWorld(playerid, InfoPlayer[playerid][Mundo]);
	SetPlayerInterior(playerid, InfoPlayer[playerid][Interior]);
	SetPlayerFacingAngle(playerid, InfoPlayer[playerid][Angulo]);
	SetSpawnInfo(playerid, NO_TEAM, 0, InfoPlayer[playerid][X_Pos], InfoPlayer[playerid][Y_Pos], InfoPlayer[playerid][Z_Pos], InfoPlayer[playerid][Angulo], 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}


NombreRP(playerid, nombreRP[]){
	new len;
	len = strlen(InfoPlayer[playerid][Name]);
	for(new i = 0; i < len; ++i){
		if(InfoPlayer[playerid][Name][i] == '_')
			nombreRP[i] = ' ';
		else
			nombreRP[i] = InfoPlayer[playerid][Name][i];
	}
	return 1;
}


CMD:vida(playerid, params[]){
	new Float:vida;
	if(sscanf(params, "f", vida)) return SendClientMessage(playerid, -1, "Usa /vida [valor]");
	SetPlayerHealth(playerid, vida);
	return CMD_SUCCESS;
}


CMD:chaleco(playerid, params[]){
	new Float:chaleco;
	if(sscanf(params, "f", chaleco)) return SendClientMessage(playerid, -1, "Usa /chaleco [valor]");
	SetPlayerArmour(playerid, chaleco);
	return CMD_SUCCESS;
}


CMD:dinero(playerid, params[]){
	new Money;
	if(sscanf(params, "d", Money)) return SendClientMessage(playerid, -1, "Usa /dinero [monto]");
	GivePlayerMoney(playerid, Money);
	InfoPlayer[playerid][Dinero] = Money;
	return CMD_SUCCESS;
}


CMD:pos(playerid){
	new str[128], Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	format(str, sizeof(str), "X: %f, Y: %f, Z: %f", x, y, z);
	SendClientMessage(playerid,-1, str);
	return CMD_SUCCESS;
}

CMD:stats(playerid){
	new str[500], nombreRP[24];
	NombreRP(playerid, nombreRP);
	printf("Nombre: %s", nombreRP);
	format(str, sizeof(str), "Nombre: %s.\nEdad: %d.\nIndumencia: %d.\
	\nEspecie: %d.\nDinero: %d\nTiempo de residencia: %d.", nombreRP,\
	 InfoPlayer[playerid][Edad], InfoPlayer[playerid][Indumencia], \
	 InfoPlayer[playerid][Especie], InfoPlayer[playerid][Dinero], InfoPlayer[playerid][Nivel]);
	ShowPlayerDialog(playerid, 5, DIALOG_STYLE_MSGBOX, "Estadisticas", str, "--", "");
	return CMD_SUCCESS;
}

CMD:especie(playerid, params[]){
	new especie, str[128];
	if(sscanf(params, "d", especie)) return SendClientMessage(playerid, -1, "Usa /especie[number]");
	if(especie > 9 || especie < 0) return SendClientMessage(playerid, -1, "Solo debe ser del 0 al 9!");
	InfoPlayer[playerid][Especie] = especie;
	format(str, sizeof(str), "Tu especie ha sido cambiada a la numero: %d", InfoPlayer[playerid][Especie]);
	SendClientMessage(playerid, -1, str);
	return 1;
}

CMD:indumencia(playerid, params[]){
	new idn, str[128];
	if(sscanf(params, "d", idn)) return SendClientMessage(playerid, -1, "Usa /indumencia [number]");
	if(idn < 0 || idn > 999) return SendClientMessage(playerid, -1, "Solo debe ser del 0 al 999!");
	InfoPlayer[playerid][Indumencia] = idn;
	format(str, sizeof(str), "Tu indumencia ha sido cambiada a la numero: %d", InfoPlayer[playerid][Indumencia]);
	SendClientMessage(playerid, -1, str);
	return 1;
}

CMD:nivel(playerid, params[]){
	new nivel, str[128];
	if(sscanf(params, "d", nivel)) return SendClientMessage(playerid, -1, "Usa /nivel [valor]");
	InfoPlayer[playerid][Nivel] = nivel;
	SetPlayerScore(playerid, nivel);
	format(str, sizeof(str), "Has cambiado tu nivel a: %d", InfoPlayer[playerid][Nivel]);
	SendClientMessage(playerid, -1, str);
	return 1;
}
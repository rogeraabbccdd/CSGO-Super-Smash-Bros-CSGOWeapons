#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>
#include <kento_smashbros>

#pragma newdecls required

bool bLibraryExists = false;

ConVar healthshot_health;
ConVar heavyassaultsuit_def;
ConVar heavyassaultsuit_armor;
ConVar heavyassaultsuit_up;
ConVar heavyassaultsuit_back;
float fhealthshot_health;
float fheavyassaultsuit_def;
float fheavyassaultsuit_up;
float fheavyassaultsuit_back;

int healthshot[MAXPLAYERS + 1];
bool has_heavyassaultsuit[MAXPLAYERS + 1];
float fheavyassaultsuit_armor[MAXPLAYERS + 1];
float fcvar_heavyassaultsuit_armor;
char player_default_model[256][MAXPLAYERS + 1];

float playerDefaultUp[MAXPLAYERS + 1];
float playerDefaultTake[MAXPLAYERS + 1];
float playerDefaultBack[MAXPLAYERS + 1];

public Plugin myinfo =
{
  name = "[CS:GO] Super Smash Bros Item - CSGO Weapons",
  author = "Kento",
  description = "Super Smash Bros Item - CSGO Weapons",
  version = "1.3",
  url = "http://steamcommunity.com/id/kentomatoryoshika/"
};

public void OnPluginStart()
{
  bLibraryExists = LibraryExists("kento_smashbros");

  HookEvent("weapon_fire", Event_WeaponFire);
  HookEvent("dz_item_interaction", Event_DzItem);
  HookEvent("round_start", Event_RoundStart);
  HookEvent("player_death", Event_PlayerDeath);

  healthshot_health = CreateConVar("sb_healthshot_heal", "50.0", "How many damage will healthshot heal? FLOAT VALUE ONLY", FCVAR_NOTIFY, true, 0.0 );
  healthshot_health.AddChangeHook(OnConVarChanged);

  heavyassaultsuit_def = CreateConVar("sb_heavyassaultsuit_def", "0.5", "Player take damage multiplier to set when player pick up heavyassaultsuit. FLOAT VALUE ONLY", FCVAR_NOTIFY, true, 0.0 );
  heavyassaultsuit_def.AddChangeHook(OnConVarChanged);

  heavyassaultsuit_up = CreateConVar("sb_heavyassaultsuit_up", "0.5", "Player upward force multiplier to set when has heavyassaultsuit. FLOAT VALUE ONLY", FCVAR_NOTIFY, true, 0.0 );
  heavyassaultsuit_up.AddChangeHook(OnConVarChanged);

  heavyassaultsuit_armor = CreateConVar("sb_heavyassaultsuit_armor", "100.0", "How many damage can heavyassaultsuit take before break? FLOAT VALUE ONLY", FCVAR_NOTIFY, true, 0.0 );
  heavyassaultsuit_armor.AddChangeHook(OnConVarChanged);

  heavyassaultsuit_back = CreateConVar("sb_heavyassaultsuit_back", "0.5", "Player pushback multiplier to set when has heavyassaultsuit FLOAT VALUE ONLY", FCVAR_NOTIFY, true, 0.0 );
  heavyassaultsuit_back.AddChangeHook(OnConVarChanged);

  AutoExecConfig(true, "kento_smashbros_csgoweapons");
}

public void OnMapStart()
{
  PrecacheModel("models/props_survival/upgrades/exojump.mdl", true);
  PrecacheModel("models/props_survival/upgrades/parachutepack.mdl", true);

  PrecacheModel("models/player/custom_player/legacy/tm_phoenix_heavy.mdl", true);
  PrecacheModel("models/player/custom_player/legacy/ctm_heavy.mdl", true);
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
  if (convar == healthshot_health) 
  {
    fhealthshot_health = healthshot_health.FloatValue;
  }
  else if (convar == heavyassaultsuit_def) 
  {
    fheavyassaultsuit_def = heavyassaultsuit_def.FloatValue;
  }
  else if (convar == heavyassaultsuit_armor) 
  {
    fcvar_heavyassaultsuit_armor = heavyassaultsuit_armor.FloatValue;
  }
  else if (convar == heavyassaultsuit_up) 
  {
    fheavyassaultsuit_up = heavyassaultsuit_up.FloatValue;
  }
  else if (convar == heavyassaultsuit_back) 
  {
    fheavyassaultsuit_back = heavyassaultsuit_back.FloatValue;
  }
}

public void OnConfigsExecuted()
{
  fhealthshot_health = healthshot_health.FloatValue;
  fheavyassaultsuit_def = heavyassaultsuit_def.FloatValue;
  fcvar_heavyassaultsuit_armor = heavyassaultsuit_armor.FloatValue;
  fheavyassaultsuit_up = heavyassaultsuit_up.FloatValue;
  fheavyassaultsuit_back = heavyassaultsuit_back.FloatValue;
}

public void OnLibraryAdded(const char [] name)
{
  if (StrEqual(name, "kento_smashbros"))
  {
    bLibraryExists = true;
  }
}

public void OnAllPluginsLoaded()
{
  bLibraryExists = LibraryExists("kento_smashbros");
}

public void OnLibraryRemoved(const char [] name)
{
  if (StrEqual(name, "kento_smashbros"))
  {
    bLibraryExists = false;
  }
}

public Action Event_WeaponFire(Event event, const char[] name, bool dontBroadcast)
{
  if(!bLibraryExists) return;

  int client = GetClientOfUserId(event.GetInt("userid"));

  if(IsValidClient(client))
  {
    char weapon[32];
    event.GetString("weapon", weapon, sizeof(weapon));
    
    if(StrContains(weapon, "healthshot") != -1) {
      int entity =  GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
      healthshot[client] = entity;
    }
  }
}

public Action Event_DzItem(Event event, const char[] name, bool dontBroadcast)
{
  if(!bLibraryExists) return;

  int client = GetClientOfUserId(event.GetInt("userid"));
  int subject = event.GetInt("subject");
  char entname[64];
  GetEntityClassname(subject, entname, sizeof(entname));

  if(IsValidClient(client))
  {
    if(StrContains(entname, "heavyarmor") != -1)
    {
      playerDefaultTake[client] = SB_GetClientTakeDamageMultiplier(client);
      SB_SetClientTakeDamageMultiplier(client, fheavyassaultsuit_def);

      playerDefaultUp[client] = SB_GetClientUpwardForce(client);
      SB_SetClientUpwardForce(client, playerDefaultUp[client] * fheavyassaultsuit_up);

      playerDefaultBack[client] = SB_GetClientPushbackMultiplier(client);
      SB_SetClientPushbackMultiplier(client, playerDefaultBack[client] * fheavyassaultsuit_back);

      has_heavyassaultsuit[client] = true;
      fheavyassaultsuit_armor[client] = fcvar_heavyassaultsuit_armor;

      char modelname[256];
      GetEntPropString(client, Prop_Data, "m_ModelName", modelname, sizeof(modelname));
      strcopy(player_default_model[client], sizeof(player_default_model[]), modelname);

      if(GetClientTeam(client) == CS_TEAM_T)
      {
        SetEntityModel(client, "models/player/custom_player/legacy/tm_phoenix_heavy.mdl");
      }
      else if(GetClientTeam(client) == CS_TEAM_CT){
        SetEntityModel(client, "models/player/custom_player/legacy/ctm_heavy.mdl");
      }
    }
  }
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
  if(!bLibraryExists) return;

  int client = GetClientOfUserId(event.GetInt("userid"));
  if(IsValidClient(client))
  {
    Format(player_default_model[client], sizeof(player_default_model[]), "");
    has_heavyassaultsuit[client] = false;
    fheavyassaultsuit_armor[client] = 0.0;
    SetEntProp(client, Prop_Send, "m_bHasHelmet", false);
    SetEntProp(client, Prop_Send, "m_bHasHeavyArmor", false);
    SetEntProp(client, Prop_Send, "m_bWearingSuit", false);
    SetEntProp(client, Prop_Data, "m_ArmorValue", 100);
  }
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
  if(!bLibraryExists) return;

  for (int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i))
    {
      Format(player_default_model[i], sizeof(player_default_model[]), "");
      has_heavyassaultsuit[i] = false;
      fheavyassaultsuit_armor[i] = 0.0;
      SetEntProp(i, Prop_Send, "m_bHasHelmet", false);
      SetEntProp(i, Prop_Send, "m_bHasHeavyArmor", false);
      SetEntProp(i, Prop_Send, "m_bWearingSuit", false);
      SetEntProp(i, Prop_Data, "m_ArmorValue", 100);
    }
  }
}

public void OnEntityDestroyed(int entity)
{
  if(!bLibraryExists) return;

  if(IsValidEdict(entity)) {
    char name[32];
    GetEdictClassname(entity, name, sizeof(name));

    if(StrContains(name, "healthshot") != -1) {
      int owner = -1;
      for (int i = 1; i <= MaxClients; i++)
      {
        if(entity == healthshot[i]) {
          owner = i;
          break;
        }
      }
      if(owner > -1 && IsValidClient(owner))  Heal(owner);
    }
  }
}

void Heal (int client) {
  if(IsValidClient(client) && bLibraryExists) {
    healthshot[client] = -1;
    float clientDMG = SB_GetClientDamage(client);
    clientDMG -= fhealthshot_health;
    SB_SetClientDamage(client, clientDMG);
  }
}

public Action SB_OnTakeDamage (int victim, int attacker, int inflictor, float damage)
{
  if(IsValidClient(victim) && has_heavyassaultsuit[victim])
  {
    fheavyassaultsuit_armor[victim] -= damage;
    
    if(fheavyassaultsuit_armor[victim] <= 0.0)
    {
      has_heavyassaultsuit[victim] = false;
      SetEntityModel(victim, player_default_model[victim]);
      SetEntProp(victim, Prop_Send, "m_bHasHelmet", false);
      SetEntProp(victim, Prop_Send, "m_bHasHeavyArmor", false);
      SetEntProp(victim, Prop_Send, "m_bWearingSuit", false);
      SetEntProp(victim, Prop_Data, "m_ArmorValue", 100);

      SB_SetClientTakeDamageMultiplier(victim, playerDefaultTake[victim]);
      SB_SetClientUpwardForce(victim, playerDefaultUp[victim]);
      SB_SetClientPushbackMultiplier(victim, playerDefaultBack[victim]);
    }
  }
}

public Action SB_OnItemSpawn (const char[] name, float pos[3])
{
  float newpos[3];
  newpos[0] = pos[0];
  newpos[1] = pos[1];
  newpos[2] = pos[2] + 10.0;

  int entity;
  if(StrEqual(name, "weapon_ak47")) {
    entity = CreateEntityByName("weapon_ak47");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_aug")) {
    entity = CreateEntityByName("weapon_aug");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_awp")) {
    entity = CreateEntityByName("weapon_awp");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_axe")) {
    entity = CreateEntityByName("weapon_axe");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_bizon")) {
    entity = CreateEntityByName("weapon_bizon");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_breachcharge")) {
    entity = CreateEntityByName("weapon_breachcharge");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_cz75a")) {
    entity = CreateEntityByName("weapon_cz75a");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_deagle")) {
    entity = CreateEntityByName("weapon_deagle");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_decoy")) {
    entity = CreateEntityByName("weapon_decoy");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_elite")) {
    entity = CreateEntityByName("weapon_elite");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_famas")) {
    entity = CreateEntityByName("weapon_famas");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_fists")) {
    entity = CreateEntityByName("weapon_fists");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_fiveseven")) {
    entity = CreateEntityByName("weapon_fiveseven");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_flashbang")) {
    entity = CreateEntityByName("weapon_flashbang");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_g3sg1")) {
    entity = CreateEntityByName("weapon_g3sg1");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_galilar")) {
    entity = CreateEntityByName("weapon_galilar");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_glock")) {
    entity = CreateEntityByName("weapon_glock");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_hammer")) {
    entity = CreateEntityByName("weapon_hammer");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_healthshot")) {
    entity = CreateEntityByName("weapon_healthshot");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_hegrenade")) {
    entity = CreateEntityByName("weapon_hegrenade");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_hkp2000")) {
    entity = CreateEntityByName("weapon_hkp2000");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_molotov")) {
    entity = CreateEntityByName("weapon_molotov");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_incgrenade")) {
    entity = CreateEntityByName("weapon_incgrenade");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_knife")) {
    entity = CreateEntityByName("weapon_knife");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_knifegg")) {
    entity = CreateEntityByName("weapon_knifegg");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_m249")) {
    entity = CreateEntityByName("weapon_m249");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_m4a1_silencer")) {
    entity = CreateEntityByName("weapon_m4a1_silencer");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_m4a1")) {
    entity = CreateEntityByName("weapon_m4a1");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_mac10")) {
    entity = CreateEntityByName("weapon_mac10");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_mag7")) {
    entity = CreateEntityByName("weapon_mag7");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_mp5sd")) {
    entity = CreateEntityByName("weapon_mp5sd");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_mp7")) {
    entity = CreateEntityByName("weapon_mp7");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_mp9")) {
    entity = CreateEntityByName("weapon_mp9");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_negev")) {
    entity = CreateEntityByName("weapon_negev");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_nova")) {
    entity = CreateEntityByName("weapon_nova");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_p250")) {
    entity = CreateEntityByName("weapon_p250");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_p90")) {
    entity = CreateEntityByName("weapon_p90");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_revolver")) {
    entity = CreateEntityByName("weapon_revolver");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_sawedoff")) {
    entity = CreateEntityByName("weapon_sawedoff");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_scar20")) {
    entity = CreateEntityByName("weapon_scar20");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_sg556")) {
    entity = CreateEntityByName("weapon_sg556");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_shield")) {
    entity = CreateEntityByName("weapon_shield");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_smokegrenade")) {
    entity = CreateEntityByName("weapon_smokegrenade");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_spanner")) {
    entity = CreateEntityByName("weapon_spanner");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_ssg08")) {
    entity = CreateEntityByName("weapon_ssg08");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_tagrenade")) {
    entity = CreateEntityByName("weapon_tagrenade");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_taser")) {
    entity = CreateEntityByName("weapon_taser");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_tec9")) {
    entity = CreateEntityByName("weapon_tec9");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_ump45")) {
    entity = CreateEntityByName("weapon_ump45");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_usp_silencer")) {
    entity = CreateEntityByName("weapon_usp_silencer");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_xm1014")) {
    entity = CreateEntityByName("weapon_xm1014");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "weapon_bumpmine")) {
    entity = CreateEntityByName("weapon_bumpmine");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "item_exosuit")) {
    entity = CreateEntityByName("prop_weapon_upgrade_exojump");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "item_parachute")) {
    entity = CreateEntityByName("prop_weapon_upgrade_chute");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "item_heavyassaultsuit")) {
    entity = CreateEntityByName("prop_weapon_refill_heavyarmor");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }

  else if(StrEqual(name, "dronegun")) {
    entity = CreateEntityByName("dronegun");
    DispatchSpawn(entity);
    TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);
  }
}

stock bool IsValidClient(int client)
{
  if (client <= 0) return false;
  if (client > MaxClients) return false;
  if (!IsClientConnected(client)) return false;
  return IsClientInGame(client);
}

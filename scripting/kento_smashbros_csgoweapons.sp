#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <kento_smashbros>

bool bLibraryExists = false;

public Plugin myinfo =
{
  name = "[CS:GO] Super Smash Bros Item - CSGO Weapons",
  author = "Kento",
  description = "Super Smash Bros Item - CSGO Weapons",
  version = "1.0",
  url = "http://steamcommunity.com/id/kentomatoryoshika/"
};

public void OnPluginStart()
{
  HookEvent("weapon_fire", Event_WeaponFire);
  bLibraryExists = LibraryExists("kento_smashbros");
}

public void OnLibraryAdded(const String:name[])
{
  if (StrEqual(name, "kento_smashbros"))
  {
    bLibraryExists = true;
  }
}

public void OnLibraryRemoved(const String:name[])
{
  if (StrEqual(name, "kento_smashbros"))
  {
    bLibraryExists = false;
  }
}

public Action Event_WeaponFire (Event event, const char[] name, bool dontBroadcast) {
  int client = GetClientOfUserId(event.GetInt("userid"));
  char weapon[32];
  event.GetString("weapon", weapon, sizeof(weapon));
  if(StrEqual(weapon, "weapon_healthshot", false) || StrEqual(weapon, "healthshot", false))
  {
    SB_SetClientDamage(client, SB_GetClientDamage(client) - 50.0);
  }
}

public Action SB_OnItemSpawn (const char[] name, float pos[3])
{
  if(!bLibraryExists) return;

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
}

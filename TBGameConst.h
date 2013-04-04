
typedef enum
{
    kTBTeamUnknown = 0,    
    kTBTeamAlly,
    kTBTeamEnemy,
} TBTeam;


#define MIN_MAP_XPOS                0
#define MAX_MAP_XPOS                4000
#define MAP_GROUND                  40


#define kTBSoundValkyries           @"Valkyries.3gp"
#define kTBSoundHeli                @"heli.caf"
#define kTBSoundVulcan              @"vulcan.caf"
#define kTBSoundTankExplosion       @"tank_explosion.caf"
#define kTBSoundBombExplosion       @"bomb_explosion.caf"


#define kRifleBulletPower           5
#define kVulcanBulletPower          10
#define kBombPower                  50
#define kMissilePower               100
#define kTankShellPower             50


#define kHelicopterDurability       50
#define kTankDurability             100
#define kArmoredVehicleDurability   70
#define kSoldierDurability          10
#define kMissileDurability          20


/*  WEAPON  */
#define kTankGunReloadTime          60
#define kTankGunMaxRange            480
#define kAAVulcanReloadTime         20
#define kAAVulcanMaxRange           700
#define kMissileReloadTime          120
#define kMissileMaxRange            700
#define kRifleReloadTime            20
#define kRifleMaxRange              300


/*  STRUCTURE  */
#define kBaseDurability             1000
#define kLandingPadDurability       300
#define kAAGunSiteDurability        200

#define kLandingPadRepairDamage     5
#define kLandingPadFillUpBullets    5
#define kLandingPadFillUpBombs      1

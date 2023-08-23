unit WMFile;

interface
uses
  SysUtils, Classes, WIL, HGETextures;

const
  OBJECTSCOUNT = 29;
  MONSCOUNT = 53;
  NPCSCOUNT = 3;
  EFFECTCOUNT = 1;
  WEAPONCOUNT = 7;
  HUMCOUNT = 13;
  HUMEFFECTCOUNT = 7;
  ITEMCOUNT = 1;
  HAIRCOUNT = 5;
  MAGICCOUNT = 11;
  ICONSCOUNT = 2;
  TILESCOUNT = 9;           //Tiles File Count           //2014.09.04
  SMTILESCOUNT = 9;         //SmTiles File Count         //2014.09.04
  ANTILESCOUNT = 1;

  OLDMAPDIRNAME = '.\Map\';

  GOODSFILE = 1;
  MAGICFILE = 2;
  MAPDESCFILE = 3;
  MAPEFFECTFILE = 4;
  SHOPHINTFILE = 5;
  MISSIONFILE = 6;



  MAINIMAGEFILE = 'Data\Prguse.wil';
  MAINIMAGEFILE2 = 'Data\Prguse2.wil';
  MAINIMAGEFILE3 = 'Data\Prguse3.wil';
  CHRSELIMAGEFILE = 'Data\ChrSel.wil';

  NEWOPUIFILE = 'Data\NewopUI.wil';
  MINMAPIMAGEFILE = 'Data\mmap.wil';
  STATEITEMIMAGEFILE = 'Data\stateitem.wil';
  STATEEFFECTIMAGEFILE = 'Data\StateEffect.wil';
  UI1FILE = 'Data\ui1.wil';
  NEWSELECT = 'Data\nselect.wil';
  BAGITEMIMAGESFILE   = 'Data\Items.wil';
  DNITEMIMAGESFILE = 'Data\DnItems.wil';

  Images_Begin = 0;
  Images_Prguse = Images_Begin;
  Images_Prguse2 = 1;
  Images_Prguse3 = 2;
  Images_ChrSel = 3;
  Images_Stateitem = 4;
  Images_StateEffect = 5;
  Images_mmap = 6;
  Images_ui1 = 7;
  Images_NSelect = 8;
  Images_NewopUI = 9;
  Images_TilesBegin = 10;
  Images_TilesEnd = Images_TilesBegin + TILESCOUNT;
  Images_SmTilesBegin = Images_TilesEnd + 1;
  Images_SmTilesEnd = Images_SmTilesBegin + SMTILESCOUNT;

  Images_AnTilesBegin  = Images_SmTilesEnd + 1;
  Images_AnTilesEnd = Images_AnTilesBegin + ANTILESCOUNT;
  Images_ObjectBegin = Images_AnTilesEnd + 1;
  Images_ObjectEnd = Images_ObjectBegin + OBJECTSCOUNT;
  Images_HumBegin = Images_ObjectEnd + 1;
  Images_HumEnd = Images_HumBegin + HUMCOUNT;

  Images_HumEffectBegin = Images_HumEnd + 1;
  Images_HumEffectEnd = Images_HumEffectBegin + HUMEFFECTCOUNT;

  Images_HumHairBegin = Images_HumEffectEnd + 1;
  Images_HumHairEnd = Images_HumHairBegin + HAIRCOUNT;

  Images_MagicBegin = Images_HumHairEnd + 1;
  Images_MagicEnd = Images_MagicBegin + MAGICCOUNT;

  Images_NpcBegin = Images_MagicEnd + 1;
  Images_NpcEnd = Images_NpcBegin + NPCSCOUNT;

  Images_MonBegin = Images_NpcEnd + 1;
  Images_MonEnd = Images_MonBegin + MONSCOUNT;

  Images_WeaponBegin = Images_MonEnd + 1;
  Images_WeaponEnd = Images_WeaponBegin + WEAPONCOUNT;
  Images_BagItems = Images_WeaponEnd + 1;
  Images_DnItems  = Images_BagItems + 1;
  Images_IconsBegin = Images_DnItems + 1;
  Images_IconsEnd = Images_IconsBegin + ICONSCOUNT;

  Images_EffectBegin = Images_IconsEnd + 1;
  Images_EffectEnd = Images_EffectBegin + EFFECTCOUNT;

  Images_end = Images_EffectEnd;


var
  g_ClientImages: array[Images_Begin..Images_End] of TWMImages;
  g_WMainImages: TWMImages;
  g_WMain2Images: TWMImages;
  g_WMain3Images: TWMImages;
  g_WChrSelImages: TWMImages;
  g_StateEffectImages: TWMImages;
  g_StateitemImages: TWMImages;
  g_WUI1Images: TWMImages;
  g_NewopUIImages:TWMImages;
  g_NSelectImages: TWMImages;
  g_WBagItemImages: TWMImages;
  g_WDnItemImages: TWMImages;
  g_WEffectImages: array[0..EFFECTCOUNT] of TWMImages;
  g_WTilesImages:  array[0..TILESCOUNT] of TWMImages;       //2014.09.04
  g_WSmTilesImages:array[0..SMTILESCOUNT] of TWMImages;     //2014.09.04
  g_WObjects: array[0..OBJECTSCOUNT] of TWMImages;          //2014.09.04
  g_WHums: array[0..HUMCOUNT] of TWMImages;                 //2015.04.18
  g_WHumEffects: array[0..HUMEFFECTCOUNT] of TWMImages;     //2016.04.27
  g_WHumHair: array[0..HAIRCOUNT] of TWMImages;             //2015.04.18
  g_WMagicImages: array[0..MAGICCOUNT] of TWMImages;        //2016.05.01
  g_WAnTilesImages: array[0..ANTILESCOUNT] of TWMImages;    //新动态地图
  g_WMMapImages: TWMImages;                                 //2015.06.16
  g_WNpcs: array[0..NPCSCOUNT] of TWMImages;
  g_WMons: array[0..MONSCOUNT] of TWMImages;
  g_WWeapons: array[0..WEAPONCOUNT] of TWMImages;
  g_WIconsImages:array[0..ICONSCOUNT] of TWMImages;

var

  g_WIconsFiles: array[0..ICONSCOUNT] of string = (
    'Data\MagIcon.wil',
    'Data\MagIcon2.wil',
    'magicon_horse.wil'
  );

  g_WTilesFiles: array[0 .. TILESCOUNT] of string = (
    'Data\Tiles.wil',
    'Data\Tiles2.wil',
    'Data\Tiles3.wil',
    'Data\Tiles4.wil',
    'Data\Tiles5.wil',
    'Data\Tiles6.wil',
    'Data\Tiles7.wil',
    'Data\Tiles8.wil',
    'Data\Tiles9.wil',
    'Data\Tiles10.wil'
  );

  g_WSmTilesFiles: array[0 .. SMTILESCOUNT] of string = (
    'Data\SmTiles.wil',
    'Data\SmTiles2.wil',
    'Data\SmTiles3.wil',
    'Data\SmTiles4.wil',
    'Data\SmTiles5.wil',
    'Data\SmTiles6.wil',
    'Data\SmTiles7.wil',
    'Data\SmTiles8.wil',
    'Data\SmTiles9.wil',
    'Data\SmTiles10.wil'
  );

  g_WAnTilesFiles: array[0 .. ANTILESCOUNT] of string = (
    'Data\AniTiles1.wil',
    'Data\AniTiles2.wil'
  );

  g_WObjectFiles: array[0..OBJECTSCOUNT] of string = (
    'Data\Objects.wil',
    'Data\Objects2.wil',
    'Data\Objects3.wil',
    'Data\Objects4.wil',
    'Data\Objects5.wil',
    'Data\Objects6.wil',
    'Data\Objects7.wil',
    'Data\Objects8.wil',
    'Data\Objects9.wil',
    'Data\Objects10.wil',
    'Data\Objects11.wil',
    'Data\Objects12.wil',
    'Data\Objects13.wil',
    'Data\Objects14.wil',
    'Data\Objects15.wil',
    'Data\Objects16.wil',
    'Data\Objects17.wil',
    'Data\Objects18.wil',
    'Data\Objects19.wil',
    'Data\Objects20.wil',  {19}
    'Data\Objects21.wil',
    'Data\Objects22.wil',
    'Data\Objects23.wil',
    'Data\Objects24.wil',
    'Data\Objects25.wil',
    'Data\Objects26.wil',
    'Data\Objects27.wil',
    'Data\Objects28.wil',
    'Data\Objects29.wil',
    'Data\Objects30.wil'  {29}
    );

    g_WHumFiles: array[0..HUMCOUNT] of string = (
    'Data\Hum.wil',          //0
    'Data\Hum2.wil',         //1
    'Data\Hum3.wil',         //2
    'Data\Hum4.wil',         //3
    'Data\Hum5.wil',         //4
    'Data\horse.wil',        //5
    'Data\Hum6.wil',         //6
    'Data\Hum7.wil',         //7
    'Data\Hum8.wil',         //8
    'Data\hum_ck.wil',       //9 刺客职业  ASSASSIN_OFFSET
    'Data\hum_ck02.wil',     //10
    'Data\hum_ck03.wil',     //11
    'Data\hum_ck7.wil',      //12
    'Data\hum_ck8.wil'       //13
    );

    g_WHumEffectFiles: array[0..HUMEFFECTCOUNT] of string = (
    'Data\HumEffect.wil',
    'Data\HumEffect2.wil',
    'Data\HumEffect3.wil',
    'Data\HumEffect4.wil',
    'Data\HumEffect5.wil',
    'Data\HumEffect6.wil',
    'Data\HumEffect7.wil',
    'Data\HumEffect8.wil'
    );


    g_WHairFiles: array[0..HAIRCOUNT] of string = (
    'Data\Hair.wil',         //0
    'Data\Hair2.wil',        //1
    'Data\Hair3.wil',        //2
    'Data\Hair4.wil',        //3
    'Data\hair_ck.wil',      //4   ASSASSIN_HAIR_OFFSET
    'Data\hair4_ck.wil'      //5
    );

    g_WMagicFiles: array[0..MAGICCOUNT] of string = (
    'Data\Magic.wil',        //0
    'Data\Magic1.wil',       //1
    'Data\Magic2.wil',       //2
    'Data\Magic3.wil',       //3
    'Data\Magic4.wil',       //4
    'Data\Magic5.wil',       //5
    'Data\Magic6.wil',       //6
    'Data\Magic7.wil',       //7
    'Data\Magic8.wil',       //8
    'Data\Magic9.wil',       //9
    'Data\Magic10.wil',      //10
    'Data\Magic11.wil'       //11
    );


    g_WNpcFiles: array[0..NPCSCOUNT] of string = (
    'Data\Npc.wil',
    'Data\Npc2.wil',
    'Data\Npc3.wil',
    'Data\Npc4.wil'
    );

    g_WMonFiles: array[0..MONSCOUNT] of string = (
    'Data\Mon0.wil',
    'Data\Mon1.wil',
    'Data\Mon2.wil',
    'Data\Mon3.wil',
    'Data\Mon4.wil',
    'Data\Mon5.wil',
    'Data\Mon6.wil',
    'Data\Mon7.wil',
    'Data\Mon8.wil',
    'Data\Mon9.wil',
    'Data\Mon10.wil',
    'Data\Mon11.wil',
    'Data\Mon12.wil',
    'Data\Mon13.wil',
    'Data\Mon14.wil',
    'Data\Mon15.wil',
    'Data\Mon16.wil',
    'Data\Mon17.wil',
    'Data\Mon18.wil',
    'Data\Mon19.wil',
    'Data\Mon20.wil',
    'Data\Mon21.wil',
    'Data\Mon22.wil',
    'Data\Mon23.wil',
    'Data\Mon24.wil',
    'Data\Mon25.wil',
    'Data\Mon26.wil',
    'Data\Mon27.wil',
    'Data\Mon28.wil',
    'Data\Mon29.wil',
    'Data\Mon30.wil',
    'Data\Mon31.wil',
    'Data\Mon32.wil',
    'Data\Mon33.wil',
    'Data\Mon34.wil',
    'Data\Mon35.wil',
    'Data\Mon36.wil',
    'Data\Mon37.wil',
    'Data\Mon38.wil',
    'Data\Mon39.wil',
    'Data\Mon40.wil',
    'Data\Mon41.wil',
    'Data\Mon42.wil',
    'Data\Mon43.wil',
    'Data\Mon44.wil',
    'Data\Mon45.wil',
    'Data\Mon46.wil',
    'Data\Mon47.wil',
    'Data\Mon48.wil',
    'Data\Mon49.wil',
    'Data\Mon50.wil',
    'Data\Mon51.wil',
    'Data\Mon52.wil',
    'Data\Mon53.wil'
    );
   g_WWeaponFiles: array[0..WEAPONCOUNT] of string = (
    'Data\Weapon.wil',      //0
    'Data\Weapon2.wil',     //1
    'Data\Weapon3.wil',     //2
    'Data\Weapon4.wil',     //3
    'Data\Weapon5.wil',     //4
    'Data\Weapon6.wil',     //5
    'Data\Weapon7.wil',     //6
    'Data\Weapon8.wil'      //7
    );

   g_WEffectFiles: array[0..EFFECTCOUNT] of string = (
      'Data\Effect.wil',
      'Data\Effect2.wis'
   );

procedure LoadWMImagesLib;
procedure InitWMImagesLib(password: string);
procedure UnLoadWMImagesLib();
function GetObjsEx(nUnit, nIdx: Integer; var px, py: Integer): TDirectDrawSurface;
function GetStateItemImgXY(nIndex: Integer; var ax, ay: Integer): TDirectDrawSurface;
implementation

procedure RefClientImages();
var
  i: Integer;
begin
  for I := Low(g_ClientImages) to High(g_ClientImages) do begin
    g_ClientImages[I] := nil;
    case I of
      Images_Prguse: g_ClientImages[I] := g_WMainImages;
      Images_Prguse2: g_ClientImages[I] := g_WMain2Images;
      Images_Prguse3: g_ClientImages[I] := g_WMain3Images;
      Images_ChrSel: g_ClientImages[I] := g_WChrSelImages;
      Images_Stateitem: g_ClientImages[I] := g_StateitemImages;
      Images_StateEffect: g_ClientImages[I] := g_StateEffectImages;
      Images_ui1: g_ClientImages[I] := g_WUI1Images;
      Images_NSelect: g_ClientImages[I] := g_NSelectImages;
      Images_NewopUI:g_ClientImages[I] := g_NewopUIImages;
      Images_mmap: g_ClientImages[I] := g_WMMapImages;
      Images_BagItems: g_ClientImages[I]:= g_WBagItemImages;
      Images_DnItems: g_ClientImages[I]:= g_WDnItemImages;
      Images_AnTilesBegin..Images_AnTilesEnd: begin
        g_ClientImages[I] := g_WAnTilesImages[I - Images_AnTilesBegin];
      end;
      Images_Tilesbegin..Images_TilesEnd:begin
        g_ClientImages[I] := g_WTilesImages[I - Images_Tilesbegin];
      end;
      Images_SmTilesBegin..Images_SmTilesEnd:begin
        g_ClientImages[I] := g_WSmTilesImages[I - Images_SmTilesBegin];
      end;
      Images_HumBegin.. Images_HumEnd:begin
        g_ClientImages[I] := g_WHums[I - Images_HumBegin];
      end;
      Images_HumEffectBegin..Images_HumEffectEnd: begin
        g_ClientImages[I] := g_WHumEffects[I - Images_HumEffectBegin];
      end;
      Images_HumHairBegin..Images_HumHairEnd:begin
        g_ClientImages[I] := g_WHumHair[I - Images_HumHairBegin];
      end;
      Images_MagicBegin..Images_MagicEnd:begin
        g_ClientImages[I] := g_WMagicImages[I - Images_MagicBegin];
      end;
      Images_ObjectBegin..Images_ObjectEnd: begin
        g_ClientImages[I] := g_WObjects[I - Images_ObjectBegin];
      end;
      Images_NpcBegin..Images_NpcEnd: begin
        g_ClientImages[I] := g_WNpcs[I - Images_NpcBegin];
      end;
      Images_MonBegin..Images_MonEnd: begin
        g_ClientImages[I] := g_WMons[I - Images_MonBegin];
      end;
      Images_WeaponBegin..Images_WeaponEnd: begin
        g_ClientImages[I] := g_WWeapons[I - Images_WeaponBegin];
      end;
      Images_IconsBegin..Images_IconsEnd:begin
        g_ClientImages[I] := g_WIconsImages[I - Images_IconsBegin];
      end;
      Images_EffectBegin..Images_EffectEnd:begin
        g_ClientImages[I] := g_WEffectImages[I - Images_EffectBegin];
      end;
    end;
  end;
end;

procedure LoadWMImagesLib;
var
  Index: Integer;
begin
  g_WMainImages := CreateWMImages(t_wmM2Def);
  g_WMain2Images := CreateWMImages(t_wmM2Def);
  g_WMain3Images := CreateWMImages(t_wmM2Def);
  g_WChrSelImages := CreateWMImages(t_wmM2Def);
  g_StateitemImages := CreateWMImages(t_wmM2Def);
  g_StateEffectImages := CreateWMImages(t_wmM2Def);
  g_WUI1Images := CreateWMImages(t_wmM2Def);
  g_NSelectImages := CreateWMImages(t_wmM2Def);
  g_NewopUIImages := CreateWMImages(t_wmM2Def);
  g_WMMapImages := CreateWMImages(t_wmM2Def);

  g_WBagItemImages := CreateWMImages(t_wmM2Def);
  g_WDnItemImages := CreateWMImages(t_wmM2Def);
  //2014.09.04
  for Index := Low(g_WTilesImages) to High(g_WTilesImages) do begin
    g_WTilesImages[Index] := CreateWMImages(t_wmM2Def);
  end;
  //2014.09.04
  for Index := Low(g_WSmTilesImages) to High(g_WSmTilesImages) do begin
    g_WSmTilesImages[Index] := CreateWMImages(t_wmM2Def);
  end;
  //2014.09.04
  for Index := Low(g_WAnTilesImages) to High(g_WAnTilesImages) do begin
    g_WAnTilesImages[Index] := CreateWMImages(t_wmM2Def);
  end;
  //2014.09.04
  for Index := Low(g_WObjects) to High(g_WObjects) do begin
    g_WObjects[Index] := CreateWMImages(t_wmM2Def);
  end;
  //2015.04.18
  for Index := Low(g_WHums) to High(g_WHums) do begin
    g_WHums[Index] := CreateWMImages(t_wmM2Def);
  end;

  for Index := Low(g_WHumEffects) to High(g_WHumEffects) do begin
    g_WHumEffects[Index] := CreateWMImages(t_wmM2Def);
  end;

  //2015.04.18
  for Index := Low(g_WHumHair) to High(g_WHumHair) do begin
    g_WHumHair[Index] := CreateWMImages(t_wmM2Def);
  end;

  //2015.04.18
  for Index := Low(g_WMagicImages) to High(g_WMagicImages) do begin
    g_WMagicImages[Index] := CreateWMImages(t_wmM2Def);
  end;

  //2015.04.18
  for Index := Low(g_WNpcs) to High(g_WNpcs) do begin
    g_WNpcs[Index] := CreateWMImages(t_wmM2Def);
  end;
  for Index := Low(g_WMons) to High(g_WMons) do begin
    g_WMons[Index] := CreateWMImages(t_wmM2Def);
  end;

  for Index := Low(g_WWeapons) to High(g_WWeapons) do begin
    g_WWeapons[Index] := CreateWMImages(t_wmM2Def);
  end;

  for Index := Low(g_WIconsImages) to High(g_WIconsImages) do begin
    g_WIconsImages[Index] := CreateWMImages(t_wmM2Def);
  end;

  for Index := Low(g_WEffectImages) to High(g_WEffectImages) do begin
    g_WEffectImages[Index] := CreateWMImages(t_wmM2Def);
  end;

  RefClientImages();
end;

procedure InitWMImagesLib(password: string);
  procedure InitializeImage(var AWMImages: TWMImages);
  var
    sFileName, sPassword: string;
    vLibType: TLibType;
  begin
    if (not AWMImages.Initialize()) and (AWMImages.FileName <> '') and (AWMImages.WILType in [t_wmM2Def, t_wmM2wis]) then
    begin
      sFileName := ChangeFileExt(AWMImages.FileName, '.wzl');
      vLibType := AWMImages.LibType;
      sPassword := AWMImages.Password;
      AWMImages.Finalize;
      AWMImages.Free;
      AWMImages := CreateWMImages(t_wmM2Zip);
      AWMImages.FileName := sFileName;
      AWMImages.LibType := vLibType;
      AWMImages.Password := sPassword;
      AWMImages.Initialize();
    end;
  end;
var
  Index:Integer;
begin
  password := '';
  g_WMainImages.FileName :=  MAINIMAGEFILE;
  g_WMainImages.LibType := ltUseCache;
  g_WMainImages.Password := password;
  InitializeImage(g_WMainImages);

  g_WMain2Images.FileName := MAINIMAGEFILE2;
  g_WMain2Images.LibType := ltUseCache;
  g_WMain2Images.Password := password;
  InitializeImage(g_WMain2Images);

  g_WMain3Images.FileName := MAINIMAGEFILE3;
  g_WMain3Images.LibType := ltUseCache;
  g_WMain3Images.Password := password;
  InitializeImage(g_WMain3Images);

  g_WChrSelImages.FileName := CHRSELIMAGEFILE;
  g_WChrSelImages.LibType := ltUseCache;
  g_WChrSelImages.Password := password;
  InitializeImage(g_WChrSelImages);

  g_WBagItemImages.FileName := BAGITEMIMAGESFILE;
  g_WBagItemImages.LibType := ltUseCache;
  g_WBagItemImages.Password := password;
  InitializeImage(g_WBagItemImages);

  g_WDnItemImages.FileName := DNITEMIMAGESFILE;
  g_WDnItemImages.LibType := ltUseCache;
  g_WDnItemImages.Password := password;
  InitializeImage(g_WDnItemImages);

  g_StateitemImages.FileName := STATEITEMIMAGEFILE;
  g_StateitemImages.LibType := ltUseCache;
  g_StateitemImages.Password := password;
  InitializeImage(g_StateitemImages);

  g_StateEffectImages.FileName := STATEEFFECTIMAGEFILE;
  g_StateEffectImages.LibType := ltUseCache;
  g_StateEffectImages.Password := password;
  InitializeImage(g_StateEffectImages);

  g_WUI1Images.FileName := UI1FILE;
  g_WUI1Images.LibType := ltUseCache;
  g_WUI1Images.Password := password;
  InitializeImage(g_WUI1Images);

  g_NSelectImages.FileName := NEWSELECT;
  g_NSelectImages.LibType := ltUseCache;
  g_NSelectImages.Password := password;
  InitializeImage(g_NSelectImages);

  g_NewopUIImages.FileName := NEWOPUIFILE;
  g_NewopUIImages.LibType := ltUseCache;
  g_NewopUIImages.Password := password;
  InitializeImage(g_NewopUIImages);

  g_WMMapImages.FileName := MINMAPIMAGEFILE;
  g_WMMapImages.LibType := ltUseCache;
  g_WMMapImages.Password := password;
  InitializeImage(g_WMMapImages);

  for Index := Low(g_WTilesImages) to High(g_WTilesImages) do begin           //2014.09.04
    g_WTilesImages[Index].FileName := g_WTilesFiles[Index];
    g_WTilesImages[Index].LibType := ltUseCache;
    g_WTilesImages[Index].Password := password;
    InitializeImage(g_WTilesImages[Index]);
  end;

  for Index := Low(g_WSmTilesImages) to High(g_WSmTilesImages) do begin       //2014.09.04
    g_WSmTilesImages[Index].FileName := g_WSmTilesFiles[Index];
    g_WSmTilesImages[Index].LibType := ltUseCache;
    g_WSmTilesImages[Index].Password := password;
    InitializeImage(g_WSmTilesImages[Index]);
  end;

  for Index := Low(g_WAnTilesImages) to High(g_WAnTilesImages) do begin       //2014.09.04
    g_WAnTilesImages[Index].FileName := g_WAnTilesFiles[Index];
    g_WAnTilesImages[Index].LibType := ltUseCache;
    g_WAnTilesImages[Index].Password := password;
    InitializeImage(g_WAnTilesImages[Index]);
  end;

  for Index := Low(g_WObjects) to High(g_WObjects) do begin
    g_WObjects[Index].FileName := g_WObjectFiles[Index];
    g_WObjects[Index].LibType := ltUseCache;
    g_WObjects[Index].Password := password;
    InitializeImage(g_WObjects[Index]);
  end;

  for Index := Low(g_WHums) to High(g_WHums) do begin
    g_WHums[Index].FileName := g_WHumFiles[Index];
    g_WHums[Index].LibType := ltUseCache;
    g_WHums[Index].Password := password;
    InitializeImage(g_WHums[Index]);
  end;

  for Index := Low(g_WHumEffects) to High(g_WHumEffects) do begin
    g_WHumEffects[Index].FileName := g_WHumEffectFiles[Index];
    g_WHumEffects[Index].LibType := ltUseCache;
    g_WHumEffects[Index].Password := password;
    InitializeImage(g_WHumEffects[Index]);
  end;

  for Index := Low(g_WHumHair) to High(g_WHumHair) do begin
    g_WHumHair[Index].FileName := g_WHairFiles[Index];
    g_WHumHair[Index].LibType := ltUseCache;
    g_WHumHair[Index].Password := password;
    InitializeImage(g_WHumHair[Index]);
  end;

  for Index := Low(g_WMagicImages) to High(g_WMagicImages) do begin
    g_WMagicImages[Index].FileName := g_WMagicFiles[Index];
    g_WMagicImages[Index].LibType := ltUseCache;
    g_WMagicImages[Index].Password := password;
    InitializeImage(g_WMagicImages[Index]);
  end;

  for Index := Low(g_WNpcs) to High(g_WNpcs) do begin
    g_WNpcs[Index].FileName := g_WNpcFiles[Index];
    g_WNpcs[Index].LibType := ltUseCache;
    g_WNpcs[Index].Password := password;
    InitializeImage(g_WNpcs[Index]);
  end;

  for Index := Low(g_WMons) to High(g_WMons) do begin
    g_WMons[Index].FileName := g_WMonFiles[Index];
    g_WMons[Index].LibType := ltUseCache;
    g_WMons[Index].Password := password;
    InitializeImage(g_WMons[Index]);
  end;
  for Index := Low(g_WWeapons) to High(g_WWeapons) do begin
    g_WWeapons[Index].FileName := g_WWeaponFiles[Index];
    g_WWeapons[Index].LibType := ltUseCache;
    g_WWeapons[Index].Password := password;
    InitializeImage(g_WWeapons[Index]);
  end;
  for Index := Low(g_WIconsImages) to High(g_WIconsImages) do begin
    g_WIconsImages[Index].FileName := g_WIconsFiles[Index];
    g_WIconsImages[Index].LibType := ltUseCache;
    g_WIconsImages[Index].Password := password;
    InitializeImage(g_WIconsImages[Index]);
  end;

  for Index := Low(g_WEffectImages) to High(g_WEffectImages) do begin
    g_WEffectImages[Index].FileName := g_WEffectFiles[Index];
    g_WEffectImages[Index].LibType := ltUseCache;
    g_WEffectImages[Index].Password := password;
    InitializeImage(g_WEffectImages[Index]);
  end;
  RefClientImages();
end;

function GetStateItemImgXY(nIndex: Integer; var ax, ay: Integer): TDirectDrawSurface;
var
  nUnit, nItemIndex: Integer;
begin
  Result := nil;
  nUnit := nIndex div 10000;
  nItemIndex := nIndex mod 10000;
  if (nUnit >= 0) and (nUnit <= ITEMCOUNT) then begin
    Result := g_NSelectImages.GetCachedImage(nItemIndex, ax, ay);
  end;
end;

procedure UnLoadWMImagesLib();
var
  Index: Integer;
begin
  for Index := Low(g_ClientImages) to High(g_ClientImages) do begin
    if g_ClientImages[Index] <> nil then begin
      g_ClientImages[Index].Finalize;
      g_ClientImages[Index].Free;
      g_ClientImages[Index] := nil;
    end;
  end;

 { for Index := Low(g_WHums) to High(g_WHums) do begin
    if g_WHums[Index] <> nil then begin
      g_WHums[Index].Finalize;
      g_WHums[Index].Free;
      g_WHums[Index] := nil;
    end;
  end;  }
end;

function GetObjsEx(nUnit, nIdx: Integer; var px, py: Integer): TDirectDrawSurface;
begin
  Result := nil;
  if (nUnit >= 0) and (nUnit <= OBJECTSCOUNT) then begin
    Result := g_WObjects[nUnit].GetCachedImage(nIdx, px, py);
  end;
end;

initialization
  begin
    FillChar(g_ClientImages, SizeOf(g_ClientImages), #0);
  end;

finalization
  begin
  end;

end.


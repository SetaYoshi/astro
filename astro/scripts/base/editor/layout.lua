local Block = {
  {'Block', 01, 01}, {'Block', 01, 02}, {'Block', 01, 03}, {'Block', 01, 10}, {'Block', 01, 11}, {'Block', 11, 01},
  {'Block', 01, 04}, {'Block', 01, 05}, {'Block', 01, 06}, {'Block', 01, 12}, {'Block', 01, 13}, {'Block', 12, 01},
  {'Block', 01, 07}, {'Block', 01, 08}, {'Block', 01, 09}, {'Block', 09, 01}, {'Block', 09, 02}, {'Block', 09, 03},
  {'Block', 00, 01}, {'Block', 00, 02}, {'Block', 00, 03}, {'Block', 10, 01}, {'Block', 10, 02}, {'Block', 10, 03},

  {'Block', 02, 01}, {'Block', 02, 02}, {'Block', 02, 03}, {'Block', 02, 10}, {'Block', 02, 11}, {'Block', 00, 01},
  {'Block', 02, 04}, {'Block', 02, 05}, {'Block', 02, 06}, {'Block', 02, 12}, {'Block', 02, 13}, {'Block', 00, 01},
  {'Block', 02, 07}, {'Block', 02, 08}, {'Block', 02, 09}, {'Block', 00, 01}, {'Block', 00, 01}, {'Block', 00, 01},

  {'Block', 03, 01}, {'Block', 03, 02}, {'Block', 03, 03}, {'Block', 03, 10}, {'Block', 03, 11}, {'Block', 00, 01},
  {'Block', 03, 04}, {'Block', 03, 05}, {'Block', 03, 06}, {'Block', 03, 12}, {'Block', 03, 13}, {'Block', 00, 01},
  {'Block', 03, 07}, {'Block', 03, 08}, {'Block', 03, 09}, {'Block', 00, 01}, {'Block', 00, 01}, {'Block', 00, 01},
  {'Block', 03, 14}, {'Block', 03, 15}, {'Block', 03, 16}, {'Block', 00, 01}, {'Block', 00, 01}, {'Block', 00, 01},
  
  {'Block', 04, 01}, {'Block', 04, 02}, {'Block', 04, 03}, {'Block', 04, 10}, {'Block', 04, 11}, {'Block', 00, 01},
  {'Block', 04, 04}, {'Block', 04, 05}, {'Block', 04, 06}, {'Block', 04, 12}, {'Block', 04, 13}, {'Block', 00, 01},
  {'Block', 04, 07}, {'Block', 04, 08}, {'Block', 04, 09}, {'Block', 00, 01}, {'Block', 00, 01}, {'Block', 00, 01},
  {'Block', 04, 14}, {'Block', 04, 15}, {'Block', 04, 16}, {'Block', 00, 01}, {'Block', 00, 01}, {'Block', 00, 01},

  {'Block', 05, 01}, {'Block', 05, 02}, {'Block', 05, 03}, {'Block', 05, 10}, {'Block', 05, 11}, {'Block', 00, 01},
  {'Block', 05, 04}, {'Block', 05, 05}, {'Block', 05, 06}, {'Block', 05, 12}, {'Block', 05, 13}, {'Block', 00, 01},
  {'Block', 05, 07}, {'Block', 05, 08}, {'Block', 05, 09}, {'Block', 00, 01}, {'Block', 00, 01}, {'Block', 00, 01},

  {'Block', 06, 01}, {'Block', 07, 01}, {'Block', 08, 01}, {'Block', 00, 10}, {'Block', 00, 11}, {'Block', 00, 01},

  {'Block', 13, 01}, {'Block', 13, 02}, {'Block', 13, 03}, {'Block', 13, 04}, {'Block', 00, 11}, {'Block', 00, 01},

  {'Block', 14, 01}, {'Block', 14, 04}, {'Block', 14, 07}, {'Block', 14, 10}, {'Block', 00, 11}, {'Block', 00, 01},
  {'Block', 14, 02}, {'Block', 14, 05}, {'Block', 14, 08}, {'Block', 14, 11}, {'Block', 00, 11}, {'Block', 00, 01},
  {'Block', 14, 03}, {'Block', 14, 06}, {'Block', 14, 09}, {'Block', 14, 12}, {'Block', 00, 11}, {'Block', 00, 01},

  {'Block', 15, 01}, {'Block', 15, 02}, {'Block', 15, 03}, {'Block', 15, 04}, {'Block', 15, 05}, {'Block', 15, 06},
  {'Block', 15, 07}, {'Block', 15, 08}, {'Block', 15, 09}, {'Block', 15, 10}, {'Block', 15, 11}, {'Block', 15, 12},

  {'Block', 16, 01}, {'Block', 16, 02}, {'Block', 16, 03}, {'Block', 16, 04}, {'Block', 16, 05}, {'Block', 00, 12},

  {'Block', 17, 01}, {'Block', 18, 01}, {'Block', 18, 02}, {'Block', 19, 01}, {'Block', 19, 02}, {'Block', 19, 03},
}

local NPC = {
  {'NPC'  , 01, 01}, {'NPC'  , 01, 02}, {'NPC'  , 00, 03}, {'NPC'  , 00, 10}, {'NPC'  , 00, 11}, {'NPC'  , 00, 01},
  {'NPC'  , 02, 01}, {'NPC'  , 00, 02}, {'NPC'  , 00, 03}, {'NPC'  , 00, 10}, {'NPC'  , 00, 11}, {'NPC'  , 00, 01},
}

local BGO = {
  {'BGO'  , 01, 01}, {'BGO'  , 00, 02}, {'BGO'  , 00, 03}, {'BGO'  , 00, 10}, {'BGO'  , 00, 11}, {'BGO'  , 00, 01},
}

return {Block = Block, NPC = NPC, BGO = BGO}
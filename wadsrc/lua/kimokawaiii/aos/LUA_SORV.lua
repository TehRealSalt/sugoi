// --------------------------------------
// LUA_SORV
// Sorilver player information
// --------------------------------------
local frameinfo = {}
frameinfo[0] = {}
frameinfo[0].rotatenum = 1		// Frame rotation (based on the object's rotation). If this is 1, no rotation. 8 would be 8 way rotation (I.E. east, northeast, north, etc.)
frameinfo[0].frames = {}
frameinfo[0].frames[0] = "SORVIDL1"
frameinfo[1] = {}
frameinfo[1].rotatenum = 24
frameinfo[1].frames = {}
frameinfo[1].frames[0] = "SORVD1_A"
frameinfo[1].frames[1] = "SORVD1_B"
frameinfo[1].frames[2] = "SORVD1_C"
frameinfo[1].frames[3] = "SORVD1_D"
frameinfo[1].frames[4] = "SORVD1_E"
frameinfo[1].frames[5] = "SORVD1_F"
frameinfo[1].frames[6] = "SORVD1_G"
frameinfo[1].frames[7] = "SORVD1_H"
frameinfo[1].frames[8] = "SORVD1_I"
frameinfo[1].frames[9] = "SORVD1_J"
frameinfo[1].frames[10] = "SORVD1_K"
frameinfo[1].frames[11] = "SORVD1_L"
frameinfo[1].frames[12] = "SORVD1_M"
frameinfo[1].frames[13] = "SORVD1_N"
frameinfo[1].frames[14] = "SORVD1_O"
frameinfo[1].frames[15] = "SORVD1_P"
frameinfo[1].frames[16] = "SORVD1_Q"
frameinfo[1].frames[17] = "SORVD1_R"
frameinfo[1].frames[18] = "SORVD1_S"
frameinfo[1].frames[19] = "SORVD1_T"
frameinfo[1].frames[20] = "SORVD1_U"
frameinfo[1].frames[21] = "SORVD1_V"
frameinfo[1].frames[22] = "SORVD1_W"
frameinfo[1].frames[23] = "SORVD1_X"
frameinfo[2] = {}
frameinfo[2].rotatenum = 24
frameinfo[2].frames = {}
frameinfo[2].frames[0] = "SORVD2_A"
frameinfo[2].frames[1] = "SORVD2_B"
frameinfo[2].frames[2] = "SORVD2_C"
frameinfo[2].frames[3] = "SORVD2_D"
frameinfo[2].frames[4] = "SORVD2_E"
frameinfo[2].frames[5] = "SORVD2_F"
frameinfo[2].frames[6] = "SORVD2_G"
frameinfo[2].frames[7] = "SORVD1_H"
frameinfo[2].frames[8] = "SORVD1_I"
frameinfo[2].frames[9] = "SORVD1_J"
frameinfo[2].frames[10] = "SORVD1_K"
frameinfo[2].frames[11] = "SORVD1_L"
frameinfo[2].frames[12] = "SORVD1_M"
frameinfo[2].frames[13] = "SORVD1_N"
frameinfo[2].frames[14] = "SORVD1_O"
frameinfo[2].frames[15] = "SORVD1_P"
frameinfo[2].frames[16] = "SORVD1_Q"
frameinfo[2].frames[17] = "SORVD1_R"
frameinfo[2].frames[18] = "SORVD2_S"
frameinfo[2].frames[19] = "SORVD2_T"
frameinfo[2].frames[20] = "SORVD2_U"
frameinfo[2].frames[21] = "SORVD2_V"
frameinfo[2].frames[22] = "SORVD2_W"
frameinfo[2].frames[23] = "SORVD2_X"
frameinfo[3] = {}
frameinfo[3].rotatenum = 24
frameinfo[3].frames = {}
frameinfo[3].frames[0] = "SORVD3_A"
frameinfo[3].frames[1] = "SORVD3_B"
frameinfo[3].frames[2] = "SORVD3_C"
frameinfo[3].frames[3] = "SORVD3_D"
frameinfo[3].frames[4] = "SORVD3_E"
frameinfo[3].frames[5] = "SORVD3_F"
frameinfo[3].frames[6] = "SORVD3_G"
frameinfo[3].frames[7] = "SORVD1_H"
frameinfo[3].frames[8] = "SORVD1_I"
frameinfo[3].frames[9] = "SORVD1_J"
frameinfo[3].frames[10] = "SORVD1_K"
frameinfo[3].frames[11] = "SORVD1_L"
frameinfo[3].frames[12] = "SORVD1_M"
frameinfo[3].frames[13] = "SORVD1_N"
frameinfo[3].frames[14] = "SORVD1_O"
frameinfo[3].frames[15] = "SORVD1_P"
frameinfo[3].frames[16] = "SORVD1_Q"
frameinfo[3].frames[17] = "SORVD1_R"
frameinfo[3].frames[18] = "SORVD3_S"
frameinfo[3].frames[19] = "SORVD3_T"
frameinfo[3].frames[20] = "SORVD3_U"
frameinfo[3].frames[21] = "SORVD3_V"
frameinfo[3].frames[22] = "SORVD3_W"
frameinfo[3].frames[23] = "SORVD3_X"
frameinfo[4] = {}
frameinfo[4].rotatenum = 24
frameinfo[4].frames = {}
frameinfo[4].frames[0] = "SORVD4_A"
frameinfo[4].frames[1] = "SORVD4_B"
frameinfo[4].frames[2] = "SORVD4_C"
frameinfo[4].frames[3] = "SORVD4_D"
frameinfo[4].frames[4] = "SORVD4_E"
frameinfo[4].frames[5] = "SORVD4_F"
frameinfo[4].frames[6] = "SORVD4_G"
frameinfo[4].frames[7] = "SORVD1_H"
frameinfo[4].frames[8] = "SORVD1_I"
frameinfo[4].frames[9] = "SORVD1_J"
frameinfo[4].frames[10] = "SORVD1_K"
frameinfo[4].frames[11] = "SORVD1_L"
frameinfo[4].frames[12] = "SORVD1_M"
frameinfo[4].frames[13] = "SORVD1_N"
frameinfo[4].frames[14] = "SORVD1_O"
frameinfo[4].frames[15] = "SORVD1_P"
frameinfo[4].frames[16] = "SORVD1_Q"
frameinfo[4].frames[17] = "SORVD1_R"
frameinfo[4].frames[18] = "SORVD4_S"
frameinfo[4].frames[19] = "SORVD4_T"
frameinfo[4].frames[20] = "SORVD4_U"
frameinfo[4].frames[21] = "SORVD4_V"
frameinfo[4].frames[22] = "SORVD4_W"
frameinfo[4].frames[23] = "SORVD4_X"
frameinfo[5] = {}
frameinfo[5].rotatenum = 1
frameinfo[5].frames = {}
frameinfo[5].frames[0] = "SORVMOV1"
frameinfo[6] = {}
frameinfo[6].rotatenum = 1
frameinfo[6].frames = {}
frameinfo[6].frames[0] = "SORVMOV2"
frameinfo[7] = {}
frameinfo[7].rotatenum = 1
frameinfo[7].frames = {}
frameinfo[7].frames[0] = "SORVMOV3"
frameinfo[8] = {}
frameinfo[8].rotatenum = 1
frameinfo[8].frames = {}
frameinfo[8].frames[0] = "SORVIDL2"
frameinfo[9] = {}
frameinfo[9].rotatenum = 1
frameinfo[9].frames = {}
frameinfo[9].frames[0] = "SORVIDL3"
frameinfo[10] = {}
frameinfo[10].rotatenum = 24
frameinfo[10].frames = {}
frameinfo[10].frames[0] = "SORVS1_A"
frameinfo[10].frames[1] = "SORVS1_B"
frameinfo[10].frames[2] = "SORVS1_C"
frameinfo[10].frames[3] = "SORVS1_D"
frameinfo[10].frames[4] = "SORVS1_E"
frameinfo[10].frames[5] = "SORVS1_F"
frameinfo[10].frames[6] = "SORVS1_G"
frameinfo[10].frames[7] = "SORVS1_G"
frameinfo[10].frames[8] = "SORVS1_G"
frameinfo[10].frames[9] = "SORVS1_G"
frameinfo[10].frames[10] = "SORVS1_G"
frameinfo[10].frames[11] = "SORVS1_G"
frameinfo[10].frames[12] = "SORVS1_G"
frameinfo[10].frames[13] = "SORVS1_S"
frameinfo[10].frames[14] = "SORVS1_S"
frameinfo[10].frames[15] = "SORVS1_S"
frameinfo[10].frames[16] = "SORVS1_S"
frameinfo[10].frames[17] = "SORVS1_S"
frameinfo[10].frames[18] = "SORVS1_S"
frameinfo[10].frames[19] = "SORVS1_T"
frameinfo[10].frames[20] = "SORVS1_U"
frameinfo[10].frames[21] = "SORVS1_V"
frameinfo[10].frames[22] = "SORVS1_W"
frameinfo[10].frames[23] = "SORVS1_X"
frameinfo[11] = {}
frameinfo[11].rotatenum = 24
frameinfo[11].frames = {}
frameinfo[11].frames[0] = "SORVS2_A"
frameinfo[11].frames[1] = "SORVS2_B"
frameinfo[11].frames[2] = "SORVS2_C"
frameinfo[11].frames[3] = "SORVS2_D"
frameinfo[11].frames[4] = "SORVS2_E"
frameinfo[11].frames[5] = "SORVS2_F"
frameinfo[11].frames[6] = "SORVS2_G"
frameinfo[11].frames[7] = "SORVS2_G"
frameinfo[11].frames[8] = "SORVS2_G"
frameinfo[11].frames[9] = "SORVS2_G"
frameinfo[11].frames[10] = "SORVS2_G"
frameinfo[11].frames[11] = "SORVS2_G"
frameinfo[11].frames[12] = "SORVS2_G"
frameinfo[11].frames[13] = "SORVS2_S"
frameinfo[11].frames[14] = "SORVS2_S"
frameinfo[11].frames[15] = "SORVS2_S"
frameinfo[11].frames[16] = "SORVS2_S"
frameinfo[11].frames[17] = "SORVS2_S"
frameinfo[11].frames[18] = "SORVS2_S"
frameinfo[11].frames[19] = "SORVS2_T"
frameinfo[11].frames[20] = "SORVS2_U"
frameinfo[11].frames[21] = "SORVS2_V"
frameinfo[11].frames[22] = "SORVS2_W"
frameinfo[11].frames[23] = "SORVS2_X"
frameinfo[12] = {}
frameinfo[12].rotatenum = 24
frameinfo[12].frames = {}
frameinfo[12].frames[0] = "SORVS3_A"
frameinfo[12].frames[1] = "SORVS3_B"
frameinfo[12].frames[2] = "SORVS3_C"
frameinfo[12].frames[3] = "SORVS3_D"
frameinfo[12].frames[4] = "SORVS3_E"
frameinfo[12].frames[5] = "SORVS3_F"
frameinfo[12].frames[6] = "SORVS3_G"
frameinfo[12].frames[7] = "SORVS3_G"
frameinfo[12].frames[8] = "SORVS3_G"
frameinfo[12].frames[9] = "SORVS3_G"
frameinfo[12].frames[10] = "SORVS3_G"
frameinfo[12].frames[11] = "SORVS3_G"
frameinfo[12].frames[12] = "SORVS3_G"
frameinfo[12].frames[13] = "SORVS3_S"
frameinfo[12].frames[14] = "SORVS3_S"
frameinfo[12].frames[15] = "SORVS3_S"
frameinfo[12].frames[16] = "SORVS3_S"
frameinfo[12].frames[17] = "SORVS3_S"
frameinfo[12].frames[18] = "SORVS3_S"
frameinfo[12].frames[19] = "SORVS3_T"
frameinfo[12].frames[20] = "SORVS3_U"
frameinfo[12].frames[21] = "SORVS3_V"
frameinfo[12].frames[22] = "SORVS3_W"
frameinfo[12].frames[23] = "SORVS3_X"
frameinfo[13] = {}
frameinfo[13].rotatenum = 24
frameinfo[13].frames = {}
frameinfo[13].frames[0] = "SORVS4_A"
frameinfo[13].frames[1] = "SORVS4_B"
frameinfo[13].frames[2] = "SORVS4_C"
frameinfo[13].frames[3] = "SORVS4_D"
frameinfo[13].frames[4] = "SORVS4_E"
frameinfo[13].frames[5] = "SORVS4_F"
frameinfo[13].frames[6] = "SORVS4_G"
frameinfo[13].frames[7] = "SORVS4_G"
frameinfo[13].frames[8] = "SORVS4_G"
frameinfo[13].frames[9] = "SORVS4_G"
frameinfo[13].frames[10] = "SORVS4_G"
frameinfo[13].frames[11] = "SORVS4_G"
frameinfo[13].frames[12] = "SORVS4_G"
frameinfo[13].frames[13] = "SORVS4_S"
frameinfo[13].frames[14] = "SORVS4_S"
frameinfo[13].frames[15] = "SORVS4_S"
frameinfo[13].frames[16] = "SORVS4_S"
frameinfo[13].frames[17] = "SORVS4_S"
frameinfo[13].frames[18] = "SORVS4_S"
frameinfo[13].frames[19] = "SORVS4_T"
frameinfo[13].frames[20] = "SORVS4_U"
frameinfo[13].frames[21] = "SORVS4_V"
frameinfo[13].frames[22] = "SORVS4_W"
frameinfo[13].frames[23] = "SORVS4_X"
frameinfo[21] = {}
frameinfo[21].rotatenum = 24
frameinfo[21].frames = {}
frameinfo[21].frames[0] = "SORVR1_A"
frameinfo[21].frames[1] = "SORVR1_B"
frameinfo[21].frames[2] = "SORVR1_C"
frameinfo[21].frames[3] = "SORVR1_D"
frameinfo[21].frames[4] = "SORVR1_E"
frameinfo[21].frames[5] = "SORVR1_F"
frameinfo[21].frames[6] = "SORVR1_G"
frameinfo[21].frames[7] = "SORVR1_G"
frameinfo[21].frames[8] = "SORVR1_G"
frameinfo[21].frames[9] = "SORVR1_G"
frameinfo[21].frames[10] = "SORVR1_G"
frameinfo[21].frames[11] = "SORVR1_G"
frameinfo[21].frames[12] = "SORVR1_G"
frameinfo[21].frames[13] = "SORVR1_S"
frameinfo[21].frames[14] = "SORVR1_S"
frameinfo[21].frames[15] = "SORVR1_S"
frameinfo[21].frames[16] = "SORVR1_S"
frameinfo[21].frames[17] = "SORVR1_S"
frameinfo[21].frames[18] = "SORVR1_S"
frameinfo[21].frames[19] = "SORVR1_T"
frameinfo[21].frames[20] = "SORVR1_U"
frameinfo[21].frames[21] = "SORVR1_V"
frameinfo[21].frames[22] = "SORVR1_W"
frameinfo[21].frames[23] = "SORVR1_X"
frameinfo[22] = {}
frameinfo[22].rotatenum = 24
frameinfo[22].frames = {}
frameinfo[22].frames[0] = "SORVR2_A"
frameinfo[22].frames[1] = "SORVR2_B"
frameinfo[22].frames[2] = "SORVR2_C"
frameinfo[22].frames[3] = "SORVR2_D"
frameinfo[22].frames[4] = "SORVR2_E"
frameinfo[22].frames[5] = "SORVR2_F"
frameinfo[22].frames[6] = "SORVR2_G"
frameinfo[22].frames[7] = "SORVR2_G"
frameinfo[22].frames[8] = "SORVR2_G"
frameinfo[22].frames[9] = "SORVR2_G"
frameinfo[22].frames[10] = "SORVR2_G"
frameinfo[22].frames[11] = "SORVR2_G"
frameinfo[22].frames[12] = "SORVR2_G"
frameinfo[22].frames[13] = "SORVR2_S"
frameinfo[22].frames[14] = "SORVR2_S"
frameinfo[22].frames[15] = "SORVR2_S"
frameinfo[22].frames[16] = "SORVR2_S"
frameinfo[22].frames[17] = "SORVR2_S"
frameinfo[22].frames[18] = "SORVR2_S"
frameinfo[22].frames[19] = "SORVR2_T"
frameinfo[22].frames[20] = "SORVR2_U"
frameinfo[22].frames[21] = "SORVR2_V"
frameinfo[22].frames[22] = "SORVR2_W"
frameinfo[22].frames[23] = "SORVR2_X"
frameinfo[23] = {}
frameinfo[23].rotatenum = 24
frameinfo[23].frames = {}
frameinfo[23].frames[0] = "SORVR3_A"
frameinfo[23].frames[1] = "SORVR3_B"
frameinfo[23].frames[2] = "SORVR3_C"
frameinfo[23].frames[3] = "SORVR3_D"
frameinfo[23].frames[4] = "SORVR3_E"
frameinfo[23].frames[5] = "SORVR3_F"
frameinfo[23].frames[6] = "SORVR3_G"
frameinfo[23].frames[7] = "SORVR3_G"
frameinfo[23].frames[8] = "SORVR3_G"
frameinfo[23].frames[9] = "SORVR3_G"
frameinfo[23].frames[10] = "SORVR3_G"
frameinfo[23].frames[11] = "SORVR3_G"
frameinfo[23].frames[12] = "SORVR3_G"
frameinfo[23].frames[13] = "SORVR3_S"
frameinfo[23].frames[14] = "SORVR3_S"
frameinfo[23].frames[15] = "SORVR3_S"
frameinfo[23].frames[16] = "SORVR3_S"
frameinfo[23].frames[17] = "SORVR3_S"
frameinfo[23].frames[18] = "SORVR3_S"
frameinfo[23].frames[19] = "SORVR3_T"
frameinfo[23].frames[20] = "SORVR3_U"
frameinfo[23].frames[21] = "SORVR3_V"
frameinfo[23].frames[22] = "SORVR3_W"
frameinfo[23].frames[23] = "SORVR3_X"
frameinfo[24] = {}
frameinfo[24].rotatenum = 24
frameinfo[24].frames = {}
frameinfo[24].frames[0] = "SORVR4_A"
frameinfo[24].frames[1] = "SORVR4_B"
frameinfo[24].frames[2] = "SORVR4_C"
frameinfo[24].frames[3] = "SORVR4_D"
frameinfo[24].frames[4] = "SORVR4_E"
frameinfo[24].frames[5] = "SORVR4_F"
frameinfo[24].frames[6] = "SORVR4_G"
frameinfo[24].frames[7] = "SORVR4_G"
frameinfo[24].frames[8] = "SORVR4_G"
frameinfo[24].frames[9] = "SORVR4_G"
frameinfo[24].frames[10] = "SORVR4_G"
frameinfo[24].frames[11] = "SORVR4_G"
frameinfo[24].frames[12] = "SORVR4_G"
frameinfo[24].frames[13] = "SORVR4_S"
frameinfo[24].frames[14] = "SORVR4_S"
frameinfo[24].frames[15] = "SORVR4_S"
frameinfo[24].frames[16] = "SORVR4_S"
frameinfo[24].frames[17] = "SORVR4_S"
frameinfo[24].frames[18] = "SORVR4_S"
frameinfo[24].frames[19] = "SORVR4_T"
frameinfo[24].frames[20] = "SORVR4_U"
frameinfo[24].frames[21] = "SORVR4_V"
frameinfo[24].frames[22] = "SORVR4_W"
frameinfo[24].frames[23] = "SORVR4_X"
frameinfo[14] = {}
frameinfo[14].rotatenum = 24
frameinfo[14].frames = {}
frameinfo[14].frames[0] = "SORVM1_A"
frameinfo[14].frames[1] = "SORVM1_B"
frameinfo[14].frames[2] = "SORVM1_C"
frameinfo[14].frames[3] = "SORVM1_D"
frameinfo[14].frames[4] = "SORVM1_E"
frameinfo[14].frames[5] = "SORVM1_F"
frameinfo[14].frames[6] = "SORVM1_G"
frameinfo[14].frames[7] = "SORVM1_G"
frameinfo[14].frames[8] = "SORVM1_G"
frameinfo[14].frames[9] = "SORVM1_G"
frameinfo[14].frames[10] = "SORVM1_G"
frameinfo[14].frames[11] = "SORVM1_G"
frameinfo[14].frames[12] = "SORVM1_G"
frameinfo[14].frames[13] = "SORVM1_S"
frameinfo[14].frames[14] = "SORVM1_S"
frameinfo[14].frames[15] = "SORVM1_S"
frameinfo[14].frames[16] = "SORVM1_S"
frameinfo[14].frames[17] = "SORVM1_S"
frameinfo[14].frames[18] = "SORVM1_S"
frameinfo[14].frames[19] = "SORVM1_T"
frameinfo[14].frames[20] = "SORVM1_U"
frameinfo[14].frames[21] = "SORVM1_V"
frameinfo[14].frames[22] = "SORVM1_W"
frameinfo[14].frames[23] = "SORVM1_X"
frameinfo[15] = {}
frameinfo[15].rotatenum = 24
frameinfo[15].frames = {}
frameinfo[15].frames[0] = "SORVM2_A"
frameinfo[15].frames[1] = "SORVM2_B"
frameinfo[15].frames[2] = "SORVM2_C"
frameinfo[15].frames[3] = "SORVM2_D"
frameinfo[15].frames[4] = "SORVM2_E"
frameinfo[15].frames[5] = "SORVM2_F"
frameinfo[15].frames[6] = "SORVM2_G"
frameinfo[15].frames[7] = "SORVM2_G"
frameinfo[15].frames[8] = "SORVM2_G"
frameinfo[15].frames[9] = "SORVM2_G"
frameinfo[15].frames[10] = "SORVM2_G"
frameinfo[15].frames[11] = "SORVM2_G"
frameinfo[15].frames[12] = "SORVM2_G"
frameinfo[15].frames[13] = "SORVM2_S"
frameinfo[15].frames[14] = "SORVM2_S"
frameinfo[15].frames[15] = "SORVM2_S"
frameinfo[15].frames[16] = "SORVM2_S"
frameinfo[15].frames[17] = "SORVM2_S"
frameinfo[15].frames[18] = "SORVM2_S"
frameinfo[15].frames[19] = "SORVM2_T"
frameinfo[15].frames[20] = "SORVM2_U"
frameinfo[15].frames[21] = "SORVM2_V"
frameinfo[15].frames[22] = "SORVM2_W"
frameinfo[15].frames[23] = "SORVM2_X"
frameinfo[16] = {}
frameinfo[16].rotatenum = 24
frameinfo[16].frames = {}
frameinfo[16].frames[0] = "SORVM3_A"
frameinfo[16].frames[1] = "SORVM3_B"
frameinfo[16].frames[2] = "SORVM3_C"
frameinfo[16].frames[3] = "SORVM3_D"
frameinfo[16].frames[4] = "SORVM3_E"
frameinfo[16].frames[5] = "SORVM3_F"
frameinfo[16].frames[6] = "SORVM3_G"
frameinfo[16].frames[7] = "SORVM3_G"
frameinfo[16].frames[8] = "SORVM3_G"
frameinfo[16].frames[9] = "SORVM3_G"
frameinfo[16].frames[10] = "SORVM3_G"
frameinfo[16].frames[11] = "SORVM3_G"
frameinfo[16].frames[12] = "SORVM3_G"
frameinfo[16].frames[13] = "SORVM3_S"
frameinfo[16].frames[14] = "SORVM3_S"
frameinfo[16].frames[15] = "SORVM3_S"
frameinfo[16].frames[16] = "SORVM3_S"
frameinfo[16].frames[17] = "SORVM3_S"
frameinfo[16].frames[18] = "SORVM3_S"
frameinfo[16].frames[19] = "SORVM3_T"
frameinfo[16].frames[20] = "SORVM3_U"
frameinfo[16].frames[21] = "SORVM3_V"
frameinfo[16].frames[22] = "SORVM3_W"
frameinfo[16].frames[23] = "SORVM3_X"
frameinfo[17] = {}
frameinfo[17].rotatenum = 24
frameinfo[17].frames = {}
frameinfo[17].frames[0] = "SORVM4_A"
frameinfo[17].frames[1] = "SORVM4_B"
frameinfo[17].frames[2] = "SORVM4_C"
frameinfo[17].frames[3] = "SORVM4_D"
frameinfo[17].frames[4] = "SORVM4_E"
frameinfo[17].frames[5] = "SORVM4_F"
frameinfo[17].frames[6] = "SORVM4_G"
frameinfo[17].frames[7] = "SORVM4_G"
frameinfo[17].frames[8] = "SORVM4_G"
frameinfo[17].frames[9] = "SORVM4_G"
frameinfo[17].frames[10] = "SORVM4_G"
frameinfo[17].frames[11] = "SORVM4_G"
frameinfo[17].frames[12] = "SORVM4_G"
frameinfo[17].frames[13] = "SORVM4_S"
frameinfo[17].frames[14] = "SORVM4_S"
frameinfo[17].frames[15] = "SORVM4_S"
frameinfo[17].frames[16] = "SORVM4_S"
frameinfo[17].frames[17] = "SORVM4_S"
frameinfo[17].frames[18] = "SORVM4_S"
frameinfo[17].frames[19] = "SORVM4_T"
frameinfo[17].frames[20] = "SORVM4_U"
frameinfo[17].frames[21] = "SORVM4_V"
frameinfo[17].frames[22] = "SORVM4_W"
frameinfo[17].frames[23] = "SORVM4_X"
frameinfo[18] = {}
frameinfo[18].rotatenum = 24
frameinfo[18].frames = {}
frameinfo[18].frames[0] = "SORVHD_A"
frameinfo[18].frames[1] = "SORVHD_B"
frameinfo[18].frames[2] = "SORVHD_C"
frameinfo[18].frames[3] = "SORVHD_D"
frameinfo[18].frames[4] = "SORVHD_E"
frameinfo[18].frames[5] = "SORVHD_F"
frameinfo[18].frames[6] = "SORVHD_G"
frameinfo[18].frames[7] = "SORVHD_G"
frameinfo[18].frames[8] = "SORVHD_G"
frameinfo[18].frames[9] = "SORVHD_G"
frameinfo[18].frames[10] = "SORVHD_G"
frameinfo[18].frames[11] = "SORVHD_G"
frameinfo[18].frames[12] = "SORVHD_G"
frameinfo[18].frames[13] = "SORVHD_S"
frameinfo[18].frames[14] = "SORVHD_S"
frameinfo[18].frames[15] = "SORVHD_S"
frameinfo[18].frames[16] = "SORVHD_S"
frameinfo[18].frames[17] = "SORVHD_S"
frameinfo[18].frames[18] = "SORVHD_S"
frameinfo[18].frames[19] = "SORVHD_T"
frameinfo[18].frames[20] = "SORVHD_U"
frameinfo[18].frames[21] = "SORVHD_V"
frameinfo[18].frames[22] = "SORVHD_W"
frameinfo[18].frames[23] = "SORVHD_X"
frameinfo[19] = {}
frameinfo[19].rotatenum = 1
frameinfo[19].frames = {}
frameinfo[19].frames[0] = "SORVHD_A"
frameinfo[20] = {}
frameinfo[20].rotatenum = 1
frameinfo[20].frames = {}
frameinfo[20].frames[0] = "SORVFLSH"
frameinfo[25] = {}
frameinfo[25].rotatenum = 24
frameinfo[25].frames = {}
frameinfo[25].frames[0] = "SORVT1_A"
frameinfo[25].frames[1] = "SORVT1_B"
frameinfo[25].frames[2] = "SORVT1_C"
frameinfo[25].frames[3] = "SORVT1_D"
frameinfo[25].frames[4] = "SORVT1_E"
frameinfo[25].frames[5] = "SORVT1_F"
frameinfo[25].frames[6] = "SORVT1_G"
frameinfo[25].frames[7] = "SORVT1_G"
frameinfo[25].frames[8] = "SORVT1_G"
frameinfo[25].frames[9] = "SORVT1_G"
frameinfo[25].frames[10] = "SORVT1_G"
frameinfo[25].frames[11] = "SORVT1_G"
frameinfo[25].frames[12] = "SORVT1_G"
frameinfo[25].frames[13] = "SORVT1_S"
frameinfo[25].frames[14] = "SORVT1_S"
frameinfo[25].frames[15] = "SORVT1_S"
frameinfo[25].frames[16] = "SORVT1_S"
frameinfo[25].frames[17] = "SORVT1_S"
frameinfo[25].frames[18] = "SORVT1_S"
frameinfo[25].frames[19] = "SORVT1_T"
frameinfo[25].frames[20] = "SORVT1_U"
frameinfo[25].frames[21] = "SORVT1_V"
frameinfo[25].frames[22] = "SORVT1_W"
frameinfo[25].frames[23] = "SORVT1_X"
frameinfo[26] = {}
frameinfo[26].rotatenum = 24
frameinfo[26].frames = {}
frameinfo[26].frames[0] = "SORVT2_A"
frameinfo[26].frames[1] = "SORVT2_B"
frameinfo[26].frames[2] = "SORVT2_C"
frameinfo[26].frames[3] = "SORVT2_D"
frameinfo[26].frames[4] = "SORVT2_E"
frameinfo[26].frames[5] = "SORVT2_F"
frameinfo[26].frames[6] = "SORVT2_G"
frameinfo[26].frames[7] = "SORVT2_G"
frameinfo[26].frames[8] = "SORVT2_G"
frameinfo[26].frames[9] = "SORVT2_G"
frameinfo[26].frames[10] = "SORVT2_G"
frameinfo[26].frames[11] = "SORVT2_G"
frameinfo[26].frames[12] = "SORVT2_G"
frameinfo[26].frames[13] = "SORVT2_S"
frameinfo[26].frames[14] = "SORVT2_S"
frameinfo[26].frames[15] = "SORVT2_S"
frameinfo[26].frames[16] = "SORVT2_S"
frameinfo[26].frames[17] = "SORVT2_S"
frameinfo[26].frames[18] = "SORVT2_S"
frameinfo[26].frames[19] = "SORVT2_T"
frameinfo[26].frames[20] = "SORVT2_U"
frameinfo[26].frames[21] = "SORVT2_V"
frameinfo[26].frames[22] = "SORVT2_W"
frameinfo[26].frames[23] = "SORVT2_X"
frameinfo[27] = {}
frameinfo[27].rotatenum = 24
frameinfo[27].frames = {}
frameinfo[27].frames[0] = "SORVT3_A"
frameinfo[27].frames[1] = "SORVT3_B"
frameinfo[27].frames[2] = "SORVT3_C"
frameinfo[27].frames[3] = "SORVT3_D"
frameinfo[27].frames[4] = "SORVT3_E"
frameinfo[27].frames[5] = "SORVT3_F"
frameinfo[27].frames[6] = "SORVT3_G"
frameinfo[27].frames[7] = "SORVT3_G"
frameinfo[27].frames[8] = "SORVT3_G"
frameinfo[27].frames[9] = "SORVT3_G"
frameinfo[27].frames[10] = "SORVT3_G"
frameinfo[27].frames[11] = "SORVT3_G"
frameinfo[27].frames[12] = "SORVT3_G"
frameinfo[27].frames[13] = "SORVT3_S"
frameinfo[27].frames[14] = "SORVT3_S"
frameinfo[27].frames[15] = "SORVT3_S"
frameinfo[27].frames[16] = "SORVT3_S"
frameinfo[27].frames[17] = "SORVT3_S"
frameinfo[27].frames[18] = "SORVT3_S"
frameinfo[27].frames[19] = "SORVT3_T"
frameinfo[27].frames[20] = "SORVT3_U"
frameinfo[27].frames[21] = "SORVT3_V"
frameinfo[27].frames[22] = "SORVT3_W"
frameinfo[27].frames[23] = "SORVT3_X"


local idle1 = AOS_AddPFrame(frameinfo[0])
local idle2 = AOS_AddPFrame(frameinfo[8])
local idle3 = AOS_AddPFrame(frameinfo[9])
local dash1 = AOS_AddPFrame(frameinfo[1])
local dash2 = AOS_AddPFrame(frameinfo[2])
local dash3 = AOS_AddPFrame(frameinfo[3])
local dash4 = AOS_AddPFrame(frameinfo[4])
local move1 = AOS_AddPFrame(frameinfo[5])
local move2 = AOS_AddPFrame(frameinfo[6])
local move3 = AOS_AddPFrame(frameinfo[7])
local shoot1 = AOS_AddPFrame(frameinfo[10])
local shoot2 = AOS_AddPFrame(frameinfo[11])
local shoot3 = AOS_AddPFrame(frameinfo[12])
local shoot4 = AOS_AddPFrame(frameinfo[13])
local rocket1 = AOS_AddPFrame(frameinfo[21])
local rocket2 = AOS_AddPFrame(frameinfo[22])
local rocket3 = AOS_AddPFrame(frameinfo[23])
local rocket4 = AOS_AddPFrame(frameinfo[24])
local sword1 = AOS_AddPFrame(frameinfo[14])
local sword2 = AOS_AddPFrame(frameinfo[15])
local sword3 = AOS_AddPFrame(frameinfo[16])
local sword4 = AOS_AddPFrame(frameinfo[17])
local hurt = AOS_AddPFrame(frameinfo[18])
local hurtdie = AOS_AddPFrame(frameinfo[19])
local flashdie = AOS_AddPFrame(frameinfo[20])
local shield1 = AOS_AddPFrame(frameinfo[25])
local shield2 = AOS_AddPFrame(frameinfo[26])
local shield3 = AOS_AddPFrame(frameinfo[27])

local player = {}
player.name = "Sorilver"
player.characterselectportrait = "SORVCHR"
player.characterselectcircle = "SORVCSSB"
player.scale = FRACUNIT
player.ponecolor = SKINCOLOR_BONE	// RIP Silver
player.ptwocolor = SKINCOLOR_BLUE
// Attacks
player.attacks = {}
// Attacks:
// 0:	Main
// 1:	Sub
// 2:	Special 1
// 3:	Special 2
// 4:	Hyper Main
// 5:	Hyper Sub
// 6:	Hyper Special
// 7:	Accel Hyper
// For things like charged attacks and dash attacks, check if the player is holding specific buttons
// BT_JUMP for main
// BT_USE for sub
// BT_CUSTOM2 for special
// BT_ATTACK for dash
// BT_CUSTOM1 for hyper
// Even if the player has remapped their controls, the buttons passed for the function will be remapped to these
// You can add more attacks by making attacks in indexes 8+, and manually change the attack and call its function.
local beam1 = 0
local beam2 = 0
local beam3 = 0
player.attacks[0] = function(player, aosp, cmd, buttons, aospn)
	local dashshot = false
	if(aosp.dashing == 1)
		aosp.dashing = 0
		aosp.addmomx = FixedMul(cos(aosp.dashdirection), (15*FRACUNIT/2))
		aosp.addmomy = FixedMul(sin(aosp.dashdirection), (15*FRACUNIT/2))
		dashshot = true
		aosp.attackvar = 49138
	end
//	aosp.addmomx = 0
//	aosp.addmomy = 0
	if not(aosp.attacktimer)
		and not(aosp.attackvar)
		setPAnim(aosp, 6)
		aosp.attacktimer = 0
	end
	// Normal/Charge shot
	if(aosp.attacktimer > TICRATE/8)
		and(aosp.attacktimer > 15 or not(aosp.attackvar == 49138))
		aosp.candashcancel = true
	else
		aosp.candashcancel = false
	end
	aosp.canmove = true
	if not(buttons & BT_JUMP)
		or(aosp.attacktimer)
		or(dashshot)
		if not(aosp.attacktimer)
			setPAnim(aosp, 7)
			AOSPlaySound(player, sfx_sgbem2)
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			if not(aosp.attackvar-1 >= TICRATE/3)
				and not(dashshot)
				beam.type = beam1
				beam.momx = 9*cos(aosp.shootdirection)
				beam.momy = 9*sin(aosp.shootdirection)
			else
				beam.type = beam2
				beam.momx = FixedMul(cos(aosp.shootdirection), (4*FRACUNIT)+(FRACUNIT/2))
				beam.momy = FixedMul(sin(aosp.shootdirection), (4*FRACUNIT)+(FRACUNIT/2))
			end
			beam.x = aosp.x+(4*cos(aosp.shootdirection))
			beam.y = aosp.y+(4*sin(aosp.shootdirection))
			beam.angle = aosp.shootdirection
			beam.parent = aospn
		end
		aosp.attacktimer = $1 + 1
	elseif not(aosp.attacktimer)
		if(aosp.attackvar < TICRATE/3)
			aosp.attackvar = $1 + 1
			if(aosp.attackvar < TICRATE/6)
				aosp.canmove = false
			end
		elseif(aosp.attackvar == TICRATE/3)
			aosp.attackvar = $1 + 1
			AOSPlaySound(player, sfx_sgchrg)
		end
	end
	if(aosp.attacktimer > 20)
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
local missile1 = 0
local missile2 = 0
player.attacks[1] = function(player, aosp, cmd, buttons, aospn)
	if(aosp.dashing == 1)
		aosp.dashing = 0
		aosp.addmomx = FixedMul(cos(aosp.dashdirection), (15*FRACUNIT/2))
		aosp.addmomy = FixedMul(sin(aosp.dashdirection), (15*FRACUNIT/2))
	end
	if not(aosp.attacktimer)
		and not(aosp.attackvar)
		setPAnim(aosp, 9)
	end

	if(aosp.attacktimer > TICRATE/4)
		aosp.candashcancel = true
	else
		aosp.candashcancel = false
	end
	
	aosp.canmove = false
	if(aosp.attacktimer == TICRATE/5)
		setPAnim(aosp, 10)
		AOSPlaySound(player, sfx_sgrock)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = missile1
		beam.momx = 9*cos(aosp.shootdirection)
		beam.momy = 9*sin(aosp.shootdirection)
		beam.x = aosp.x+(4*cos(aosp.shootdirection))
		beam.y = aosp.y+(4*sin(aosp.shootdirection))
		beam.angle = aosp.shootdirection
		beam.parent = aospn
	end
	aosp.attacktimer = $1 + 1
	if(aosp.attacktimer > TICRATE)
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
local meleeobj = 0
player.attacks[2] = function(player, aosp, cmd, buttons, aospn)
	if(aosp.dashing == 1)
		aosp.currentattack = 4	// Delays by a frame but ehhh
		return
	end
	aosp.dashing = 0
	aosp.addmomx = 0
	aosp.addmomy = 0
	if not(aosp.attacktimer)
		setPAnim(aosp, 8)
		aosp.frame = 0
		aosp.animtime = 0
		AOSPlaySound(player, sfx_sgsrd1)
		aosp.canmove = false
		aosp.candashcancel = false
		if(aosp.target >= 0)
			if(R_PointToDist2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y) > 15*FRACUNIT)
				aosp.lockspeed = true
				aosp.movementspeed = 6*FRACUNIT
				aosp.dashdirection = aosp.shootdirection
			end
		end
	elseif(aosp.attacktimer == 5)
		local hitbox = player.aosobjects[createAOSObject(player)]
		hitbox.type = meleeobj
		hitbox.x = aosp.x+(12*cos(aosp.shootdirection))
		hitbox.y = aosp.y+(12*sin(aosp.shootdirection))
		hitbox.angle = aosp.shootdirection
		hitbox.parent = aospn
	end
	if(aosp.attacktimer >= TICRATE/3)
		and((aosp.attacktimer >= TICRATE*2/3) or not(aosp.attackvar))
		aosp.candashcancel = true
	end
	if(aosp.attacktimer == TICRATE/2)
		or(aosp.target < 0)
		or not(R_PointToDist2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y) > 15*FRACUNIT)
		aosp.lockspeed = false
	end
	if(aosp.attackvar)
		aosp.candashcancel = true
	end
	aosp.attacktimer = $1 + 1
	if(aosp.attacktimer > TICRATE/8)
		and(((buttons & BT_CUSTOM2) and not(aosp.prevbutt & BT_CUSTOM2)) or aosp.attackvar == 2)
		and(aosp.attackvar == 1 or aosp.attackvar == 2)
		aosp.attacktimer = 0
		aosp.attackvar = 3
	elseif(aosp.attacktimer > TICRATE/8)
		and(((buttons & BT_USE) and not(aosp.prevbutt & BT_USE)) or aosp.attackvar == 5)
		and(aosp.attackvar == 1 or aosp.attackvar == 5)
		aosp.currentattack = 4
		aosp.attacktimer = 0
		aosp.attackvar = 0
	elseif(aosp.attacktimer > TICRATE/8)
		and(((buttons & BT_CUSTOM2) and not(aosp.prevbutt & BT_CUSTOM2)) or aosp.attackvar == 4)
		and(aosp.attackvar == 3 or aosp.attackvar == 4)
		aosp.attacktimer = 0
		aosp.attackvar = 1
		aosp.currentattack = 4
	elseif(buttons & BT_CUSTOM2)
		and not(aosp.prevbutt & BT_CUSTOM2)
		and(aosp.attackvar == 1 or aosp.attackvar == 3)
		if(aosp.attackvar == 1)
			aosp.attackvar = 2	// Buffering!
		else
			aosp.attackvar = 4	// Buffering!
		end
	elseif(buttons & BT_USE)
		and not(aosp.prevbutt & BT_USE)
		and(aosp.attackvar == 1)
		aosp.attackvar = 5	// Buffering!
	end
	if(aosp.attacktimer > TICRATE)
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
local meleeobj2
player.attacks[3] = function(player, aosp, cmd, buttons, aospn)
/*	if(aosp.dashing == 1)
		aosp.attacktimer = TICRATE/8
		aosp.canmove = false
		aosp.candashcancel = false
	end*/
	aosp.dashing = 0
	aosp.addmomx = 0
	aosp.addmomy = 0
	if not(aosp.attacktimer)
		setPAnim(aosp, 8)
		aosp.frame = 0
		aosp.animtime = 0
		aosp.canmove = false
		aosp.candashcancel = false
	end
	if(aosp.attacktimer == TICRATE/16)
		AOSPlaySound(player, sfx_sgsrd2)
		
		setPAnim(aosp, 8)
		aosp.frame = 0
		aosp.animtime = 0
		aosp.lockspeed = true
		aosp.movementspeed = 7*FRACUNIT
		aosp.dashdirection = aosp.shootdirection
		
		local hitbox = player.aosobjects[createAOSObject(player)]
		hitbox.type = meleeobj2
		hitbox.x = aosp.x+(14*cos(aosp.shootdirection))
		hitbox.y = aosp.y+(14*sin(aosp.shootdirection))
		hitbox.angle = aosp.shootdirection
		hitbox.parent = aospn
	end
	if(aosp.attacktimer+((TICRATE/8)-(TICRATE/16)) > TICRATE*2/3)
		aosp.candashcancel = true
	end
	if(aosp.attacktimer == TICRATE)
		aosp.lockspeed = false
	end
	if(aosp.attackvar == 2)
		aosp.candashcancel = true
	end
/*	if(aosp.attackvar == 2)
		and(buttons & BT_JUMP)
		and not(aosp.prevbutt & BT_JUMP)
		aosp.attackvar = 3
		setPAnim(aosp, 7)
		aosp.movementspeed = 4*FRACUNIT
		AOSPlaySound(player, sfx_sgbem2)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = beam2
		beam.momx = FixedMul(cos(aosp.shootdirection), (4*FRACUNIT)+(FRACUNIT/2))
		beam.momy = FixedMul(sin(aosp.shootdirection), (4*FRACUNIT)+(FRACUNIT/2))
		beam.x = aosp.x+(4*cos(aosp.shootdirection))
		beam.y = aosp.y+(4*sin(aosp.shootdirection))
		beam.angle = aosp.shootdirection
		beam.parent = aospn
	end*/
	aosp.attacktimer = $1 + 1
	if(aosp.attacktimer > TICRATE)
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
local hyperbeam
player.attacks[4] = function(player, aosp, cmd, buttons, aospn)
	aosp.dashing = 0
	if not(aosp.attacktimer)
		setPAnim(aosp, 6)
		aosp.shieldtime = -TICRATE*3
		AOSPlaySound(player, sfx_sghypr)
	elseif(aosp.attacktimer == 1)
		aosp.canaim = false
	end
	
	aosp.canmove = false
	if(aosp.attacktimer == TICRATE/5)
		setPAnim(aosp, 7)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = hyperbeam
		beam.x = aosp.x+(4*cos(aosp.shootdirection))
		beam.y = aosp.y+(4*sin(aosp.shootdirection))
		beam.angle = aosp.shootdirection
		beam.parent = aospn
	end
	aosp.attacktimer = $1 + 1
	if(aosp.attacktimer > TICRATE)
		aosp.currentattack = 0
		aosp.canmove = true
		aosp.canaim = true
	end
end

local angles = {}
angles[0] = 250*FRACUNIT
angles[1] = 110*FRACUNIT
angles[2] = 300*FRACUNIT
angles[3] = 60*FRACUNIT

player.attacks[5] = function(player, aosp, cmd, buttons, aospn)
	if(aosp.dashing == 1)
		aosp.dashing = 0
	end
	if not(aosp.attacktimer)
		setPAnim(aosp, 11)
		aosp.shieldtime = -TICRATE*3
		AOSPlaySound(player, sfx_sghypr)
	elseif(aosp.attacktimer == 1)
		aosp.canaim = false
	end
	aosp.attacktimer = $1 + 1
	aosp.canmove = false
	aosp.candashcancel = false
	if(aosp.attacktimer > TICRATE/3)
		if(aosp.attacktimer & 1)
			and(aosp.attacktimer-(TICRATE/3) < 25)
			AOSPlaySound(player, sfx_sgshot)
			// Shoot the thing!
			local rocket = player.aosobjects[createAOSObject(player)]
			rocket.type = missile2
			local angledif = FixedAngle(70*FRACUNIT)
			local angleadd = FixedAngle(P_RandomByte()*70*FRACUNIT/256)
			local angle = aosp.shootdirection-(angledif/2)+angleadd
			local angle2 = aosp.shootdirection+(angledif/2)-angleadd
			rocket.x = aosp.x-(33*cos(angle))
			rocket.y = aosp.y-(33*sin(angle))
			rocket.angle = angle2
			rocket.parent = aospn
			rocket.target = aosp.target
		end
		if not(aosp.attacktimer-(TICRATE/3) < 25)
			aosp.candashcancel = true
		end
	end
	if(aosp.attacktimer > TICRATE)
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
// Animations
player.animations = {}
// Animations:
// 0:	Idle
// 1:	Moving
// 2:	Dashing
// 3:	Hurt
// 4:	Die
// 5:	Shield
// Anything else is character specific
// Note that 0-5 have hard-coded next animations
// When a custom animation ends, the next animation should be 0-5

// Idle
player.animations[0] = {}
player.animations[0].speed = 2	// Time between frames
player.animations[0].numframes = 4
player.animations[0].nextanim = 0	// Animation to play when this animation ends. Same animation = loop.
player.animations[0].frames = {}
player.animations[0].frames[0] = idle1
player.animations[0].frames[1] = idle2
player.animations[0].frames[2] = idle3
player.animations[0].frames[3] = idle2
// Moving
player.animations[1] = {}
player.animations[1].speed = 2
player.animations[1].numframes = 4
player.animations[1].nextanim = 1
player.animations[1].frames = {}
player.animations[1].frames[0] = move1
player.animations[1].frames[1] = move2
player.animations[1].frames[2] = move3
player.animations[1].frames[3] = move2
// Dashing
player.animations[2] = {}
player.animations[2].speed = 1
player.animations[2].numframes = 4
player.animations[2].nextanim = 1
player.animations[2].frames = {}
player.animations[2].frames[0] = dash1
player.animations[2].frames[1] = dash2
player.animations[2].frames[2] = dash3
player.animations[2].frames[3] = dash4
// Hurt
player.animations[3] = {}
player.animations[3].speed = 1
player.animations[3].numframes = 1
player.animations[3].nextanim = 0
player.animations[3].frames = {}
player.animations[3].frames[0] = hurt
// Die
player.animations[4] = {}
player.animations[4].speed = 0
player.animations[4].numframes = 2
player.animations[4].nextanim = 4
player.animations[4].frames = {}
player.animations[4].frames[0] = hurtdie
player.animations[4].frames[1] = flashdie
// Shield
player.animations[5] = {}
player.animations[5].speed = 1
player.animations[5].numframes = 3
player.animations[5].nextanim = 0
player.animations[5].frames = {}
player.animations[5].frames[0] = shield1
player.animations[5].frames[1] = shield2
player.animations[5].frames[2] = shield3
// Shoot (charge)
player.animations[6] = {}
player.animations[6].speed = 1
player.animations[6].numframes = 1
player.animations[6].nextanim = 6
player.animations[6].frames = {}
player.animations[6].frames[0] = shoot1
// Shoot (release)
player.animations[7] = {}
player.animations[7].speed = 2
player.animations[7].numframes = 6
player.animations[7].nextanim = 0
player.animations[7].frames = {}
player.animations[7].speed = 2
player.animations[7].numframes = 6
player.animations[7].nextanim = 0
player.animations[7].frames = {}
player.animations[7].frames[0] = shoot2
player.animations[7].frames[1] = shoot3
player.animations[7].frames[2] = shoot4
player.animations[7].frames[3] = shoot4
player.animations[7].frames[4] = shoot4
player.animations[7].frames[5] = shoot4
player.animations[7].frames[6] = shoot4
player.animations[7].frames[7] = shoot4
player.animations[7].frames[8] = shoot4
player.animations[7].frames[9] = shoot4
// Sword (1)
player.animations[8] = {}
player.animations[8].speed = 0
player.animations[8].numframes = 35
player.animations[8].nextanim = 0
player.animations[8].frames = {}
player.animations[8].frames[0] = sword1
player.animations[8].frames[1] = sword1
player.animations[8].frames[2] = sword1
player.animations[8].frames[3] = sword2
player.animations[8].frames[4] = sword3
player.animations[8].frames[5] = sword3
player.animations[8].frames[6] = sword4
player.animations[8].frames[7] = sword4
player.animations[8].frames[8] = sword4
player.animations[8].frames[9] = sword4
player.animations[8].frames[10] = sword4
player.animations[8].frames[11] = sword4
player.animations[8].frames[12] = sword4
player.animations[8].frames[13] = sword4
player.animations[8].frames[14] = sword4
player.animations[8].frames[15] = sword4
player.animations[8].frames[16] = sword4
player.animations[8].frames[17] = sword4
player.animations[8].frames[18] = sword4
player.animations[8].frames[19] = sword4
player.animations[8].frames[20] = sword4
player.animations[8].frames[21] = sword4
player.animations[8].frames[22] = sword4
player.animations[8].frames[23] = sword4
player.animations[8].frames[24] = sword4
player.animations[8].frames[25] = sword4
player.animations[8].frames[26] = sword4
player.animations[8].frames[27] = sword4
player.animations[8].frames[28] = sword4
player.animations[8].frames[29] = sword4
player.animations[8].frames[30] = sword4
player.animations[8].frames[31] = sword4
player.animations[8].frames[32] = sword4
player.animations[8].frames[33] = sword4
player.animations[8].frames[34] = sword4
// Rocket (charge)
player.animations[9] = {}
player.animations[9].speed = 1
player.animations[9].numframes = 1
player.animations[9].nextanim = 9
player.animations[9].frames = {}
player.animations[9].frames[0] = rocket1
// Rocket (release)
player.animations[10] = {}
player.animations[10].speed = 2
player.animations[10].numframes = 10
player.animations[10].nextanim = 0
player.animations[10].frames = {}
player.animations[10].speed = 2
player.animations[10].numframes = 6
player.animations[10].nextanim = 0
player.animations[10].frames = {}
player.animations[10].frames[0] = rocket2
player.animations[10].frames[1] = rocket3
player.animations[10].frames[2] = rocket4
player.animations[10].frames[3] = rocket4
player.animations[10].frames[4] = rocket4
player.animations[10].frames[5] = rocket4
player.animations[10].frames[6] = rocket4
player.animations[10].frames[7] = rocket4
player.animations[10].frames[8] = rocket4
player.animations[10].frames[9] = rocket4
// Rockets
player.animations[11] = {}
player.animations[11].speed = 1
player.animations[11].numframes = 18
player.animations[11].nextanim = 0
player.animations[11].frames = {}
player.animations[11].frames[0] = shield1
player.animations[11].frames[1] = shield1
player.animations[11].frames[2] = shield1
player.animations[11].frames[3] = shield2
player.animations[11].frames[4] = shield3
player.animations[11].frames[5] = shield3
player.animations[11].frames[6] = shield3
player.animations[11].frames[7] = shield3
player.animations[11].frames[8] = shield3
player.animations[11].frames[9] = shield3
player.animations[11].frames[10] = shield3
player.animations[11].frames[11] = shield3
player.animations[11].frames[12] = shield3
player.animations[11].frames[13] = shield3
player.animations[11].frames[14] = shield3
player.animations[11].frames[15] = shield3
player.animations[11].frames[16] = shield3
player.animations[11].frames[17] = shield3

AOS_AddPlayer(player)

local frames = {}
frames[0] = {}
frames[0].rotatenum = 24
frames[0].frames = {}
frames[0].frames[0] = "BEAMG_A"
frames[0].frames[1] = "BEAMG_B"
frames[0].frames[2] = "BEAMG_C"
frames[0].frames[3] = "BEAMG_D"
frames[0].frames[4] = "BEAMG_E"
frames[0].frames[5] = "BEAMG_F"
frames[0].frames[6] = "BEAMG_G"
frames[0].frames[7] = "BEAMG_G"
frames[0].frames[8] = "BEAMG_G"
frames[0].frames[9] = "BEAMG_G"
frames[0].frames[10] = "BEAMG_G"
frames[0].frames[11] = "BEAMG_G"
frames[0].frames[12] = "BEAMG_G"
frames[0].frames[13] = "BEAMG_S"
frames[0].frames[14] = "BEAMG_S"
frames[0].frames[15] = "BEAMG_S"
frames[0].frames[16] = "BEAMG_S"
frames[0].frames[17] = "BEAMG_S"
frames[0].frames[18] = "BEAMG_S"
frames[0].frames[19] = "BEAMG_T"
frames[0].frames[20] = "BEAMG_U"
frames[0].frames[21] = "BEAMG_V"
frames[0].frames[22] = "BEAMG_W"
frames[0].frames[23] = "BEAMG_X"
frames[2] = {}
frames[2].rotatenum = 24
frames[2].frames = {}
frames[2].frames[0] = "BEAMY_A"
frames[2].frames[1] = "BEAMY_B"
frames[2].frames[2] = "BEAMY_C"
frames[2].frames[3] = "BEAMY_D"
frames[2].frames[4] = "BEAMY_E"
frames[2].frames[5] = "BEAMY_F"
frames[2].frames[6] = "BEAMY_G"
frames[2].frames[7] = "BEAMY_H"
frames[2].frames[8] = "BEAMY_I"
frames[2].frames[9] = "BEAMY_J"
frames[2].frames[10] = "BEAMY_K"
frames[2].frames[11] = "BEAMY_L"
frames[2].frames[12] = "BEAMY_M"
frames[2].frames[13] = "BEAMY_N"
frames[2].frames[14] = "BEAMY_O"
frames[2].frames[15] = "BEAMY_P"
frames[2].frames[16] = "BEAMY_Q"
frames[2].frames[17] = "BEAMY_R"
frames[2].frames[18] = "BEAMY_S"
frames[2].frames[19] = "BEAMY_T"
frames[2].frames[20] = "BEAMY_U"
frames[2].frames[21] = "BEAMY_V"
frames[2].frames[22] = "BEAMY_W"
frames[2].frames[23] = "BEAMY_X"
frames[3] = {}
frames[3].rotatenum = 24
frames[3].frames = {}
frames[3].frames[0] = "RCKB1_A"
frames[3].frames[1] = "RCKB1_B"
frames[3].frames[2] = "RCKB1_C"
frames[3].frames[3] = "RCKB1_D"
frames[3].frames[4] = "RCKB1_E"
frames[3].frames[5] = "RCKB1_F"
frames[3].frames[6] = "RCKB1_G"
frames[3].frames[7] = "RCKB1_G"
frames[3].frames[8] = "RCKB1_G"
frames[3].frames[9] = "RCKB1_G"
frames[3].frames[10] = "RCKB1_G"
frames[3].frames[11] = "RCKB1_G"
frames[3].frames[12] = "RCKB1_G"
frames[3].frames[13] = "RCKB1_S"
frames[3].frames[14] = "RCKB1_S"
frames[3].frames[15] = "RCKB1_S"
frames[3].frames[16] = "RCKB1_S"
frames[3].frames[17] = "RCKB1_S"
frames[3].frames[18] = "RCKB1_S"
frames[3].frames[19] = "RCKB1_T"
frames[3].frames[20] = "RCKB1_U"
frames[3].frames[21] = "RCKB1_V"
frames[3].frames[22] = "RCKB1_W"
frames[3].frames[23] = "RCKB1_X"
frames[4] = {}
frames[4].rotatenum = 24
frames[4].frames = {}
frames[4].frames[0] = "RCKB2_A"
frames[4].frames[1] = "RCKB2_B"
frames[4].frames[2] = "RCKB2_C"
frames[4].frames[3] = "RCKB2_D"
frames[4].frames[4] = "RCKB2_E"
frames[4].frames[5] = "RCKB2_F"
frames[4].frames[6] = "RCKB2_G"
frames[4].frames[7] = "RCKB2_G"
frames[4].frames[8] = "RCKB2_G"
frames[4].frames[9] = "RCKB2_G"
frames[4].frames[10] = "RCKB2_G"
frames[4].frames[11] = "RCKB2_G"
frames[4].frames[12] = "RCKB2_G"
frames[4].frames[13] = "RCKB2_S"
frames[4].frames[14] = "RCKB2_S"
frames[4].frames[15] = "RCKB2_S"
frames[4].frames[16] = "RCKB2_S"
frames[4].frames[17] = "RCKB2_S"
frames[4].frames[18] = "RCKB2_S"
frames[4].frames[19] = "RCKB2_T"
frames[4].frames[20] = "RCKB2_U"
frames[4].frames[21] = "RCKB2_V"
frames[4].frames[22] = "RCKB2_W"
frames[4].frames[23] = "RCKB2_X"
frames[5] = {}
frames[5].rotatenum = 24
frames[5].frames = {}
frames[5].frames[0] = "BEAMT_A"
frames[5].frames[1] = "BEAMT_B"
frames[5].frames[2] = "BEAMT_C"
frames[5].frames[3] = "BEAMT_D"
frames[5].frames[4] = "BEAMT_E"
frames[5].frames[5] = "BEAMT_F"
frames[5].frames[6] = "BEAMT_G"
frames[5].frames[7] = "BEAMT_G"
frames[5].frames[8] = "BEAMT_G"
frames[5].frames[9] = "BEAMT_G"
frames[5].frames[10] = "BEAMT_G"
frames[5].frames[11] = "BEAMT_G"
frames[5].frames[12] = "BEAMT_G"
frames[5].frames[13] = "BEAMT_S"
frames[5].frames[14] = "BEAMT_S"
frames[5].frames[15] = "BEAMT_S"
frames[5].frames[16] = "BEAMT_S"
frames[5].frames[17] = "BEAMT_S"
frames[5].frames[18] = "BEAMT_S"
frames[5].frames[19] = "BEAMT_T"
frames[5].frames[20] = "BEAMT_U"
frames[5].frames[21] = "BEAMT_V"
frames[5].frames[22] = "BEAMT_W"
frames[5].frames[23] = "BEAMT_X"
frames[6] = {}
frames[6].rotatenum = 1
frames[6].frames = {}
frames[6].frames[0] = "HYPERBEM"

local frame1 = AOS_AddFrame(frames[0])
local frame3 = AOS_AddFrame(frames[2])
local frame4 = AOS_AddFrame(frames[3])
local frame5 = AOS_AddFrame(frames[4])
local frame6 = AOS_AddFrame(frames[5])
local frame7 = AOS_AddFrame(frames[6])

local animations = {}
animations[0] = {}
animations[0].speed = 1
animations[0].numframes = 1
animations[0].nextanim = 0
animations[0].frames = {}
animations[0].frames[0] = frame1
animations[2] = {}
animations[2].speed = 1
animations[2].numframes = 1
animations[2].nextanim = 0
animations[2].frames = {}
animations[2].frames[0] = frame3
animations[3] = {}
animations[3].speed = 2
animations[3].numframes = 2
animations[3].nextanim = 0
animations[3].frames = {}
animations[3].frames[0] = frame4
animations[3].frames[1] = frame5
animations[4] = {}
animations[4].speed = 1
animations[4].numframes = 1
animations[4].nextanim = 0
animations[4].frames = {}
animations[4].frames[0] = frame6
animations[5] = {}
animations[5].speed = 1
animations[5].numframes = 1
animations[5].nextanim = 0
animations[5].frames = {}
animations[5].frames[0] = frame7

local anim1 = AOS_AddAnim(animations[0])
local anim3 = AOS_AddAnim(animations[2])
local anim4 = AOS_AddAnim(animations[3])
local anim5 = AOS_AddAnim(animations[4])
local anim6 = AOS_AddAnim(animations[5])
animations[0].nextanim = anim1
animations[2].nextanim = anim3
animations[3].nextanim = anim4
animations[4].nextanim = anim5
animations[5].nextanim = anim6

local objects = {}
objects[0] = {}
objects[0].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 2*FRACUNIT
	object.subscale = 2*FRACUNIT
	object.width = 12*FRACUNIT
	object.height = 3*FRACUNIT
	object.hassub = true
	
	setAnim(object, anim1)
	setSubAnim(object, anim5)
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
	
	// Transparancy
/*	local timer2 = object.timer-(TICRATE*3/4)
	if(timer2 < 0)
		timer2 = 0
	end
	object.drawflags = timer2*10/(TICRATE*3/2)
	if(object.drawflags > 9)
		object.drawflags = 9
	end
	object.drawflags = $1 * V_10TRANS
	if not(object.drawflags)
		object.drawflags = V_10TRANS
	end*/
	
	object.subdrawflags = object.drawflags|V_40TRANS
	
	object.subx = object.x+object.momx
	object.suby = object.y+object.momy
	object.subangle = object.angle
	
	object.timer = $1 + 1
	if(object.timer > TICRATE*3/2)
		removeAOSObject(player, objectnum)
		return
	end
end
objects[0].playercollide = function(player, objectnum, aospn)
	if(aospn < 32)// == player.aosobjects[objectnum].parent)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 210, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	removeAOSObject(player, objectnum)
end
objects[1] = {}
objects[1].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 4*FRACUNIT
	object.subscale = 4*FRACUNIT
	object.width = 24*FRACUNIT
	object.height = 6*FRACUNIT
	object.hassub = true
	
	setAnim(object, anim1)
	setSubAnim(object, anim5)
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
	
	if(object.hitflag)
		object.alttimer = 5
		object.x = $1 - object.momx
		object.y = $1 - object.momy
		object.hitflag = false
	end
	
	if(object.alttimer > 1)
		object.alttimer = $1 - 1
	end
	
	// Transparancy
/*	local timer2 = object.timer-(TICRATE/2)
	if(timer2 < 0)
		timer2 = 0
	end
	object.drawflags = timer2*10/(TICRATE)*/
/*	local timer2 = object.timer-(TICRATE*6/4)
	if(timer2 < 0)
		timer2 = 0
	end
	object.drawflags = timer2*10/(TICRATE*6/2)
	if(object.drawflags > 9)
		object.drawflags = 9
	end
	object.drawflags = $1 * V_10TRANS
	if not(object.drawflags)
		object.drawflags = V_10TRANS
	end*/
	
	object.subdrawflags = object.drawflags|V_40TRANS
	
	object.subx = object.x+object.momx
	object.suby = object.y+object.momy
	object.subangle = object.angle
	
	object.timer = $1 + 1
//	if(object.timer > TICRATE)
	if(object.timer > TICRATE*6/2)
		removeAOSObject(player, objectnum)
		return
	end
end
objects[1].playercollide = function(player, objectnum, aospn)
	if(aospn < 32)// == player.aosobjects[objectnum].parent)
		or(player.aosobjects[objectnum].alttimer > 1)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	local damage = 280
	if(player.aosobjects[objectnum].alttimer)
		damage = 80
	end
	player.aosobjects[objectnum].hitflag = true
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, damage, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
end
objects[2] = {}
objects[2].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 3*FRACUNIT/2
	object.width = 12*FRACUNIT*37/40
	object.height = 3*FRACUNIT*37/40
	
	setAnim(object, anim3)
	
	// Transparancy
	local timer2 = object.timer-TICRATE/3
	if(timer2 < 0)
		timer2 = 0
	end
	object.drawflags = timer2*10/(TICRATE*2/3)
	if(object.drawflags > 9)
		object.drawflags = 9
	end
	object.drawflags = $1 * V_10TRANS
	if not(object.drawflags)
		object.drawflags = V_10TRANS
	end
	
	object.timer = $1 + 1
	if(object.timer > TICRATE*2/3)
		removeAOSObject(player, objectnum)
		return
	end
end
objects[2].playercollide = function(player, objectnum, aospn)
	if(aospn < 32)// == player.aosobjects[objectnum].parent)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 60, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	removeAOSObject(player, objectnum)
end
objects[3] = {}
objects[3].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 2*FRACUNIT
	object.width = 16*FRACUNIT
	object.height = 5*FRACUNIT
	
	setAnim(object, anim4)
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
	
	// Chase the target!
/*	local dirtochase = R_PointToAngle2(object.x, object.y, player.aosplayers[object.target].x, player.aosplayers[object.target].y)
	if(AngleFixed(dirtochase-object.angle) < FRACUNIT)
		object.angle = dirtochase
	else
		local addmul = 1
		if(abs((AngleFixed(dirtochase)%(360*FRACUNIT))-(AngleFixed(object.angle)%(360*FRACUNIT))) > 180*FRACUNIT)
			addmul = -1
		end
		
		if(AngleFixed(dirtochase)%(360*FRACUNIT) > AngleFixed(object.angle)%(360*FRACUNIT))
			object.angle = $1 + (FixedAngle(FRACUNIT)*addmul)
		else
			object.angle = $1 - (FixedAngle(FRACUNIT)*addmul)
		end
	end
	// Hacky fix for overshooting our desired angle
	if(AngleFixed(dirtochase-object.angle) < FRACUNIT)
		object.angle = dirtochase
	end*/
	
	object.timer = $1 + 1
	object.alttimer = 5*FRACUNIT
	object.momx = FixedMul(cos(object.angle), object.alttimer)
	object.momy = FixedMul(sin(object.angle), object.alttimer)
	local angle = R_PointToAngle2(0, 0, object.x, object.y)
	if(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius)
		if(AOSDotProduct(cos(angle), sin(angle), cos(object.angle), sin(object.angle)) < 0)
			object.x = FixedMul(cos(angle), player.arenaradius)
			object.y = FixedMul(sin(angle), player.arenaradius)
		else
			AOSPlaySound(player, sfx_sgbom1)
			removeAOSObject(player, objectnum)
			return
		end
	end
end
objects[3].playercollide = function(player, objectnum, aospn)
	if(aospn < 32)// == player.aosobjects[objectnum].parent)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 170, false, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	AOSPlaySound(player, sfx_sgbom1)
	removeAOSObject(player, objectnum)
end
objects[4] = {}
objects[4].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 2*FRACUNIT
	object.width = 16*FRACUNIT
	object.height = 5*FRACUNIT
	
	setAnim(object, anim4)
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
	
	// Chase the target!
	local dirtochase = object.angle
	if(player.aosplayers[object.target])
		dirtochase = R_PointToAngle2(object.x, object.y, player.aosplayers[object.target].x, player.aosplayers[object.target].y)
	end
	if(AngleFixed(dirtochase-object.angle) < FRACUNIT)
		object.angle = dirtochase
	else
		local addmul = 1
		if(abs((AngleFixed(dirtochase)%(360*FRACUNIT))-(AngleFixed(object.angle)%(360*FRACUNIT))) > 180*FRACUNIT)
			addmul = -1
		end
		
		if(AngleFixed(dirtochase)%(360*FRACUNIT) > AngleFixed(object.angle)%(360*FRACUNIT))
			object.angle = $1 + (FixedAngle(FRACUNIT)*addmul)
		else
			object.angle = $1 - (FixedAngle(FRACUNIT)*addmul)
		end
	end
	// Hacky fix for overshooting our desired angle
	if(AngleFixed(dirtochase-object.angle) < FRACUNIT)
		object.angle = dirtochase
	end
	
	object.timer = $1 + 1
	if(object.timer < TICRATE/4)
	//	object.momx = $1 * 6/7
	//	object.momy = $1 * 6/7
	//	object.alttimer = -R_PointToDist2(0, 0, object.momx, object.momy)
		object.alttimer = 2*FRACUNIT
		object.momx = FixedMul(cos(object.angle), object.alttimer)
		object.momy = FixedMul(sin(object.angle), object.alttimer)
	elseif(object.timer > TICRATE/3)
		object.alttimer = 12*FRACUNIT
		object.momx = FixedMul(cos(object.angle), object.alttimer)
		object.momy = FixedMul(sin(object.angle), object.alttimer)
	end
	local angle = R_PointToAngle2(0, 0, object.x, object.y)
	if(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius)
		if(AOSDotProduct(cos(angle), sin(angle), cos(object.angle), sin(object.angle)) < 0)
			object.x = FixedMul(cos(angle), player.arenaradius)
			object.y = FixedMul(sin(angle), player.arenaradius)
		else
			AOSPlaySound(player, sfx_sgbom1)
			removeAOSObject(player, objectnum)
			return
		end
	end
end
objects[4].playercollide = function(player, objectnum, aospn)
	if(aospn < 32)// == player.aosobjects[objectnum].parent)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 150, false, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	AOSPlaySound(player, sfx_sgbom1)
	removeAOSObject(player, objectnum)
end
objects[5] = {}
objects[5].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.width = 34*FRACUNIT
	object.height = 39*FRACUNIT
	object.dontdraw = true
	
	if(object.timer)
		removeAOSObject(player, objectnum)
		return
	end
	object.timer = $1 + 1
end
objects[5].playercollide = function(player, objectnum, aospn)
	if(aospn < 32)// == player.aosobjects[objectnum].parent)
		return
	end
	if not(player.aosplayers[player.aosobjects[objectnum].parent].attackvar)
		AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 300/3, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y, 0)
	else
		AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 60*2/3, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y, 0)
	end
	
	if not(player.aosplayers[player.aosobjects[objectnum].parent].shieldtime)
		or(player.aosplayers[player.aosobjects[objectnum].parent].shieldtime >= 0)
		player.aosplayers[player.aosobjects[objectnum].parent].shieldtime = -TICRATE
	end
	
	if not(player.aosplayers[player.aosobjects[objectnum].parent].attackvar)
		and(player.aosplayers[player.aosobjects[objectnum].parent].currentattack == 3)
		player.aosplayers[player.aosobjects[objectnum].parent].attackvar = 1
	end
end
objects[6] = {}
objects[6].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.width = 16*FRACUNIT
	object.height = 14*FRACUNIT
	object.x = player.aosplayers[object.parent].x+(7*cos(player.aosplayers[object.parent].shootdirection))
	object.y = player.aosplayers[object.parent].y+(7*sin(player.aosplayers[object.parent].shootdirection))
	object.dontdraw = true
	
	if(object.timer > TICRATE/3)
		removeAOSObject(player, objectnum)
		return
	end
	object.timer = $1 + 1
end
objects[6].playercollide = function(player, objectnum, aospn)
	if(aospn < 32)// == player.aosobjects[objectnum].parent)
		return
	end
	if not(player.aosplayers[player.aosobjects[objectnum].parent].attackvar)
		AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 290, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y, 0)
	else
		AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 120, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y, 0)
	end
	player.aosplayers[player.aosobjects[objectnum].parent].lockspeed = false
	if not(player.aosplayers[player.aosobjects[objectnum].parent].attackvar)
		and(player.aosplayers[player.aosobjects[objectnum].parent].currentattack == 4)
		player.aosplayers[player.aosobjects[objectnum].parent].attackvar = 2
	end
	removeAOSObject(player, objectnum)
end
objects[7] = {}
objects[7].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	if(object.scale < FRACUNIT*3/2)
		object.scale = $1 + (FRACUNIT/30)
		if(object.scale >= FRACUNIT*3/2)
			object.scale = FRACUNIT*3/2
			AOSPlaySound(player, sfx_sglazr)
		end
	end
	if not(object.timer)
		object.scale = 1
	end
	object.width = 58*object.scale
	object.height = 58*object.scale
	object.spherecollision = true
	
	if(object.scale < FRACUNIT*3/2)
		object.momx = FixedMul(cos(object.angle), (FRACUNIT/30)*468/14)
		object.momy = FixedMul(sin(object.angle), (FRACUNIT/30)*468/14)
	else
		object.momx = FixedMul(cos(object.angle), (FRACUNIT/30)*468/4)
		object.momy = FixedMul(sin(object.angle), (FRACUNIT/30)*468/4)
	end
	
	setAnim(object, anim6)
	
	if(object.alttimer > 1)
		object.alttimer = $1 - 1
	end
	
	object.timer = $1 + 1
	if(object.timer > TICRATE*8)
		removeAOSObject(player, objectnum)
		return
	end
end
objects[7].playercollide = function(player, objectnum, aospn)
	if(aospn < 32)// == player.aosobjects[objectnum].parent)
		or(player.aosobjects[objectnum].alttimer > 1)
		return
	end
	player.aosobjects[objectnum].alttimer = 10
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 250, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
end
beam1 = AOS_AddObject(objects[0])
beam2 = AOS_AddObject(objects[1])
beam3 = AOS_AddObject(objects[2])
missile1 = AOS_AddObject(objects[3])
missile2 = AOS_AddObject(objects[4])
meleeobj = AOS_AddObject(objects[5])
meleeobj2 = AOS_AddObject(objects[6])
hyperbeam = AOS_AddObject(objects[7])

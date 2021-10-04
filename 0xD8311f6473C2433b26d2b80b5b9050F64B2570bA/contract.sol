// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

contract CDFData {
    // duration -> [sigmas 0%, 5%, 10%, 15%, 20%.... 200%]
    mapping (uint => uint24[]) public CDF;
    uint16[] public Durations = [120,240,360,480,600,720,840,960,1080,1200,1320,1440,1560,1680,1800,1920,2040,2160,2280,2400,2520,2640,2760,2880,3000,3120,3240,3360,3480,3600];
    uint public constant Amplifier = 1e9;

    uint24[] private _cdf120=[0,38910,77821,116731,155642,194552,233463,272373,311284,350194,389105,428016,466926,505837,544747,583658,622568,661479,700389,739300,778210,817121,856031,894942,933853,972763,1011674,1050584,1089495,1128405,1167316];
    uint24[] private _cdf240=[0,55027,110055,165083,220111,275139,330166,385194,440222,495250,550278,605306,660333,715361,770389,825417,880445,935472,990500,1045528,1100556,1155584,1210611,1265639,1320667,1375695,1430722,1485750,1540778,1595806,1650833];
    uint24[] private _cdf360=[0,67395,134790,202185,269580,336975,404370,471765,539160,606555,673950,741345,808740,876135,943530,1010925,1078320,1145715,1213110,1280505,1347900,1415295,1482690,1550085,1617480,1684875,1752269,1819664,1887059,1954454,2021849];
    uint24[] private _cdf480=[0,77821,155642,233463,311284,389105,466926,544747,622568,700389,778210,856031,933853,1011674,1089495,1167316,1245137,1322958,1400779,1478600,1556421,1634242,1712062,1789883,1867704,1945525,2023346,2101167,2178988,2256808,2334629];
    uint24[] private _cdf600=[0,87006,174013,261019,348026,435033,522039,609046,696053,783059,870066,957072,1044079,1131085,1218092,1305099,1392105,1479112,1566118,1653124,1740131,1827137,1914144,2001150,2088156,2175163,2262169,2349175,2436182,2523188,2610194];
    uint24[] private _cdf720=[0,95310,190621,285932,381243,476554,571865,667176,762487,857798,953109,1048420,1143731,1239042,1334353,1429664,1524975,1620285,1715596,1810907,1906218,2001528,2096839,2192150,2287460,2382771,2478081,2573392,2668702,2764013,2859323];
    uint24[] private _cdf840=[0,102947,205895,308842,411790,514738,617685,720633,823581,926528,1029476,1132423,1235371,1338318,1441266,1544213,1647161,1750108,1853055,1956003,2058950,2161897,2264845,2367792,2470739,2573686,2676633,2779580,2882527,2985474,3088421];
    uint24[] private _cdf960=[0,110055,220111,330166,440222,550278,660333,770389,880445,990500,1100556,1210611,1320667,1430722,1540778,1650833,1760889,1870944,1980999,2091055,2201110,2311165,2421220,2531275,2641331,2751386,2861441,2971495,3081550,3191605,3301660];
    uint24[] private _cdf1080=[0,116731,233463,350194,466926,583658,700389,817121,933853,1050584,1167316,1284047,1400779,1517510,1634242,1750973,1867704,1984436,2101167,2217898,2334629,2451360,2568091,2684823,2801553,2918284,3035015,3151746,3268477,3385207,3501938];
    uint24[] private _cdf1200=[0,123045,246091,369137,492183,615229,738275,861321,984367,1107413,1230459,1353505,1476550,1599596,1722642,1845687,1968733,2091779,2214824,2337870,2460915,2583960,2707006,2830051,2953096,3076141,3199186,3322231,3445276,3568321,3691365];
    uint24[] private _cdf1320=[0,129051,258103,387155,516206,645258,774310,903361,1032413,1161464,1290516,1419567,1548619,1677670,1806722,1935773,2064824,2193876,2322927,2451978,2581029,2710080,2839131,2968182,3097233,3226283,3355334,3484384,3613435,3742485,3871535];
    uint24[] private _cdf1440=[0,134790,269580,404370,539160,673950,808740,943530,1078320,1213110,1347900,1482690,1617480,1752269,1887059,2021849,2156639,2291428,2426218,2561007,2695796,2830586,2965375,3100164,3234953,3369742,3504531,3639320,3774108,3908897,4043685];
    uint24[] private _cdf1560=[0,140293,280587,420881,561175,701469,841763,982057,1122351,1262645,1402939,1543232,1683526,1823820,1964113,2104407,2244700,2384994,2525287,2665580,2805874,2946167,3086460,3226752,3367045,3507338,3647631,3787923,3928215,4068508,4208800];
    uint24[] private _cdf1680=[0,145589,291179,436769,582359,727949,873539,1019129,1164719,1310308,1455898,1601488,1747078,1892667,2038257,2183846,2329435,2475025,2620614,2766203,2911792,3057381,3202970,3348559,3494147,3639736,3785324,3930912,4076500,4222088,4367676];
    uint24[] private _cdf1800=[0,150699,301399,452099,602799,753499,904199,1054899,1205598,1356298,1506998,1657697,1808397,1959096,2109796,2260495,2411195,2561894,2712593,2863292,3013991,3164690,3315388,3466087,3616785,3767483,3918182,4068880,4219578,4370275,4520973];
    uint24[] private _cdf1920=[0,155642,311284,466926,622568,778210,933853,1089495,1245137,1400779,1556421,1712062,1867704,2023346,2178988,2334629,2490271,2645912,2801553,2957195,3112836,3268477,3424118,3579758,3735399,3891039,4046680,4202320,4357960,4513599,4669239];
    uint24[] private _cdf2040=[0,160432,320864,481296,641729,802161,962593,1123025,1283457,1443890,1604322,1764754,1925185,2085617,2246049,2406481,2566912,2727344,2887775,3048206,3208637,3369068,3529499,3689930,3850360,4010790,4171221,4331651,4492081,4652510,4812940];
    uint24[] private _cdf2160=[0,165083,330166,495250,660333,825417,990500,1155584,1320667,1485750,1650833,1815916,1980999,2146082,2311165,2476248,2641331,2806413,2971495,3136578,3301660,3466742,3631824,3796905,3961987,4127068,4292150,4457231,4622311,4787392,4952472];
    uint24[] private _cdf2280=[0,169607,339214,508821,678428,848035,1017642,1187249,1356856,1526463,1696070,1865677,2035283,2204890,2374496,2544103,2713709,2883315,3052921,3222527,3392133,3561738,3731343,3900949,4070554,4240159,4409763,4579368,4748972,4918576,5088180];
    uint24[] private _cdf2400=[0,174013,348026,522039,696053,870066,1044079,1218092,1392105,1566118,1740131,1914144,2088156,2262169,2436182,2610194,2784206,2958218,3132230,3306242,3480254,3654266,3828277,4002288,4176299,4350310,4524320,4698331,4872341,5046351,5220361];
    uint24[] private _cdf2520=[0,178310,356621,534931,713242,891552,1069862,1248173,1426483,1604793,1783104,1961414,2139724,2318033,2496343,2674653,2852962,3031272,3209581,3387890,3566199,3744507,3922816,4101124,4279432,4457740,4636048,4814355,4992662,5170969,5349276];
    uint24[] private _cdf2640=[0,182506,365013,547519,730026,912533,1095039,1277546,1460052,1642558,1825065,2007571,2190077,2372583,2555088,2737594,2920100,3102605,3285110,3467615,3650120,3832625,4015129,4197633,4380137,4562641,4745145,4927648,5110151,5292654,5475156];
    uint24[] private _cdf2760=[0,186608,373216,559825,746433,933042,1119650,1306258,1492866,1679474,1866082,2052690,2239298,2425906,2612513,2799121,2985728,3172335,3358942,3545548,3732155,3918761,4105367,4291973,4478579,4665184,4851789,5038394,5224999,5411603,5598207];
    uint24[] private _cdf2880=[0,190621,381243,571865,762487,953109,1143731,1334353,1524975,1715596,1906218,2096839,2287460,2478081,2668702,2859323,3049944,3240565,3431185,3621805,3812425,4003045,4193664,4384283,4574902,4765521,4956139,5146758,5337376,5527993,5718610];
    uint24[] private _cdf3000=[0,194552,389105,583658,778210,972763,1167316,1361868,1556421,1750973,1945525,2140077,2334629,2529181,2723733,2918284,3112836,3307387,3501938,3696489,3891039,4085590,4280140,4474690,4669239,4863788,5058337,5252886,5447434,5641982,5836530];
    uint24[] private _cdf3120=[0,198405,396811,595216,793622,992028,1190433,1388838,1587244,1785649,1984054,2182459,2380864,2579269,2777673,2976078,3174482,3372886,3571290,3769693,3968096,4166499,4364902,4563305,4761707,4960109,5158511,5356912,5555313,5753714,5952114];
    uint24[] private _cdf3240=[0,202185,404370,606555,808740,1010925,1213110,1415295,1617480,1819664,2021849,2224033,2426218,2628402,2830586,3032770,3234953,3437137,3639320,3841503,4043685,4245868,4448050,4650232,4852413,5054595,5256776,5458956,5661136,5863316,6065496];
    uint24[] private _cdf3360=[0,205895,411790,617685,823581,1029476,1235371,1441266,1647161,1853055,2058950,2264845,2470739,2676633,2882527,3088421,3294315,3500208,3706101,3911994,4117887,4323779,4529671,4735563,4941455,5147346,5353237,5559127,5765017,5970907,6176796];
    uint24[] private _cdf3480=[0,209539,419079,628619,838158,1047698,1257237,1466777,1676316,1885855,2095394,2304933,2514472,2724011,2933549,3143087,3352625,3562163,3771701,3981238,4190775,4400312,4609848,4819384,5028920,5238455,5447990,5657525,5867059,6076593,6286126];
    uint24[] private _cdf3600=[0,213121,426243,639365,852487,1065609,1278730,1491852,1704973,1918094,2131216,2344337,2557458,2770578,2983699,3196819,3409939,3623059,3836178,4049298,4262417,4475535,4688654,4901772,5114889,5328007,5541124,5754240,5967356,6180472,6393587];
    
    constructor() public{
        CDF[120]=_cdf120;
        CDF[240]=_cdf240;
        CDF[360]=_cdf360;
        CDF[480]=_cdf480;
        CDF[600]=_cdf600;
        CDF[720]=_cdf720;
        CDF[840]=_cdf840;
        CDF[960]=_cdf960;
        CDF[1080]=_cdf1080;
        CDF[1200]=_cdf1200;
        CDF[1320]=_cdf1320;
        CDF[1440]=_cdf1440;
        CDF[1560]=_cdf1560;
        CDF[1680]=_cdf1680;
        CDF[1800]=_cdf1800;
        CDF[1920]=_cdf1920;
        CDF[2040]=_cdf2040;
        CDF[2160]=_cdf2160;
        CDF[2280]=_cdf2280;
        CDF[2400]=_cdf2400;
        CDF[2520]=_cdf2520;
        CDF[2640]=_cdf2640;
        CDF[2760]=_cdf2760;
        CDF[2880]=_cdf2880;
        CDF[3000]=_cdf3000;
        CDF[3120]=_cdf3120;
        CDF[3240]=_cdf3240;
        CDF[3360]=_cdf3360;
        CDF[3480]=_cdf3480;
        CDF[3600]=_cdf3600;
    }

    function numDurations() external view returns (uint) {
        return Durations.length;
    }
}
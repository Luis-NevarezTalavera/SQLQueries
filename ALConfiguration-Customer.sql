-- Query to Obtain the Parent L1 streams for a specific assetId/L2 streamId,also with the corresponding ALConfiguration records
Use AssetLibrary
SELECT	DISTINCT	--   S.AssetId, S.StreamId, S.StreamName,
	  v2.VariantID as L2VariantID, v2.Description as L2VariantName, C.Name as L2Type, 
	  -- SC.ConfigurationID, v2.CreatedDateTime, v2.IsDeprecated, v2.IsDeleted, -- CV.Required as CV_Required, CV.IsDeleted as CV_IsDeleted , 
	  Cu.CustomerID, Cu.CustomerName, -- Cu.IsDeleted,
	  v1.VariantID as L1VariantID, v1.Description as L1VariantName -- v1.IsDeprecated, v1.IsDeleted
FROM	ALVariant V2	Left Outer Join ALStreamSourceConfiguration SC On V2.VariantID = SC.VariantID
						Left Outer Join ALVariant V1 On V1.VariantID = SC.SourceVariantID
						Left Outer Join ALConfiguration C On SC.ConfigurationID = C.ConfigurationID
					--	Left Outer Join ALStream S On V2.VariantID = S.VariantID
					--	Left Outer Join ALAsset A WITH (NOLOCK) ON S.AssetID = A.AssetID
					--	Left Outer Join ALTitleAsset TA WITH (NOLOCK) ON A.AssetID = TA.AssetID
					--	Left Outer Join ALTitle T WITH (NOLOCK) ON TA.TitleID = T.TitleID
						Left Join CPI..CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),v2.VariantId) = CV.VariantId
						Left Outer Join CPI..Customer Cu ON CV.CustomerID = Cu.CustomerID
WHERE	 C.StreamLevel = 2 -- and (v2.IsDeprecated=1 or v2.IsDeleted=1  or  SC.VariantID Is  Null  or  CV.IsDeleted=1  or  CV.VariantId Is  Null  or  Cu.IsDeleted=1  or  v1.IsDeprecated=1 and v1.IsDeleted=1 )
-- and CV.VariantID is Null
-- and ( TitleName like 'QA%Regression%2017/11/14%' )
-- and  SC.ConfigurationID = 6 -- not in (1,2,3,4,5) -- 6,7,12,13,14,15,16,17,18,19,20,21) -- 9 = Art Reference: Image
-- and  SC.VariantID  in (270,271,272,273,274,275,276,278,280,281,282,283,284,285,285,290,292,305,305,313,321,322,328,329,428,429,430,433,434,435,1002,1003,1004,1100,1101,1102,1103,1106,1107,1110,1111,1112,1900,1904,1905,1906,1907,1908,1909,2510,2511,2512,2516,2517,2518,2519,2520,2521,2522,2523,2525,2527,2528,2529,2530,2531,2552,2553,2554,2555,2564,2565,2566,2567,2568,2569,2570,2571,2572,2573,2574,2575,2576,2577,2578,2580,2581,2582,2583,2583,2584,2585,2586,2587,2588,2589,2590,2591,2592,2592,2593,2593,2594,2594,2595,2595,2596,2596,2597,2597,2598,2599,2600,2601,2602,2603,2604,2605,2605,2606,2607,2608,2609,2610,2611,2612,2613,2614,2615,2616,2617,2618,2619,2620,2621,2622,2623,2630,2631,2634,2634,2635,2635,2636,2636,2637,2637,2638,2639,2640,2641,2642,2643,2644,2645,2646,2647,2648,2649,2650,2651,2659,2660,2691,2692,2693,2694,2695,2696,2697,2698,2699,2700,2701,2702,2703,2704,2705,2706,2707,2708,2711,2712,2713,2714,2715,2716,2717,2718,2719,2720,2721,2722,2723,2724,2725,2726,2728,2729,2730,2731,2732,2733,2734,2735,2736,2737,2738,2739,2740,2741,2742,2743,2744,2745,2758,2758,2758,2759,2759,2759,2760,2761,2762,2763,2764,2765,2766,2767,2768,2769,2770,2771,2772,2773,2774,2775,2776,2777,2778,2779,2780,2781,2782,2783,2784,2785,2786,2787,2788,2789,2790,2791,2792,2793,2794,2795,2796,2797,2798,2799,2800,2801,2802,2803,2804,2805,2809,2810,2811,2812,2813,2814,2815,2816,2817,2818,2819,2820,2821,2822,2823,2824,2825,2826,2827,2828,2829,2830,2831,2832,2833,2834,2835,2836,2837,2838,2839,2842,2843,2844,2845,2846,2847,2848,2849,2850,2851,2852,2853,2854,2855,2856,2857,2858,2859,2860,2861,2862,2863,2864,2865,2866,2866,2867,2867,2868,2869,2870,2870,2871,2871,2872,2873,2874,2875,2876,2877,2878,2879,2880,2881,2882,2883,2884,2885,3512,3513,3514,3515,4009,4406,4409,4410,4411,4422,4423,4424,4425,4426,4427,5000,5004,5005,5006,5007,5008,5009,5019,5020,5021,6500,6501) --   L2 variantId
-- and  v2.IsDeprecated is true
-- and 'v1-'+CONVERT(varchar(8),SC.VariantID)  in ( select VariantId from CPI..CustomerVariant CV Inner Join CPI..Customer Cu ON CV.CustomerID = Cu.CustomerID  where  CV.IsDeleted in(1) or CV.Required in (0) or Cu.IsDeleted in (1))
-- and  SC.SourceVariantID  not in (112,113,114,115,116,120,121,122,162, 117,118,163,166,168,170) -- L1 variantId
-- and  SC.SourceVariantID  > 200 -- L1 variantId
-- and  S.StreamName like 'QA_Smoke%'
-- and  S.AssetID  in (1348998) --
-- and  S.AssetId  in (select TA.AssetID from ALTitle T WITH (NOLOCK) Left Outer Join ALTitleAsset TA ON T.TitleID = TA.TitleID  where  TitleName like  'QA_Regression_2017/02/15_280%'  )
-- and  S.Status in ('Transcode Successful')
-- and  V2.VariantName like '%SAP%' -- V1.Description like '%SAP%'
-- and  Cu.CustomerID in (26,28,31,37,40,43,48,51,53,54,55,56,57,58,59,61,63,64,65)
-- and  Cu.CustomerName  not in ('RogersUnified') -- 'Deluxe Digital Distributions') -- 'Charter','CharterTWC','CharterBackfill') -- 'Big Starz') --'Starz', 'MoviePlex', 'Encore', 'RedBox') --   Shaw -- Is Not Null
-- and  Cu.CustomerName  not in (select CustomerName from CPI..Customer Where CustomerName not in ('Shaw'))
-- and  V2.VariantName like '%720%'
-- and  Cu.IsDeleted=0  and CV.IsDeleted=0
 Order by Cu.CustomerName, L2VariantID,L1VariantID --  S.AssetId, SC.OrderNumber --   C.StreamLevel,

-- select * from CPI..Customer where CustomerName like '%Roger%'
-- select * from ALVariant where Description like '%deprecated%' or Description like '%use%' or IsDeprecated=1 or IsDeleted=1
-- select * from CPI..CustomerVariant where VariantId in( 'v1-2652','v1-2653','v1-2658') -- Required in(0,1) and CustomerVariantGroupID = 835 -- and CustomerConfigurationID in(1023,1024,1025,1026,1027) -- 
-- select * from ALStreamSourceConfiguration where SourceVariantID = 200 -- Order by VariantID,OrderNumber
-- select * from ALConfiguration
/*
1	Source
2	Transcode
3	Key Disc, AACS
4	Key Disc, Clear
5	Widevine Transcode
6	Widevine
7	Playready
8	Art Reference: Cover Art
9	Art Reference: Image
10	L1s Only
11	Closed Caption Transform
12  Package, Clear
13	DCD Package, Clear
14	Thumbnails
15	Sidecar
16	Unified Streaming
17	Unencrypted Passthrough
18	HLS
19	Modular
20	FairPlay
21	BiffImage

Select * ALVariantTypeLookup
0	Undefined
1	SourceAsset
2	VideoOnly
3	AudioOnly
4	VideoAudio
5	Special
6	Compound
7	ArtReference
8	Subtitle
9	AudioExtraction
13	L1sOnly
14	Thumbnails
15	ConformedDigitialAd
16	ExtractedDigitalAd
*/
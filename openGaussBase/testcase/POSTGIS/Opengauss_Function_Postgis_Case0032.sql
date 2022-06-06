-- @testpoint: PostGIS功能覆盖,gist索引

--step1:创建表格，建立gist索引   expect:成功
drop table if exists t_postgis_0032;
create table t_postgis_0032 (
    smid integer default 0 not null,
    smuserid integer default 0 not null,
    smtopoerror integer default 0 not null,
    smlength double precision default 0 not null,
    smgeometry geometry,
    obj_code character varying(5000),
    obj_name character varying(5000),
    center_x double precision,
    center_y double precision,
    cros_boun_type character varying(5000),
    rv_type character varying(5000),
    rv_grad character varying(5000),
    rv_bas_area numeric(16,2),
    rv_len numeric(12,3));

create index i_postgis_0032 on t_postgis_0032 using gist (smgeometry);

--step2:插入数据   expect:成功
insert into t_postgis_0032 values (78140, 0, 0, 17869.1840279641, '01020000208A11000003000000FDAC8B5B91185C40824EF79D821C4240EBB5ABEB3B115C4062C550CB33124240168676EEDB0F5C403382CBAB82124240', 'D7A136A0000L', '郭都河', 112.310607837608, 36.1797362020067, '5', '1', '2', 58.40, 18.000);
insert into t_postgis_0032 values (78141, 0, 0, 24719.1047723292, '01020000208A110000050000003BEEC18B3D6C5B40465A1DAE3348424096DCA28EFD6C5B40182570E7CC4A42400908812B3E705B4077DE3E36644C4240358820FE9C715B40F2CE4E0E554F4240AD798DF02F795B400992796C494C4240', 'D4C4C000000R', '郭旗河', 109.777590993082, 36.619785351265, '4', '1', '2', 105.00, 25.000);
insert into t_postgis_0032 values (78142, 0, 0, 22157.4257387183, '01020000208A11000005000000AA605DE6BC715B4067B656AD3D174240937EB65B78725B4077482427B11C4240FCD173682A765B408BBB7071F81F42405BDC0FCE83765B40153C48E42D244240BB76D0A288785B4064600261B1284240', 'D4DEA000000R', '汉庄川', 109.830605963261, 36.2406089597926, '5', '1', '3', 92.00, 22.000);
insert into t_postgis_0032 values (78143, 0, 0, 27686.0995602528, '01020000208A11000003000000D1980B4E8CA85B40C185470D1B744240C09638DCC3A45B40FA9474BB6E774240D73681D8079A5B405DE9EDE7C8754240', 'D41C0000000L', '和合河', 110.511531490774, 36.9287458060487, '5', '1', '1', 118.00, 28.000);
insert into t_postgis_0032 values (78144, 0, 0, 25672.8315924964, '01020000208A11000005000000B4815FD698AB5B40A40AA40A5D274240A51202EFEBAC5B40C82FA5A0C72742407248DECA39B05B408C116E44EE2E4240582FC544CDAF5B40D380ED4296354240CFD47406C2AD5B40E7CDD8FE223A4240', 'D4B8A000000L', '河底沟', 110.752605569308, 36.3727369537523, '5', '1', '2', 68.80, 26.000);
insert into t_postgis_0032 values (78145, 0, 0, 19505.4960957102, '01020000208A110000050000002B651AAAA68B5B40BF0350C2567743408B80907EA88A5B40EA1A8A7E4073434050DA597A81865B4060CBF8CE406C4340FC77611CDF865B401B40B346DB694340F90EBC58BF845B4004C634A614694340', 'D34F2A00000L', '河则沟', 110.128007713083, 38.8688890800571, '5', '1', '2', 84.90, 20.000);
insert into t_postgis_0032 values (78146, 0, 0, 20529.0772795481, '01020000208A11000004000000CF98F047946B5B40CF01281A1E7742404D17FAD7CB6D5B405088D7249C7542404840617DE76F5B407F6B22C8187B4240808B7B63A6745B40E23E069E05814240', 'D4ACA000000R', '贺家渠川', 109.747687525695, 36.9600943175276, '5', '1', '3', 106.00, 21.000);
insert into t_postgis_0032 values (78147, 0, 0, 21825.7235212243, '01020000208A110000030000002FADCFADBBBE5B40EC2DD8F608CA424092E40C6E16B95B40EC72EE8C11CC42401AC607D4BCB15B407BDE9D2F21CA4240', 'D3473A00000L', '贺龙沟', 110.869472741384, 37.5869493570879, '4', '1', '1', 66.10, 22.000);
insert into t_postgis_0032 values (78148, 0, 0, 22866.9468682485, '01020000208A110000030000006400E21974385B40B346DD1DDC8742405FE9E9A2DC3F5B40B331170ED68742400D17DE72D7445B40B8D5C8F1248B4240', 'D4C1C000000R', '贺庄沟', 108.9850654149, 37.0656386045732, '4', '1', '2', 71.00, 23.000);
insert into t_postgis_0032 values (78149, 0, 0, 27834.8071959028, '01020000208A110000050000007F591F762ECC5B40C6EC8392C31B4240F67D544B36CE5B40669AAB24941A4240EECD2A541BD15B40730FCFEA791D4240947C4602C7CF5B40A50193826C2542401EE50E544BCC5B409BBD157F202F4240', 'D4BA0000000L', '黑龙关河', 111.251142783286, 36.2704044705281, '4', '1', '2', 170.00, 28.000);
insert into t_postgis_0032 values (78150, 0, 0, 27658.4997023829, '01020000208A110000040000006BD23D8432A05B40BD96A42BAD664140A848C3B12FA05B40CAC8C151086441402E43402981A25B40AF33D473265F414005110226C4A15B40C96F463F464B4140', 'D613B000000L', '黑龙涧', 110.537715238581, 34.702066558188, '5', '1', '1', 68.50, 28.000);
insert into t_postgis_0032 values (78151, 0, 0, 16139.3966137765, '01020000208A11000004000000C8996729BE265C40F9031499310B424091D2125AEE255C40B7A941CAD80C42400110A77F39235C4063867A6818094240D2D8885DA21E5C40FD2E25CDF9094240', 'D7A1CA00000L', '横水河', 112.543742382505, 36.0703835558515, '4', '1', '3', 81.20, 16.000);
insert into t_postgis_0032 values (78152, 0, 0, 18019.6510895518, '01020000208A110000040000008851231ACB5F5B40D19F6B9C02A242404114C8757B625B40D74E5C0659A14240C440C00EF2635B409498E435DA984240A8CA44FFB9655B40AFFE224910954240', 'D4A1C000000L', '红石峁沟', 109.555790740279, 37.229376205447, '5', '1', '2', 77.50, 18.000);
insert into t_postgis_0032 values (78153, 0, 0, 21695.4725766321, '01020000208A110000050000000F77E88F21B95B4071D9AAEE156B414045D726BB63BB5B40AF8513C4AD6B4140E88BA8CC99BD5B4023202BCC37644140AF35611715BE5B4061745090E05E41406AC4B6961FBD5B40EE486E73CE5B4140', 'D62A0000000L', '洪阳涧', 110.954013656115, 34.7952047269054, '4', '1', '1', 173.00, 22.000);
insert into t_postgis_0032 values (78154, 0, 0, 25397.7656334214, '01020000208A110000030000008FF2D371ADAA5B4090FF01246C764340B64F1DD999A65B4057DBFE0CEC7243408CB6D75EA3A05B40E7D46FD118664340', 'D34E26A0000L', '呼家沟', 110.584539384148, 38.8703508957802, '5', '1', '2', 103.00, 25.000);
insert into t_postgis_0032 values (78155, 0, 0, 20396.7367927956, '01020000208A110000040000009F496AF2F72D5C40964FC5501DDF414087B31883632B5C404E04F9486DDB41404B5762E80B285C404AD19AF43DDA414019375029F4225C403829B00FE0DD4140', 'D7A1FC00000L', '胡底河', 112.634786092267, 35.7060806839729, '4', '1', '3', 95.90, 20.000);
insert into t_postgis_0032 values (78156, 0, 0, 16187.3666300217, '01020000208A110000020000003C0455BC7DB65B40A42FD6069B6F424094E573FCB9B55B40D63FD617C87F4240', 'D348B1B0000L', '胡家峪河', 110.849659245932, 36.9365480484973, '5', '1', '2', 57.60, 16.000);

--step3:分析添加索引时的查询性能   expect:成功
explain performance select * from t_postgis_0032 where st_dwithin(smgeometry,st_setsrid(st_point(111,70),4490),10000) order by smgeometry;

--step4:删除索引   expect:成功
drop index i_postgis_0032 cascade;

--step5:无索引时分析查询性能   expect:成功
explain performance select * from t_postgis_0032 where st_dwithin(smgeometry,st_setsrid(st_point(111,70),4490),10000) order by smgeometry;

--step6:清理环境   expect:成功
drop table t_postgis_0032 cascade;

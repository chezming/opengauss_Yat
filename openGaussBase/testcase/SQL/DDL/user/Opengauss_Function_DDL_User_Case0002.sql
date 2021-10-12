-- @testpoint: 创建用户,用户名长度测试，用户名已存在，合理报错
--创建用户，用户名等于63字节
drop user if exists test_user002gkhbvkgbkjtg87tgugrfuygnnkljlrfffgfcvgviuyhhmgvbvjh cascade;
create user test_user002gkhbvkgbkjtg87tgugrfuygnnkljlrfffgfcvgviuyhhmgvbvjh identified by 'Tt@123456';
--创建用户，用户名等于64字节,截断前63位，用户名已存在，报错
drop user if exists test_user002gkhbvkgbkjtg87tgugrfuygnnkljlrfffgfcvgviuyhhmgvbvjhk cascade;
create user test_user002gkhbvkgbkjtg87tgugrfuygnnkljlrfffgfcvgviuyhhmgvbvjhk identified by 'Tt@123456';
--删除用户
drop user test_user002gkhbvkgbkjtg87tgugrfuygnnkljlrfffgfcvgviuyhhmgvbvjh cascade;
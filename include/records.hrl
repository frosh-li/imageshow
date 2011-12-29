-record(
    users,{
        uid = "",
        nickname = "",
        realname = "",
        email = "",
        password = "",
        sex = "",
        avatar = "",
        lbsinfo = "",% 地址信息 省市信息
        contract = "", %%联系方式
        intro = "",%个人介绍
        liketags = "",%关注的标签列表
        friends = "",%好友uid列表
        likeuid = "",%关注的用户
        belikeduid="",%关注我的用户
        score = "",%积分
        group = "", %所在用户组
        private = "" ,%隐私设置 针对联系方式 1，2，3为公开 保密 好友可见
        registerdate = "",%注册日期和时间
        registerip = "",%注册IP地址
        lastlogin = "" %最后登录时间
    }
).

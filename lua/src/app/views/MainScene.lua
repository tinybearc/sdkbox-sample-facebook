
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    print("Sample Startup")

    local logo = cc.Sprite:create("Logo.png")
    local logoSize = logo:getContentSize()
    logo:setPosition(cc.p(logoSize.width / 2, display.top - logoSize.height / 2))
    self:addChild(logo)

    local label = cc.Label:createWithSystemFont("QUIT", "sans", 32)
    local quit = cc.MenuItemLabel:create(label)
    quit:onClicked(function()
        os.exit(0)
    end)
    local size = label:getContentSize()
    local menu = cc.Menu:create(quit)
    menu:setPosition(display.right - size.width / 2 - 16, display.bottom + size.height / 2 + 16)
    self:addChild(menu)

    self:setupTestMenu()
end

function MainScene:setupTestMenu()
    cc.MenuItemFont:setFontName("sans")

    sdkbox.PluginFacebook:init()
    sdkbox.PluginFacebook:setListener(function(args)
        if "onLogin" == args.name then
            local isLogin = args.isLogin;
            local msg = args.msg;
            if isLogin then
                cc.log("login successful")
            else
                cc.log("login failed")
            end
            cc.log(msg)
        elseif "onPermission" ==  args.name then
            local isLogin = args.isLogin;
            local msg = args.msg;
            if isLogin then
                cc.log("request permission successful")
            else
                cc.log("request permission failed")
            end
            cc.log(msg)
        elseif "onAPI" ==  args.name then
            local tag = args.tag;
            local jsonData = args.jsonData;
            cc.log("============")
            cc.log(tag)
            cc.log(jsonData)
        elseif "onSharedSuccess" ==  args.name then
            local msg = args.message
            cc.log("share successful")
            cc.log(msg)
        elseif "onSharedFailed" ==  args.name then
            local msg = args.message
            cc.log("share failed")
            cc.log(msg)
        elseif "onSharedCancel" ==  args.name then
            cc.log("share canceled")
        end
    end)

    local btnLogin = cc.MenuItemFont:create("Login")
    btnLogin:onClicked(function()
        print("sdkbox.PluginFacebook:login()")
        sdkbox.PluginFacebook:login()
    end)

    local btnLogout = cc.MenuItemFont:create("Logout"):onClicked(function()
        sdkbox.PluginFacebook:logout()
    end)

    local btnCheck = cc.MenuItemFont:create("Check"):onClicked(function()
        cc.log("==============")
        cc.log("isLogin: " .. sdkbox.PluginFacebook:isLoggedIn())
        cc.log("userid: " .. sdkbox.PluginFacebook:getUserID())
        cc.log("permissions: ")
        local perms = sdkbox.PluginFacebook:getPermissionList()
        for _, perm in ipairs(perms) do
            cc.log("===> " .. perm)
        end
        cc.log("==============")
    end)

    local btnReadPerm = cc.MenuItemFont:create("Read Perm"):onClicked(function()
        sdkbox.PluginFacebook:requestReadPermissions({"public_profile", "email"})
    end)

    local btnWritePerm = cc.MenuItemFont:create("Write Perm"):onClicked(function()
        sdkbox.PluginFacebook:requestPublishPermissions({"publish_actions"})
    end)

    local btnShareLink = cc.MenuItemFont:create("Share Link"):onClicked(function()
        local info = {}
        info.type    = "link"
        info.link    = "http://www.cocos2d-x.org"
        info.title = "cocos2d-x"
        info.text    = "Best Game Engine"
        info.image = "http://cocos2d-x.org/images/logo.png"
        sdkbox.PluginFacebook:share(info)
    end)

    local btnDialogLink = cc.MenuItemFont:create("Dialog Link"):onClicked(function()
        local info = {}
        info.type    = "link"
        info.link    = "http://www.cocos2d-x.org"
        info.title = "cocos2d-x"
        info.text    = "Best Game Engine"
        info.image = "http://cocos2d-x.org/images/logo.png"
        sdkbox.PluginFacebook:dialog(info)
    end)

    local btnInvite = cc.MenuItemFont:create("Invite"):onClicked(function ()
        sdkbox.PluginFacebook:inviteFriends(
            "https://fb.me/322164761287181",
            "http://www.cocos2d-x.org/attachments/801/cocos2dx_portrait.png")
    end)

    local menu = cc.Menu:create(btnLogin, btnLogout, btnCheck, btnReadPerm, btnWritePerm, btnShareLink, btnDialogLink, btnInvite)
    menu:alignItemsVerticallyWithPadding(5)
    self:addChild(menu)
end

return MainScene

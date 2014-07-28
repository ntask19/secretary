local user = {}



local function listener(group)
	local func = {}
	local data = {}
	local color = {90, 90, 90}
	local uid = nil


	local page = display.newGroup()
	local pageBg = display.newGroup()
	local underGroup = display.newGroup()
	local usernaem, alias, platform, login_num, downloadDate, header, underBar

	local card1,cardNum1
	local card2,cardNum2
	local card3,cardNum3
	local card4,cardNum4
	local card5,cardNum5
	local card6,cardNum6
	local card7,cardNum7
	local card8,cardNum8
	local card9,cardNum9
	local card10,cardNum10
	local card11,cardNum11
	local card12,cardNum12
	local card13,cardNum13
	local card14,cardNum14
	local card15,cardNum15
	local card16,cardNum16
	local card17,cardNum17
	local card18,cardNum18
	local card19,cardNum19
	local cardFollow, cardNumFollow
	local cardFollower, cardNumFollower
	local cardSNS, cardNumSNS
	local cardTW, cardNumTW
	local cardFB, cardNumFB
	local cardLINE, cardNumLINE

	-- idの設定
	function func.setId(id)
		uid = id
	end


	-- データの取得
	function func.getData()

		local url = 'http://app.talkspace-web.com/admin/api/get_user_data.php'
		local function listener(event)
			if event.isError then 
			else
				print(event.response)
				data = json.decode( event.response )
				if data then
					func.setData()
				end
			end
		end

		local multipart = MultipartFormData.new()
		local params = {}
		
		multipart:addField("uid",uid)

		params.body = multipart:getBody() -- Must call getBody() first!
		local contentLength = string.len(params.body)
		local headers = multipart:getHeaders()
		headers["Content-Length"] = contentLength
		headers["User-Agent"] = userAgent
		params.headers = headers -- Headers not valid until getBody() is called. 
		network.request(url, "POST", listener,params)		
	end	

	-- データをセットする
	function func.setData()
		local userinfo = data.user_info
		local share_data = data.share_data
		local os_data = data.openspace_data
		local cs_data = data.closepsace_data
		local tl_data = data.timeline_data

		checkDownload(userinfo.userbackground_url, 
			function()
				header = display.newImage(basename(userinfo.userbackground_url), system.TemporaryDirectory, 0, 0)
				pageBg:insert(header)

				underBar = display.newRect(pageBg, 0, 0, _W, 550)
				underBar:setFillColor( 0, 90 )
			end
		)

		local largePic = string.gsub(userinfo.userimage_url, "-normal.png", "-large.png")
		
		checkDownload(largePic, 
			function()
				local userimage_group = display.newGroup()
				local userimage = display.newImage(userimage_group, basename(largePic), system.TemporaryDirectory, 0, 0)
				userimage:scale(180/userimage.width, 180/userimage.width)

				--画像を円形にするためのマスクファイル
				local mask = graphics.newMask("images/mask_circle.png")
				userimage_group:setMask( mask )
				userimage_group.maskScaleX = 1.8
				userimage_group.maskScaleY = 1.8				
				userimage_group.maskX = userimage.x
				userimage_group.maskY = userimage.y
				userimage_group.x = -220; userimage_group.y = -320; 	

				underGroup:insert(userimage_group)	
			end
		)

		username.text = userinfo.username
		alias.text = "@"..userinfo.alias
		login_num.text = "login : "..userinfo.loginNum
		downloadDate.text = userinfo.downloadDate
		platform.text = userinfo.platform
		
		cardNumFollow(userinfo.follow_num)
		cardNumFollower(userinfo.follower_num)

		local connectText = ""
		if userinfo.fb_connected == 1 then
			connectText = "fb : 済 / "
		else
			connectText = "fb : 未 / "
		end
		if userinfo.twitter_connected == 1 then
			connectText = connectText .. "tw : 済"
		else
			connectText = connectText .. "tw : 未"
		end		
		cardNumSNS(connectText)

		username:setReferencePoint( display.TopLeftReferencePoint )
		username.x = 200		

		alias:setReferencePoint( display.TopLeftReferencePoint )
		alias.x = 200

		--データ挿入
		local os_num = 0
		for k, v in pairs(os_data) do
			os_num = os_num + v.count
			if tonumber(v.type) == 0 then
				cardNum4(v.count)
			elseif tonumber(v.type) == 1 then
				cardNum5(v.count)
			elseif tonumber(v.type) == 2 then
				cardNum6(v.count)
			elseif tonumber(v.type) == 3 then
				cardNum7(v.count)
			end
		end
		cardNum1(os_num)

		--データ挿入
		local cs_num = 0
		for k, v in pairs(cs_data) do
			cs_num = cs_num + v.count
			if tonumber(v.type) == 0 then
				cardNum9(v.count)
			elseif tonumber(v.type) == 1 then
				cardNum10(v.count)
			elseif tonumber(v.type) == 2 then
				cardNum11(v.count)
			elseif tonumber(v.type) == 3 then
				cardNum12(v.count)
			elseif tonumber(v.type) == 4 then
				cardNum13(v.count)				
			end			
		end
		cardNum2(cs_num)

		--データ挿入
		local tl_num = 0
		for k, v in pairs(tl_data) do
			tl_num = tl_num + v.count
			if tonumber(v.type) == 0 then
				cardNum14(v.count)
			elseif tonumber(v.type) == 1 then
				cardNum15(v.count)
			elseif tonumber(v.type) == 2 then
				cardNum16(v.count)
			elseif tonumber(v.type) == 3 then
				cardNum17(v.count)
			elseif tonumber(v.type) == 4 then
				cardNum18(v.count)				
			elseif tonumber(v.type) == 5 then
				cardNum19(v.count)								
			end					
		end
		cardNum3(tl_num)	

		for k, v in pairs(share_data)do
			if v.type == 'facebook' then
				cardNumTW(v.count)
			elseif v.type == 'twitter' then
				cardNumFB(v.count)
			elseif v.type == 'line' then
				cardNumLINE(v.count)
			end
		end	

	end

	-- 画面表示
	function func.newPage()
		func.getData()

		local bg = display.newRect(page, 0, 0, _W, _H)
		colorPalette('grey', bg)

		page:insert(pageBg)

		local detailCloseBtn = display.newText(page, "close", 20, 0, _family, 40)
		detailCloseBtn:addEventListener( "tap", closePage )
		detailCloseBtn.y = 80


		--スクロール
		scrollView = widget.newScrollView({
		    top = 550,
		    height = _H-550,
		    width = _W,
		    scrollHeight = _H-550,
		    scrollWidth = _W,
		    listener = scrollViewListener,
		    hideBackground = true,
		    hideScrollBar = true,
		    horizontalScrollDisabled = true 
		})

		page:insert(scrollView)
		scrollView:insert(underGroup)

		function setPosition()
			local xPos, yPos = scrollView:getContentPosition()
			print(yPos)
			if yPos < 0 then
				pageBg.y = yPos*0.5
			else
				if header then
					header:scale((550+yPos)/pageBg.height, (550+yPos)/pageBg.height)
					pageBg.y = yPos*0.5

					underBar.height = (550+yPos)
				end
			end
		end
		Runtime:addEventListener( "enterFrame", setPosition )


		underGroup.y = 0

		local underBg = display.newRect(underGroup, 0, 0, _W, _H*3)

		username = display.newText(underGroup, "username", 230, -58, _family, 36)

		alias = display.newText(underGroup, "@alias", 200, 20, _family, 28)
		alias:setFillColor(60)

		platform = display.newText(underGroup, "platform", 450, 20, _family, 28)
		platform:setFillColor(60)

		login_num = display.newText(underGroup, "login_num", 200, 60, _family, 28)
		login_num:setFillColor(60)

		downloadDate = display.newText(underGroup, "downloadDate", 380, 60, _family, 28)
		downloadDate:setFillColor(60)	

		-- OS
		 objY = 120
		 card1, cardNum1 = createCard({num='45', title="openspace", width=(_W-40)/3, color=colorPalette(), mainFrame=mainContentGroup})
		 card1.x = 10; card1.y = objY
		 underGroup:insert(card1)

		-- CS
		card2, cardNum2 = createCard({num='44', title="closespace", width=(_W-40)/3, color=colorPalette(), mainFrame=mainContentGroup})
		card2.x = (_W-40)/3 + 20; card2.y = objY
		underGroup:insert(card2)

		-- TL
		card3, cardNum3 = createCard({num='64', title="timeline", width=(_W-40)/3, color=colorPalette(), mainFrame=mainContentGroup})
		card3.x = (_W-40)*2/3 + 30; card3.y = objY
		underGroup:insert(card3)

		objY = objY + card1.height + 10

		-- フォロー数
		cardFollow, cardNumFollow = createCard({num='0', title="フォロー数", width=(_W-30)*0.5, color=colorPalette('orange'), mainFrame=mainContentGroup})
		cardFollow.x = 10; cardFollow.y = objY
		underGroup:insert(cardFollow)

		-- フォロワー数
		cardFollower, cardNumFollower = createCard({num='0', title="フォロワー数", width=(_W-30)*0.5, color=colorPalette(), mainFrame=mainContentGroup})
		cardFollower.x = (_W-30)*0.5 + 20; cardFollower.y = objY
		underGroup:insert(cardFollower)		

		objY = objY + cardFollower.height + 10

		-- 連携
		cardSNS, cardNumSNS = createCard({num='0', title="連携　twitter / facebook", width=_W-20, color=colorPalette('green'), mainFrame=mainContentGroup})
		cardSNS.x = 10; cardSNS.y = objY
		underGroup:insert(cardSNS)

		objY = objY + cardSNS.height + 10

		-- フォロワー数
		cardTW, cardNumTW = createCard({num='0', title="twシェア数", width=(_W-40)/3, color=colorPalette(), mainFrame=mainContentGroup})
		cardTW.x = 10; cardTW.y = objY
		underGroup:insert(cardTW)	

		cardFB, cardNumFB = createCard({num='0', title="fbシェア数", width=(_W-40)/3, color=colorPalette(), mainFrame=mainContentGroup})
		cardFB.x = (_W-40)/3 + 20; cardFB.y = objY
		underGroup:insert(cardFB)	

		cardLINE, cardNumLINE = createCard({num='0', title="LINEシェア数", width=(_W-40)/3, color=colorPalette(), mainFrame=mainContentGroup})
		cardLINE.x = (_W-40)*2/3 + 30; cardLINE.y = objY
		underGroup:insert(cardLINE)					

		-- openspcae
		objY = objY + card1.height + 20
		local openspace_title = display.newText(underGroup, "openspcae", 20, objY, _family, 30)
		openspace_title:setFillColor( 90 )

		objY = objY + openspace_title.height + 10

		card4, cardNum4 = createCard({num='0', title="音声投稿", width=(_W-30)*0.5, height = 130, color=colorPalette('white'),font_color=colorPalette('grey') , mainFrame=mainContentGroup})
		card4.x = 10; card4.y = objY
		underGroup:insert(card4)

		-- CS
		card5, cardNum5 = createCard({num='0', title="スタンプ投稿", width=(_W-30)*0.5, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card5.x = (_W-30)*0.5+20; card5.y = objY
		underGroup:insert(card5)

		objY = objY + card5.height + 10

		-- TL
		card6, cardNum6 = createCard({num='0', title="写真投稿", width=(_W-30)*0.5, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card6.x = 10; card6.y = objY
		underGroup:insert(card6)

		card7, cardNum7 = createCard({num='0', title="写真＋音投稿", width=(_W-30)*0.5, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card7.x = (_W-30)*0.5+20; card7.y = objY
		underGroup:insert(card7)


		-- closespace
		objY = objY + card7.height + 20
		local closespace_title = display.newText(underGroup, "closespace", 20, objY, _family, 30)
		closespace_title:setFillColor( 90 )

		objY = objY + closespace_title.height + 10

		card8, cardNum8 = createCard({num='0', title="音声投稿", width=(_W-30)*0.5, height = 130, color=colorPalette('white'),font_color=colorPalette('grey') , mainFrame=mainContentGroup})
		card8.x = 10; card8.y = objY
		underGroup:insert(card8)

		-- CS
		card9, cardNum9 = createCard({num='0', title="スタンプ投稿", width=(_W-30)*0.5, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card9.x = (_W-30)*0.5+20; card9.y = objY
		underGroup:insert(card9)

		objY = objY + card9.height + 10

		-- TL
		card10, cardNum10 = createCard({num='0', title="写真投稿", width=(_W-40)/3, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card10.x = 10; card10.y = objY
		underGroup:insert(card10)

		card11, cardNum11 = createCard({num='0', title="写真＋音投稿", width=(_W-40)/3, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card11.x = (_W-40)/3 + 20; card11.y = objY
		underGroup:insert(card11)

		card12, cardNum12 = createCard({num='0', title="スペース投稿", width=(_W-40)/3, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card12.x = (_W-40)* 2/3 + 30; card12.y = objY
		underGroup:insert(card12)


		-- closespace
		objY = objY + card12.height + 20
		local closespace_title = display.newText(underGroup, "timeline", 20, objY, _family, 30)
		closespace_title:setFillColor( 90 )

		objY = objY + closespace_title.height + 10

		card13, cardNum13 = createCard({num='0', title="音声投稿", width=(_W-40)/3, height = 130, color=colorPalette('white'),font_color=colorPalette('grey') , mainFrame=mainContentGroup})
		card13.x = 10; card13.y = objY
		underGroup:insert(card13)

		-- CS
		card14, cardNum14 = createCard({num='0', title="スタンプ投稿", width=(_W-40)/3, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card14.x = (_W-40)/3 + 20; card14.y = objY
		underGroup:insert(card14)

		-- TL
		card15, cardNum15 = createCard({num='0', title="写真投稿", width=(_W-40)/3, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card15.x = (_W-40)* 2/3 + 30; card15.y = objY
		underGroup:insert(card15)

		objY = objY + card15.height + 10

		card16, cardNum16 = createCard({num='0', title="写真＋音投稿", width=(_W-40)/3, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card16.x = 10; card16.y = objY
		underGroup:insert(card16)

		card17, cardNum17 = createCard({num='0', title="スペース投稿", width=(_W-40)/3, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card17.x = (_W-40)/3 + 20; card17.y = objY
		underGroup:insert(card17)

		card18, cardNum18 = createCard({num='0', title="リボイス", width=(_W-40)/3, height = 130, color=colorPalette('white'), font_color=colorPalette('grey') ,mainFrame=mainContentGroup})
		card18.x = (_W-40)* 2/3 + 30; card18.y = objY
		underGroup:insert(card18)

		objY = objY + card18.height + 10

		return page
	end

	function closePage()
		Runtime:removeEventListener( "enterFrame", setPosition )
		transition.to(page, {time=240, y=_H, transition=easing.isExpo, onComplete=
			function()
				display.remove(page)
				page = nil
			end
		})
	end

	return func
end


function user.new()
	local group = display.newGroup(math.random(40000, 42000))
	local func = listener(group)

	return group, func
end


return user
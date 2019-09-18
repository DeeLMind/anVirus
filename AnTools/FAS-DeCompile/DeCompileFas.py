import os

def mixor(datapl,mipl):
    for a in datapl:
        if len(mipl) < len(datapl)+1:
            mipl += mipl
    
    jiemapl = ""
    for b in range(len(datapl)):
        newpl = ord(datapl[b]) ^ ord(mipl[b]) ^ ord(mipl[b+1])
        jiemapl += chr(newpl)
    ret = jiemapl
    
    return ret


fr = open('acad.fas', 'rb')
data = fr.read()
fr.close()

headflag = 'FAS4-FILE ; Do not change it!'



aa = data.find(headflag)
if(aa == -1):
    print 'error in find FAS4'
    sleep(4)

data = data[aa-3 : ]
i1 = data.find('$')
tmp = data[34 : i1]
ee = tmp.find('\n')

tlst = tmp[ : ee]
dfg = int(tlst)
toupl = data[ : i1+1]

if(dfg != 1):
    ee1 = data[34 : i1]
    
    i1sta = i1+1
    de13 = ee1.find('\n')
    da0lst = ee1[ : de13]
    num = int(da0lst)
    i1end = i1sta + num

    i2 = i1end+1
    strdat0 = data[i1sta : i1end]
    tmpl = data[i2 : i2+50]

    i3 = i2 + tmpl.find('$') + 1;
    tmpl1 = data[i2+2 : i3]
    de32 = tmpl1.find(' ')
    da1lst = tmpl1[ : de32]
    num1 = int(da1lst)
    i3end = i3 + num1

    strdat1 = data[i3 : i3end]
    print i3
    keylen = ord(data[i3end])
    keyend = i3end + keylen + 1
    keylst = data[i3end+1 : keyend]

    lastlst = data[keyend : ]
    zjlst = data[i2-1 : i3]


##    nstrlst0 = mixor(strdat0, keylst)
    nstrlst1 = mixor(strdat1, keylst)

    fpl1 = toupl + strdat0 + zjlst + nstrlst1 + str(keylen) + keylst + lastlst

    fw = open('a11.fas', 'wb')
    fw.write(fpl1)
    fw.close()
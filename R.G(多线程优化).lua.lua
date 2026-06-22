


local zip = "/storage/emulated/0/Download/RunawaG文件/RunawaG配置文件.zip"

-- 主下载链接
--[[
https://cdn.jsdelivr.net/gh/zup-pos/changan@main/RunawaG配置文件.zip
https://raw.githubusercontent.com/zup-pos/changan/main/RunawaG配置文件.zip
]]
local url_main = "https://cdn.jsdelivr.net/gh/zup-pos/changan@main/RunawaG配置文件.zip"

-- 备用下载链接
local url_fallback = "https://raw.githubusercontent.com/zup-pos/changan/main/RunawaG配置文件.zip"

local expect_size = 2101744

file.mkdir("/storage/emulated/0/Download")
file.mkdir("/storage/emulated/0/Download/RunawaG文件")
file.mkdir("/storage/emulated/0/长安")
file.mkdir("/storage/emulated/0/长安/图片")
file.mkdir("/storage/emulated/0/长安/配置文件")
file.mkdir("/storage/emulated/0/长安/列表改模块")

local function get_android_version()
    if type(luajava) ~= "table" or not luajava.bindClass then return "安卓(未知版本)设备" end
    local success, sdk_int = pcall(function()
        local BuildVersion = luajava.bindClass("android.os.Build$VERSION")
        return BuildVersion.SDK_INT
    end)
    if success and sdk_int then
        local version_map = {
            [23]="6.0",[24]="7.0",[25]="7.1",[26]="8.0",[27]="8.1",
            [28]="9",[29]="10",[30]="11",[31]="12",[32]="12L",
            [33]="13",[34]="14",[35]="15",[36]="16",[37]="17"
        }
        return "安卓" .. (version_map[sdk_int] or tostring(sdk_int)) .. "设备"
    end
    return "安卓(未知版本)设备"
end

local version_tag = get_android_version()

local function check()
    local f = io.open(zip,"rb")
    if not f then return false end
    local ok = f:seek("end") == expect_size
    f:close()
    return ok
end

local function unzipWithJava(zipPath, targetDir)
    local success = pcall(function()
        local ZipFile = luajava.bindClass("java.util.zip.ZipFile")
        local File = luajava.bindClass("java.io.File")
        local FileOutputStream = luajava.bindClass("java.io.FileOutputStream")
        local buffer = luajava.newInstance("[B", 4096)
        local zipFile = ZipFile(File(zipPath))
        local entries = zipFile:entries()
        while entries:hasMoreElements() do
            local entry = entries:nextElement()
            local entryName = entry:getName()
            local outPath = targetDir .. "/" .. entryName
            if entry:isDirectory() then
                file.mkdir(outPath)
            else
                local parentDir = outPath:match("(.*/)")
                if parentDir then file.mkdir(parentDir) end
                local inStream = zipFile:getInputStream(entry)
                local outStream = FileOutputStream(outPath)
                local len
                while true do
                    len = inStream:read(buffer)
                    if len <= 0 then break end
                    outStream:write(buffer, 0, len)
                end
                outStream:close()
                inStream:close()
            end
        end
        zipFile:close()
    end)
    return success
end

local function unzipWithSystem(zipPath, targetDir)
    local cmd1 = string.format("unzip -o '%s' -d '%s' 2>/dev/null", zipPath, targetDir)
    local cmd2 = string.format("busybox unzip -o '%s' -d '%s' 2>/dev/null", zipPath, targetDir)
    local result = os.execute(cmd1)
    if result == 0 or result == true then
        return true
    end
    result = os.execute(cmd2)
    return result == 0 or result == true
end

-- 下载配置文件（主备切换）
if not check() then
    for i = 1, 3 do
        local download_url = (i == 1) and url_main or url_fallback
        local tip_msg = version_tag .. "\n" .. ((i == 1) and "主线路下载中" or "备用线路下载中")
        
        if luajava.download(download_url, zip, tip_msg) and check() then
            if i > 1 then
                gg.toast("已通过备用线路下载成功", false)
            end
            break
        end
        gg.sleep(2000)
    end
end

local unzip_target = "/storage/emulated/0/长安/"
local unzip_ok = false

if unzipWithJava(zip, unzip_target) then
    unzip_ok = true
else
    unzip_ok = unzipWithSystem(zip, unzip_target)
end

local function assertFunc(func)
return assert(func, '不支持该函数')
end

local function getRootExecCallback(func)
return function(...)
local args = table.pack(...)
local func = assertFunc(func)
local n = args.n + 1
args[n] = true
return func(table.unpack(args, 1, n))
end
end

local function staticArgClosure1(func, p1)
return function()
local func = assertFunc(func)
return func(p1)
end
end

gg.toast("获取配置成功")




-- ========== 文件日志函数 ==========
local logFile = "/storage/emulated/0/长安/配置文件/debug_log.txt"
local f = io.open(logFile, "w")
if f then f:close() end

function writeLog(msg)
    local f = io.open(logFile, "a")
    if f then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        f:write(string.format("[%s] %s\n", timestamp, msg))
        f:close()
    end
end

writeLog("=== 脚本启动 ===")




--全局函数
neicun = 4
jishi_yunxing = false
kaishi_shijian = nil
savedZhenlvAddr = nil
msfwqh=false
回拉值 = {[1] = 4.5}
fwsfdj=false
cssfdj=false
冻结拾取范围 = true
传送高度冻结=true
_Backup_Special = {}
_Backup_Shoot = nil
recordCount = 0
maxRecordCount = 3
suoditu = 0
yuandituName = "多人创造-试验场"
yuandituId = "scene/game_training_02/game_training_02.scn"
mubiaodituName = "新手教程-鹰驰(地雷共用此地图)"
mubiaodituId = "scene/challenge_cliff/challenge_cliff.scn"
suozitu = 0
yuanzituName = "休赛期主页"
yuanzituId = "scene/lobby_factory_019/lobby_factory_019.scn"
mubiaozituName = "库亚工业主页"
mubiaozituId = "scene/lobby_factory_020/lobby_factory_020.scn"
suomoxing = 0
yuanmoName = "纯色魔方"
yuanmoId = "101000"
mubiaomoName = "救援无人机"
mubiaomoId = "2003"
xuanzhejinchuomian = 0
jiqiangyuanname = "午夜派对-SI"
jiqiangyuanid = 100404020
jiqiangmubiaoName = "贪噬"
jiqiangmubiaoId = 100404004
suojiqianghuanfu = 0
haiwangdunyuanname = "战魂盾"
haiwangdunyuanid = 100702010
haiwangdunmubiaoName = "寒御"
haiwangdunmubiaoId = 100702026
suohaiwangdunhuanfu = 0
dalishenyuanname = "酒桶"
dalishenyuanid = 101001001
dalishenmubiaoName = "远征敕令"
dalishenmubiaoId = 101001004
suodalishenhuanfu = 0
chuanyunyuanname = "铁拳COVE-A"
chuanyunyuanid = 102062001
chuanyunmubiaoName = "双管杠杆炮"
chuanyunmubiaoId = 102062004
suochuanyunhuanfu = 0
paotaiyuanname = "捍卫者-SI"
paotaiyuanid = 101102020
paotaimubiaoName = "叮当圣诞"
paotaimubiaoId = 101102004
suopaotaihuanfu = 0
daoyuanname = "特斯拉的巨剑-SI"
daoyuanid = 100502020
daomubiaoName = "伐木小子"
daomubiaoId = 100502004
suodaohuanfu = 0
jiguangyuanname = "碧蓝使者-SI"
jiguangyuanid = 100414020
jiguangmubiaoName = "赎罪棱镜"
jiguangmubiaoId = 100414004
suojiguanghuanfu = 0
jiesuomubiaoName = "大力神-远征敕令"
jiesuomubiaopiId = 101001004
jujiyuanname = "穹弩-SI"
jujiyuanid = 100405020
jujimubiaoName = "高斯原理"
jujimubiaoId = 100405004
suojujihuanfu = 0
lioudanyuanname = "老派左轮-SI"
lioudanyuanid = 100410020
lioudanmubiaoName = "小丑"
lioudanmubiaoId = 100410004
suolioudanhuanfu = 0
chixingyuanname = "砰砰雪球"
chixingyuanid = 102063001
chixingmubiaoName = "鲜橙爆弹"
chixingmubiaoId = 102063002
suochixinghuanfu = 0
cibaoyuanname = "寂静之声-SI"
cibaoyuanid = 100411020
cibaomubiaoName = "微醺玫瑰"
cibaomubiaoId = 100411004
suocibaohuanfu = 0
zuantouyuanname = "以赛之剑"
zuantouyuanid = 100501006
zuantoumubiaoName = "果味甜心"
zuantoumubiaoId = 100501004
suozuantouhuanfu = 0
yuetengyuanname = "跃腾-SI"
yuetengyuanid = 100309020
yuetengmubiaoName = "青年军"
yuetengmubiaoId = 100309004
suoyuetenghuanfu = 0
intgaipifu = 0
suojiiesuohuanfu = 0
lingshipisavedItems = nil
jiqiangsave = nil
haiwangdunsave = nil
dalishensave = nil
chuanyunsave = nil
paotaisave = nil
daosave = nil
jiguangsave = nil
jujisave = nil
lioudansave = nil
chixingsave = nil
cibaosave = nil
zuantousave = nil
yuetengsave = nil
dashenzhilutexiaosave = nil
zidinyimokuaizenshang = nil
zidinyimokuaicuantou = nil
weaponOriginalData = {}
currentDamageLevel = 2
texiaoData = {}
gaiwenjianint = 0
gaiwenjianset = 2
openyouxiint = 0
openyouxires = 2
suojiqianghuanfure = 0
jiqiangyuannamere = "午夜派对-SI"
jiqiangyuanidre = 115020
jiqiangmubiaoNamere = "贪噬"
jiqiangmubiaoIdre = 115004
chuanyunyuannamere = "穿云原皮"
chuanyunyuanidre = 10201
chuanyunmubiaoNamere = "丧钟"
chuanyunmubiaoIdre = 1022006
suochuanyunhuanfure = 0
dalishenyuannamere = "酒桶"
dalishenyuanidre = 129001
dalishenmubiaoNamere = "大神之路"
dalishenmubiaoidre = 129011
suodalishenhuanfure = 0
fangkongpaoyuanNamere = "防空炮原皮"
fangkongpaoyuanidre = 10901
fangkongpaomubiaoNamere = "皓空铸御"
fangkongpaomubiaoidre = 1090102
suofangkongpaohuanfure = 0
savedTexiaoResults = nil









USE_VOICE = false

当前提示方式 = gg.diyToast

语音 = string.toMusic or 当前提示方式

function 提示(msg)

当前提示方式(msg)


if USE_VOICE and 语音 ~= 当前提示方式 then
语音(msg)
end
end

function 切换语音方式(enable)
USE_VOICE = enable
end

function 切换提示方式(useToast)
当前提示方式 = useToast and gg.toast or gg.diyToast
end


清理提示=gg.alert


function QC()
清理提示=提示
end

function QS()
清理提示=gg.alert
end


function 回拉值切换(useCustom)
    if useCustom then
        local result = gg.prompt(
            {'自定义范围 (当前: ' .. 回拉值[1] .. ')'}, 
            {[1]=tostring(回拉值[1])}
        )
        if result then
            local newValue = tonumber(result[1])
            if newValue then
                回拉值[1] = newValue
                提示("回拉值已设为: " .. newValue)
            else
                提示("输入无效，保持原值: " .. 回拉值[1])
            end
        end
    else
        回拉值[1] = 4.5
    end
end



function 是否冻结切换(useCustom)
    if useCustom then
fwsfdj=true
else
fwsfdj=false
end
end



function 冻结传送切换(useCustom)
    if useCustom then
cssfdj=true
else
cssfdj=false
end
end


function HA()
fw1=false
end


function HE()
fw1=false
end


fw1=false
function HK()
if fw1 then 
提示("检测到正在执行循环功能\n为防止卡顿\n正在尝试关闭循环功能后再执行功能")   
fw1=false
gg.sleep(3000)
end
end


function 拾取冻结(useToast)
    if useToast then
        冻结拾取范围 = false
    else
        冻结拾取范围 = true
    end

end





function 高度冻结方式(useToast)
    if useToast then
        高度冻结 = true
    else
        高度冻结 = false
    end
    传送高度冻结 = 高度冻结
end





DWORD = gg.TYPE_DWORD
DOUBLE = gg.TYPE_DOUBLE
FLOAT = gg.TYPE_FLOAT
WORD = gg.TYPE_WORD
BYTE = gg.TYPE_BYTE
XOR = gg.TYPE_XOR
QWORD = gg.TYPE_QWORD

D, E, F, W, B, X, Q = 4, 64, 16, 2, 1, 128, 8

gg.mr = 262207
gg.Jh = 2
gg.Ch = 1
gg.Ca = 4
gg.Cd = 8
gg.Cb = 16
gg.PS = 262144
gg.A = 32
gg.J = 65536
gg.S = 64
gg.As = 524288
gg.O = -1032320
gg.B = 131072
gg.Xa = 16384
gg.Xs = 32768

gg.setRanges(gg.mr)


sj = {}
last = nil
keep = false
hzwjrs = nil
_RangeBackup = {}
_VisionBase = nil
_VisionOrig = {}
VISION_MAX = 1000
lastRecord = {}
globalLastValues = {}
globalKeep = false



function qnmbd()
    gg.clearResults()
    gg.setRanges(neicun)
    gg.searchNumber("17039364", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    gg.searchNumber("17039364", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
end

function editData(qmnb, qmxg, customInput)
    gg.setVisible(false)
    gg.clearResults()
    customInput = customInput or false

    if not qmnb or not qmxg or #qmnb < 3 then
        提示("参数不完整")
        return false
    end

    local qmnbv = qmnb[3]["value"] or qmnb[3][1]
    local qmnbt = qmnb[3]["type"] or qmnb[3][2]
    local qmnbn = qmnb[2]["name"] or qmnb[2][1] or "未知"

    if not qmnbv or not qmnbt then
        提示("搜索值或类型为空")
        return false
    end

    local range = qmnb[1]["memory"] or qmnb[1][1] or gg.REGION_C_ALLOC
    gg.setRanges(range)
    gg.searchNumber(qmnbv, qmnbt)
    gg.refineNumber(qmnbv, qmnbt)

    local sz = gg.getResultCount()
    if sz == 0 then
        提示("搜索无结果：" .. qmnbn)
        return false
    end

    local sl = gg.getResults(999999)
    if not sl or #sl == 0 then
        提示("获取搜索结果失败")
        return false
    end

    local xgjg = false
    local modifyCount = 0
    local freezeCount = 0
    local unfreezeList = {}

    for i = 1, sz do
        if not sl[i] or not sl[i].address then goto continue end
        local pdsz = true

        for v = 4, #qmnb do
            if not pdsz or not qmnb[v] then pdsz = false; break end
            local offset = qmnb[v]["offset"] or qmnb[v][2] or 0
            local valueType = qmnb[v]["type"] or qmnb[v][3]
            local szpy = gg.getValues({{address = sl[i].address + offset, flags = valueType}})
            
            if not szpy or not szpy[1] then pdsz = false; break end
            local tzszpd = tostring(qmnb[v]["lv"] or qmnb[v][1] or ""):gsub(",", "")
            local pyszpd = tostring(szpy[1].value or ""):gsub(",", "")
            if tzszpd ~= pyszpd then pdsz = false; break end
        end

        if pdsz then
            local szpy = sl[i].address
            local editItems = {}

            for x = 1, #qmxg do
                if not qmxg[x] then break end
                local xgpy = szpy + (qmxg[x]["offset"] or qmxg[x][2] or 0)
                local xglx = qmxg[x]["type"] or qmxg[x][3]
                local xgdj = qmxg[x]["freeze"] or qmxg[x][4] or false
                local defaultValue = qmxg[x]["value"] or qmxg[x][1]
                local currentValues = gg.getValues({{address = xgpy, flags = xglx}})
                local currentValue = currentValues and currentValues[1] and currentValues[1].value or 0

                local displayValue = (globalKeep and globalLastValues[x]) or defaultValue or currentValue

                table.insert(editItems, {
                    address = xgpy, type = xglx, freeze = xgdj,
                    defaultValue = defaultValue, currentValue = currentValue,
                    displayValue = displayValue, index = x
                })
            end

            if #editItems > 0 then
                if customInput then
                    local promptItems, defaultInputs, inputTypes = {}, {}, {}
                    for idx, item in ipairs(editItems) do
                        local displayText = string.format("当前值: %s", tostring(item.currentValue))
                        if item.defaultValue ~= nil then
                            displayText = displayText .. string.format(" 推荐值: %s", tostring(item.defaultValue))
                        end
                        table.insert(promptItems, displayText)
                        table.insert(defaultInputs, tostring(item.displayValue))
                        table.insert(inputTypes, "number")
                    end
                    table.insert(promptItems, "记住修改值")
                    table.insert(defaultInputs, globalKeep)
                    table.insert(inputTypes, "checkbox")

                    local inputs = gg.prompt(promptItems, defaultInputs, inputTypes)
                    if not inputs or #inputs == 0 then 提示("已取消输入"); return false end
                    globalKeep = inputs[#inputs]

                    for idx, item in ipairs(editItems) do
                        local inputValue = inputs[idx]
                        if inputValue and inputValue ~= "" then
                            local finalValue = tonumber(inputValue) or item.defaultValue or item.currentValue
                            if finalValue then
                                if globalKeep then globalLastValues[item.index] = finalValue end
                                local xg = {{address = item.address, flags = item.type, value = finalValue, freeze = item.freeze}}
                                if item.freeze then
                                    gg.addListItems(xg); freezeCount = freezeCount + 1
                                else
                                    table.insert(unfreezeList, item.address)
                                    gg.setValues(xg); modifyCount = modifyCount + 1
                                end
                            end
                        end
                    end
                else
                    for idx, item in ipairs(editItems) do
                        if item.defaultValue ~= nil then
                            local xg = {{address = item.address, flags = item.type, value = item.defaultValue, freeze = item.freeze}}
                            if item.freeze then
                                gg.addListItems(xg); freezeCount = freezeCount + 1
                            else
                                table.insert(unfreezeList, item.address)
                                gg.setValues(xg); modifyCount = modifyCount + 1
                            end
                        end
                    end
                end
                xgjg = true
            end
        end
        ::continue::
    end

    if #unfreezeList > 0 then gg.removeListItems(unfreezeList) end
    if xgjg then
        if modifyCount > 0 then 提示(string.format("共修改 %d 个数据", modifyCount)) end
        if freezeCount > 0 then 提示(string.format("共冻结 %d 个数据", freezeCount)) end
        return true
    else
        提示("未找到匹配的数据")
        return false
    end
end

local function applyOffset(t, o)
    if type(sj) ~= "table" or #sj == 0 then return nil, "无数据" end
    local offset = tonumber(o) or 0
    local readTab = {}
    for i = 1, #sj do
        readTab[i] = {address = sj[i].address + offset, flags = t}
    end
    local vals = gg.getValues(readTab)
    if not vals or #vals == 0 then return nil, "读取失败" end
    return vals, vals[1].value
end

local function pyFilter(value, lx, py, eq)
    if type(sj) ~= "table" or #sj == 0 then
        提示("没有搜索数据")
        return
    end
    local offset = tonumber(py) or 0
    local len = #sj
    local readTab = {}
    for i = 1, len do
        readTab[i] = {address = sj[i].address + offset, flags = lx}
    end
    local vals = gg.getValues(readTab)
    if not vals or #vals == 0 then
        sj = {}
        提示("偏移读取失败，数据已失效")
        return
    end
    if #vals < len then
        sj = {}
        提示("部分地址不可读，数据已失效")
        return
    end

    local res = {}
    local idx = 0
    for i = 1, len do
        local v = vals[i]
        if v == nil then
            goto continue
        end
        local match = (v.value == value)
        if (eq and match) or (not eq and not match) then
            idx = idx + 1
            res[idx] = sj[i]
        end
        ::continue::
    end
    if idx == 0 then
        sj = {}
        提示("筛选后无数据，请重新搜索")
    else
        sj = res
        提示("共偏移 " .. idx .. " 个数据")
    end
end

function gs1(value, lx, signed)
    if type(sj) ~= "table" or #sj == 0 then
        提示("没有搜索结果")
        return false
    end
    signed = (signed == true)
    gg.refineNumber(value, lx, signed)
    local count = gg.getResultCount()
    if count > 0 then
        sj = gg.getResults(count)
        提示(string.format("精确筛选剩余 %d 条数据", count))
        return true
    else
        sj = {}
        提示("精确筛选无结果，已清空数据")
        return false
    end
end

local function internalModify(offset, flags, value, freeze)
    if type(sj) ~= "table" or #sj == 0 then
        提示("没有搜索数据")
        return false
    end
    local modifyList, addrList = {}, {}
    for i = 1, #sj do
        local addr = sj[i].address + offset
        addrList[i] = addr
        modifyList[i] = {address = addr, flags = flags, value = value, freeze = freeze}
    end
    if freeze then
        gg.addListItems(modifyList)
        提示(string.format("共冻结 %d 个数据→%s", #sj, tostring(value)))
    else
        gg.removeListItems(addrList)
        gg.setValues(modifyList)
        提示(string.format("共修改 %d 个数据→%s", #sj, tostring(value)))
    end
    return true
end

function search(ss, lx, nc, dz1, dz2, dz3)
    gg.clearResults()
    if ss == nil or lx == nil then return false end
    local range = nc
    if nc == nil or nc == 0 or nc == -1 then
        if gg.isRLGG then
            range = 0xFFFFFFFF
        else
            range = gg.REGION_ALL
        end
    end

    if range then
        gg.setRanges(range)
    end

    gg.searchNumber(ss, lx, false, gg.SIGN_EQUAL, dz1 or 0, dz2 or -1, dz3 or 0)

    local count = gg.getResultCount()
    if count > 0 then
        sj = gg.getResults(count)
        提示("搜索到 " .. count .. " 个结果")
        return true
    else
        sj = {}
        提示("未搜索到结果")
        return false
    end
end

function py1(value, lx, py)
    pyFilter(value, lx, py, true)
end

function xg1(value, lx, py, dj)
    local offset = tonumber(py) or 0
    local freeze = dj or false
    internalModify(offset, lx, value, freeze)
end

function xg3(rv, t, o, f, 优先_or_txt, txt_or_nil)
    if type(sj) ~= "table" or #sj == 0 then 提示("没有搜索数据"); return end
    local vals, cv = applyOffset(t, o)
    if not vals then 提示(cv); return end

    f = f or false
    local 优先模式 = (type(优先_or_txt) == "boolean") and 优先_or_txt or false
    local txt = (type(优先_or_txt) == "string") and 优先_or_txt or txt_or_nil
    local dv = (keep and last) or (优先模式 and (rv or cv)) or cv

    local pt = string.format("当前值:%s%s%s", tostring(cv), rv and (" | 推荐值:" .. tostring(rv)) or "", txt and (" " .. txt) or "")
    local i = gg.prompt({pt, "记住"}, {tostring(dv), keep}, {"number", "checkbox"})
    if not i then 提示("已取消"); return end

    local numValue = tonumber(i[1])
    if not numValue then 提示("输入错误,请使用有效数值格式"); return end
    keep, last = i[2], numValue

    if type(sj) ~= "table" or #sj == 0 then 提示("数据已失效，修改失败"); return end
    local offsetNum = tonumber(o) or 0
    internalModify(offsetNum, t, last, f)
end

function xg4(t, o, f, ...)
    if type(o) == "number" and type(f) == "number" then
        if last == nil then 提示("没有传入数值"); return end
        local flags = o
        local offset = f
        local freeze = (type(...) == "boolean") and ... or false
        internalModify(offset, flags, last, freeze)
    else
        提示("参数格式错误")
    end
end


local cachedRanges = nil
local function getRanges()
    if cachedRanges then return cachedRanges end
    local ranges = {}
    local t = gg.getRangesList('^/data/*.so*$')
    if not t then return ranges end
    for i = 1, #t do
        if t[i] and t[i].type and t[i].type:sub(2, 2) == 'w' then
            table.insert(ranges, t[i])
        end
    end
    cachedRanges = ranges
    return ranges
end


function S_Pointer(t_So, t_Offset, _bit)
    local function getRanges()
        local ranges = {}
        local t = gg.getRangesList('^/data/*.so*$')
        for i, v in pairs(t) do
            if v.type:sub(2, 2) == 'w' then
                table.insert(ranges, v)
            end
        end
        return ranges
    end
    
    local function Get_Address(N_So, Offset, ti_bit)
        local ti = gg.getTargetInfo()
        local S_list = getRanges()
        local t = {}
        local _t
        local _S = nil
        local modifiedCount = 0  -- Counter for modified data
        
        if ti_bit then
            _t = 32
        else
            _t = 4
        end
        
        for i in pairs(S_list) do
            local _N = S_list[i].internalName:gsub('^.*/', '')
            if N_So[1] == _N and N_So[2] == S_list[i].state then
                _S = S_list[i]
                break
            end
        end
        
        if _S then
            t[#t + 1] = {}
            t[#t].address = _S.start + Offset[1]
            t[#t].flags = _t
            modifiedCount = modifiedCount + 1
            
            if #Offset ~= 1 then
                for i = 2, #Offset do
                    local S = gg.getValues(t)
                    t = {}
                    for _ in pairs(S) do
                        if not ti.x64 then
                            S[_].value = S[_].value & 0xFFFFFFFF
                        end
                        t[#t + 1] = {}
                        t[#t].address = S[_].value + Offset[i]
                        t[#t].flags = _t
                        modifiedCount = modifiedCount + 1
                    end
                end
            end
            _S = t[#t].address
        end
        
        提示(string.format("共修改 %d 个数据", modifiedCount))  -- Show modification count
        return _S
    end
    
    local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
    return _A
end


function rssearch(ss, lx, nc, dz1, dz2, dz3)
    if not ss or not lx then return end
    gg.setRanges(nc or 32)
    gg.searchNumber(ss, lx, false, gg.SIGN_EQUAL, dz1 or 0, dz2 or -1, dz3 or 0)
    local count = gg.getResultCount()
    if count > 0 then
        sj = gg.getResults(count)
        gg.clearResults()
        提示("搜索到 " .. count .. " 个结果")
    else
        sj = {}
        提示("未搜索到结果")
    end
end

function rspy1(value, lx, py)
    if type(sj) ~= "table" or #sj == 0 then 提示("没有搜索数据"); return end
    local offset = tonumber(py) or 0
    local readList = {}
    for i = 1, #sj do
        readList[i] = { address = sj[i].address + offset, flags = lx }
    end
    local vals = gg.getValues(readList)
    local filtered = {}
    for i = 1, #sj do
        if vals[i] and vals[i].value == value then
            table.insert(filtered, sj[i])
        end
    end
    sj = filtered
    提示("共偏移 " .. #sj .. " 个数据")
end

function rsxg1(value, lx, py, dj)
    if type(sj) ~= "table" or #sj == 0 then 提示("没有搜索数据"); return end
    local offset = tonumber(py) or 0
    local freeze = (dj == true)
    local modifyList, addrList = {}, {}
    for i = 1, #sj do
        local addr = sj[i].address + offset
        addrList[i] = addr
        modifyList[i] = {address = addr, flags = lx, value = value, freeze = freeze}
    end
    if freeze then
        gg.addListItems(modifyList)
    else
        if #addrList > 0 then gg.removeListItems(addrList) end
        gg.setValues(modifyList)
    end
    提示("渲染范围内有" .. #sj .. "人(除自己)")
end

function rsxg2(value, lx, py, dj)
    if type(sj) ~= "table" or #sj == 0 then
        if hzwjrs then draw.updateText(hzwjrs, '共找到玩家0个') end
        return
    end
    local offset = tonumber(py) or 0
    local freeze = (dj == true)
    local modifyList, addrList = {}, {}
    for i = 1, #sj do
        local addr = sj[i].address + offset
        addrList[i] = addr
        modifyList[i] = {address = addr, flags = lx, value = value, freeze = freeze}
    end
    if freeze then
        gg.addListItems(modifyList)
    else
        if #addrList > 0 then gg.removeListItems(addrList) end
        gg.setValues(modifyList)
    end
    if hzwjrs then draw.updateText(hzwjrs, '共找到玩家' .. #sj .. '个') end
end

function xqmnb(Search, Modification)
    gg.clearResults()
    gg.setRanges(Search[1].memory)
    gg.searchNumber(Search[3].value, Search[3].type, false, 536870912, 0, -1)
    if gg.getResultCount() == 0 then 提示(Search[2].name .. '开启失败'); return end
    
    local results = gg.getResults(gg.getResultCount())
    local unusable = {}
    local readTasks, taskInfo = {}, {}
    
    for idx = 1, #results do
        for offIdx = 4, #Search do
            table.insert(readTasks, { address = results[idx].address + Search[offIdx].offset, flags = Search[offIdx].type })
            table.insert(taskInfo, { resIdx = idx, offIdx = offIdx })
        end
    end
    
    local readValues = gg.getValues(readTasks)
    for i, val in ipairs(readValues) do
        if val.value ~= Search[taskInfo[i].offIdx].lv then
            unusable[taskInfo[i].resIdx] = true
        end
    end
    
    local hasValid = false
    for i = 1, #results do
        if not unusable[i] then hasValid = true; break end
    end
    if not hasValid then 提示(Search[2].name .. '开启失败'); return end
    
    local addrFinalState = {}
    local modifyCount, freezeCount = 0, 0
    
    for _, mod in ipairs(Modification) do
        for i = 1, #results do
            if not unusable[i] then
                local addr = results[i].address + mod.offset
                addrFinalState[addr] = { address = addr, flags = mod.type, value = mod.value, freeze = mod.freeze or false }
            end
        end
    end
    
    local modifyList, freezeList, unfreezeList = {}, {}, {}
    for addr, state in pairs(addrFinalState) do
        if state.freeze then
            table.insert(freezeList, state)
            freezeCount = freezeCount + 1
        else
            table.insert(unfreezeList, addr)
            table.insert(modifyList, state)
            modifyCount = modifyCount + 1
        end
    end

    if #unfreezeList > 0 then gg.removeListItems(unfreezeList) end
    if #modifyList > 0 then gg.setValues(modifyList) end
    if #freezeList > 0 then gg.addListItems(freezeList) end
    
    if modifyCount > 0 then 提示(Search[2].name .. '开启成功，共修改' .. modifyCount .. '个数据') end
    if freezeCount > 0 then 提示(Search[2].name .. '开启成功，共冻结' .. freezeCount .. '个数据') end
    gg.clearResults()
end

function xqmnb2(Search, Modification, mode)
    mode = mode or "open"
    local name = Search[2].name
    local memory = Search[1].memory

    if mode == "open" then
        gg.clearResults()
        gg.setRanges(memory)
        gg.searchNumber(Search[3].value, Search[3].type, false, 536870912, 0, -1)
        if gg.getResultCount() == 0 then 提示(name .. '开启失败：未找到特征值'); return false end
        
        local results = gg.getResults(gg.getResultCount())
        local unusable = {}
        local readTasks, taskInfo = {}, {}
        
        for idx = 1, #results do
            for offIdx = 4, #Search do
                table.insert(readTasks, { address = results[idx].address + Search[offIdx].offset, flags = Search[offIdx].type })
                table.insert(taskInfo, { resIdx = idx, offIdx = offIdx })
            end
        end
        
        local readValues = gg.getValues(readTasks)
        for i, val in ipairs(readValues) do
            if val.value ~= Search[taskInfo[i].offIdx].lv then unusable[taskInfo[i].resIdx] = true end
        end
        
        local hasValid = false
        for i = 1, #results do
            if not unusable[i] then hasValid = true; break end
        end
        if not hasValid then 提示(name .. '开启失败：条件不匹配'); return false end

        local backup, addrFinalState = {}, {}
        local modifyCount, freezeCount = 0, 0
        
        for _, mod in ipairs(Modification) do
            for i = 1, #results do
                if not unusable[i] then
                    local addr = results[i].address + mod.offset
                    local key = string.format("%s_%d", addr, mod.offset)
                    if not backup[key] then
                        local origVal = gg.getValues({{address = addr, flags = mod.type}})[1].value
                        backup[key] = { address = addr, value = origVal, flags = mod.type, offset = mod.offset }
                    end
                    addrFinalState[key] = { address = addr, flags = mod.type, value = mod.value, freeze = mod.freeze or false }
                end
            end
        end
        
        _RangeBackup[name] = backup
        
        local modifyList, freezeList, unfreezeList = {}, {}, {}
        for key, state in pairs(addrFinalState) do
            if state.freeze then
                table.insert(freezeList, state)
                freezeCount = freezeCount + 1
            else
                table.insert(unfreezeList, state.address)
                table.insert(modifyList, state)
                modifyCount = modifyCount + 1
            end
        end
        
        if #unfreezeList > 0 then gg.removeListItems(unfreezeList) end
        if #modifyList > 0 then gg.setValues(modifyList) end
        if #freezeList > 0 then gg.addListItems(freezeList) end
        
        if modifyCount > 0 then 提示(name .. '开启成功，共修改' .. modifyCount .. '个数据') end
        if freezeCount > 0 then 提示(name .. '开启成功，共冻结' .. freezeCount .. '个数据') end
        gg.clearResults()
        return true
        
    elseif mode == "close" then
        local backup = _RangeBackup[name]
        if backup and next(backup) then
            local restoreList, unfreezeList = {}, {}
            for key, info in pairs(backup) do
                table.insert(restoreList, { address = info.address, flags = info.flags, value = info.value, freeze = false })
                table.insert(unfreezeList, info.address)
            end
            if #restoreList > 0 then
                gg.removeListItems(unfreezeList)
                gg.setValues(restoreList)
                提示(name .. '已关闭，共恢复' .. #restoreList .. '个数据')
                _RangeBackup[name] = nil
                return true
            end
        end

        gg.clearResults()
        gg.setRanges(memory)
        gg.searchNumber(Search[3].value, Search[3].type, false, 536870912, 0, -1)
        if gg.getResultCount() == 0 then 提示(name .. '关闭失败：无法定位地址'); return false end
        
        local results = gg.getResults(gg.getResultCount())
        local restoreList, unfreezeList = {}, {}
        for _, mod in ipairs(Modification) do
            for i = 1, #results do
                local addr = results[i].address + mod.offset
                table.insert(restoreList, { address = addr, flags = mod.type, value = mod.value, freeze = false })
                table.insert(unfreezeList, addr)
            end
        end
        if #restoreList > 0 then
            gg.removeListItems(unfreezeList)
            gg.setValues(restoreList)
            提示(name .. '已关闭，共恢复' .. #restoreList .. '个数据')
        else
            提示(name .. '关闭失败：无数据可恢复')
        end
        gg.clearResults()
        _RangeBackup[name] = nil
        return true
    end
end

function InitVisionCache()
    search("-1.2566370964050293", 16, neicun)
    if not (sj and #sj > 0) then return false end

    local total = #sj
    if total > VISION_MAX then total = VISION_MAX end

    _VisionBase = {}
    for i = 1, total do _VisionBase[i] = sj[i].address end

    for _, off in ipairs({-140, -92, -40}) do
        _VisionOrig[off] = {}
        local readBatch = {}
        for i = 1, total do readBatch[i] = {address = _VisionBase[i] + off, flags = 16} end
        local vals = gg.getValues(readBatch)
        for i = 1, total do _VisionOrig[off][i] = vals[i].value end
    end
    return true
end

function EnsureVisionCache()
    if _VisionBase and #_VisionBase > 0 then
        local check = gg.getValues({{address = _VisionBase[1], flags = 16}})
        if check and check[1] then return true end
        _VisionBase, _VisionOrig = nil, {}
    end
    return InitVisionCache()
end

function SetSjWithOffset(offset)
    if not EnsureVisionCache() then return false end
    sj = {}
    for i = 1, #_VisionBase do
        sj[i] = {address = _VisionBase[i] + offset, flags = 16}
    end
    return true
end

local function clearLastRecord()
    lastRecord = {}
    提示('正在初始化')
end

function startRecording()
    gg.clearResults()
    search(17039364, 4, neicun)
    py1(16777215, 4, -36)
    py1(257, 4, -32)
    
    if #sj == 0 then 提示("初始化未匹配到有效坐标特征"); return end

    local batchTasks = {}
    for i = 1, #sj do
        local base = sj[i].address
        table.insert(batchTasks, {address = base - 4, flags = 16})   -- X
        table.insert(batchTasks, {address = base - 8, flags = 16})   -- Y
        table.insert(batchTasks, {address = base - 12, flags = 16})  -- Z
    end
    
    local res = gg.getValues(batchTasks)
    if res and res[1] then
        提示('初始化完成')
        lastRecord = {
            name = tostring(#sj + 1),
            x = res[1].value,
            y = res[2].value,
            z = res[3].value
        }
    else
        提示('读取录制数据失败')
    end
end


-- 公共记录函数
local function 公共记录()
    gg.clearResults()
    search(17039364, 4, neicun)
    py1(16777215, 4, -36)
    py1(257, 4, -32)
    
    local x, y, z = {}, {}, {}
    for i = 1, #sj do
        x[i] = {address = sj[i].address - 4, flags = 16}
        y[i] = {address = sj[i].address - 8, flags = 16}
        z[i] = {address = sj[i].address - 12, flags = 16}
    end
    
    local v = gg.getValues
    return {
        x = v(x)[1].value,
        y = v(y)[1].value,
        z = v(z)[1].value
    }
end

-- 创建目录
file.mkdir("/sdcard/长安/存储记录坐标点")

-- 存储点操作
local function 存储点操作(操作, 索引, 数据)
    local 路径 = string.format("/sdcard/长安/存储记录坐标点/点%d.dat", 索引)
    if 操作 == "保存" then
        local f = io.open(路径, "w")
        if f then
            f:write(base64.encode(json.encode(数据)))
            f:close()
            return true
        end
    elseif 操作 == "读取" and file.exists(路径) then
        return json.decode(base64.decode(file.read(路径)))
    end
    return nil
end

-- 记录功能
local function 记录(索引)
    if 索引 < 1 or 索引 > 30 then return end
    
    local 点 = {
        名称 = "点"..索引,
        坐标 = 公共记录(),
        记录次数 = 1
    }
    
    if 存储点操作("保存", 索引, 点) then
        提示(点.名称.."记录完成", true)
    else
        提示("记录失败")
    end
end

-- 传送功能
local function 传送(索引)
    if 索引 < 1 or 索引 > 30 then return end
    
    local 点 = 存储点操作("读取", 索引)
    if not 点 then
        提示("点"..索引.."无数据", true)
        return
    end
    
    xg1(点.坐标.x, 16, -4, cssfdj)
    xg1(点.坐标.y, 16, -8, cssfdj)
    xg1(点.坐标.z, 16, -12, cssfdj)
    
    提示("已传送到"..点.名称)
end



_AutoPullBack = _AutoPullBack or {
    running = false,
    thread = nil,
    stopFlag = false,
    baseAddr = nil,
    threshold = 50000,
    checkInterval = 200,
    freezeDuration = 2000,
    freezeOnPull = true
}

function getSelfBase()
    gg.clearResults()
    search(17039364, 4, neicun)
    py1(16777215, 4, -36)
    py1(257, 4, -32)
    if #sj == 0 then return nil end
    return sj[1].address
end

function getCoords(base)
    local tasks = {
        {address = base - 4, flags = 16},
        {address = base - 8, flags = 16},
        {address = base - 12, flags = 16}
    }
    local res = gg.getValues(tasks)
    if res and #res >= 3 then
        local x = res[1] and res[1].value
        local y = res[2] and res[2].value
        local z = res[3] and res[3].value
        if x ~= nil and y ~= nil and z ~= nil then
            return x, y, z
        end
    end
    return nil, nil, nil
end

function setAndFreeze(base, x, y, z)
    local addrs = {base - 4, base - 8, base - 12}
    local values = {
        {address = addrs[1], flags = 16, value = x},
        {address = addrs[2], flags = 16, value = y},
        {address = addrs[3], flags = 16, value = z}
    }
    gg.setValues(values)
    if _AutoPullBack.freezeOnPull then
        gg.addListItems({
            {address = addrs[1], flags = 16, value = x, freeze = true},
            {address = addrs[2], flags = 16, value = y, freeze = true},
            {address = addrs[3], flags = 16, value = z, freeze = true}
        })
    end
end

function unfreeze(base)
    if _AutoPullBack.freezeOnPull then
        gg.removeListItems({base - 4, base - 8, base - 12})
    end
end

function autoPullBackLoop()
    local base = _AutoPullBack.baseAddr
    if not base then
        提示("基址无效")
        _AutoPullBack.running = false
        return
    end

    local prevX, prevY, prevZ = getCoords(base)
    if not prevX then
        提示("无法读取初始坐标")
        _AutoPullBack.running = false
        return
    end

    while not _AutoPullBack.stopFlag do
        local curX, curY, curZ = getCoords(base)
        local isValid = true
        if curX == nil or curY == nil or curZ == nil then
            isValid = false
        elseif curX ~= curX or curY ~= curY or curZ ~= curZ then
            isValid = false
        elseif math.abs(curX) > 1e9 or math.abs(curY) > 1e9 or math.abs(curZ) > 1e9 then
            isValid = false
        end

        if not isValid then
            local targetX = prevX
            local targetY = prevY
            local targetZ = prevZ
            setAndFreeze(base, targetX, targetY, targetZ)
            if _AutoPullBack.freezeOnPull then
                提示("检测到坐标数值异常！已回拉至上一次有效位置并冻结")
                gg.sleep(_AutoPullBack.freezeDuration)
                unfreeze(base)
                提示("解冻，继续")
            else
                提示("检测到坐标数值异常！已回拉至上一次有效位置")
            end
            local newX, newY, newZ = getCoords(base)
            if newX == nil or newY == nil or newZ == nil then
                提示("回拉后读取坐标失败，停止回拉")
                break
            end
            local validAfter = true
            if newX ~= newX or newY ~= newY or newZ ~= newZ then
                validAfter = false
            elseif math.abs(newX) > 1e9 or math.abs(newY) > 1e9 or math.abs(newZ) > 1e9 then
                validAfter = false
            end
            if not validAfter then
                提示("回拉后坐标仍然异常，停止回拉，请手动处理")
                break
            end
            prevX, prevY, prevZ = newX, newY, newZ
        else
            local dx = curX - prevX
            local dy = curY - prevY
            local dz = curZ - prevZ
            local dist = math.sqrt(dx*dx + dy*dy + dz*dz)

            if dist > _AutoPullBack.threshold then
                local targetX = prevX
                local targetY = prevY
                local targetZ = prevZ
                setAndFreeze(base, targetX, targetY, targetZ)
                if _AutoPullBack.freezeOnPull then
                    提示(string.format("回拉至 (%.0f, %.0f, %.0f) 冻结 %.1fs", targetX, targetY, targetZ, _AutoPullBack.freezeDuration/1000))
                    gg.sleep(_AutoPullBack.freezeDuration)
                    unfreeze(base)
                    提示("解冻，继续")
                else
                    提示(string.format("回拉至 (%.0f, %.0f, %.0f)", targetX, targetY, targetZ))
                end
                prevX, prevY, prevZ = getCoords(base)
                if not prevX then break end
            else
                prevX, prevY, prevZ = curX, curY, curZ
            end
        end

        local elapsed = 0
        while elapsed < _AutoPullBack.checkInterval and not _AutoPullBack.stopFlag do
            gg.sleep(20)
            elapsed = elapsed + 20
        end
    end

    if _AutoPullBack.freezeOnPull then
        unfreeze(base)
    end
    _AutoPullBack.running = false
    _AutoPullBack.thread = nil
    提示("自动回拉已停止")
end

function startAutoPullBack()
    if _AutoPullBack.running then
        提示("已在运行")
        return false
    end
    local base = getSelfBase()
    if not base then
        提示("获取基址失败")
        return false
    end
    _AutoPullBack.baseAddr = base
    _AutoPullBack.stopFlag = false
    _AutoPullBack.running = true
    _AutoPullBack.thread = luajava.startThread(autoPullBackLoop)
    local freezeMsg = _AutoPullBack.freezeOnPull and "开启" or "关闭"
    提示(string.format("启动成功 距离阈值=%d 间隔=%dms 冻结=%s", _AutoPullBack.threshold, _AutoPullBack.checkInterval, freezeMsg))
    return true
end

function stopAutoPullBack()
    if not _AutoPullBack.running then
        提示("未运行")
        return false
    end
    _AutoPullBack.stopFlag = true
    local wait = 0
    while _AutoPullBack.running and wait < 2000 do
        gg.sleep(50)
        wait = wait + 50
    end
    if _AutoPullBack.running then
        if _AutoPullBack.freezeOnPull then
            unfreeze(_AutoPullBack.baseAddr)
        end
        _AutoPullBack.running = false
        _AutoPullBack.thread = nil
        提示("强制停止")
    end
    return true
end

function setFreezeOnPull(flag)
    _AutoPullBack.freezeOnPull = flag == true
    提示("回拉冻结已" .. (_AutoPullBack.freezeOnPull and "开启" or "关闭"))
end

function configureAutoPullBack()
    local currentThreshold = _AutoPullBack.threshold
    local currentFreeze = _AutoPullBack.freezeDuration
    local currentInterval = _AutoPullBack.checkInterval

    local inputs = gg.prompt(
        {
            "距离阈值 (坐标单位)",
            "冻结时间 (毫秒)",
            "检测间隔 (毫秒，≥50)"
        },
        {
            tostring(currentThreshold),
            tostring(currentFreeze),
            tostring(currentInterval)
        },
        {
            "number",
            "number",
            "number"
        }
    )

    if inputs == nil then
        提示("已取消配置")
        return
    end

    local newThreshold = tonumber(inputs[1])
    local newFreeze = tonumber(inputs[2])
    local newInterval = tonumber(inputs[3])

    if newThreshold == nil or newThreshold <= 0 then
        提示("距离阈值必须为正数")
        return
    end
    if newFreeze == nil or newFreeze < 0 then
        提示("冻结时间不能为负数")
        return
    end
    if newInterval == nil or newInterval < 50 then
        提示("检测间隔不能小于 50ms")
        return
    end

    _AutoPullBack.threshold = newThreshold
    _AutoPullBack.freezeDuration = newFreeze
    _AutoPullBack.checkInterval = newInterval

    提示(string.format("配置已更新\n阈值=%.0f\n冻结时间=%.0fms\n间隔=%.0fms", newThreshold, newFreeze, newInterval))
end





draw.setColor("#FAEBD7")
jiaobenqidongjishi = draw.text('', 200, 200)

function kongzhi_jishi(dongzuo)
    if dongzuo == "启动" then
        if not jishi_yunxing then
            kaishi_shijian = os.time()
            jishi_yunxing = true
            
            functions.thread(function()
                while jishi_yunxing do
                    local yongshi = os.difftime(os.time(), kaishi_shijian)
                    local shijian = string.format("%02d:%02d:%02d", 
                        math.floor(yongshi/3600),
                        math.floor((yongshi%3600)/60),
                        yongshi%60)
                    draw.updateText(jiaobenqidongjishi, shijian)
                    gg.sleep(1000)
                end
            end)()
            提示("计时器启动")
        end
        
    elseif dongzuo == "停止" then
        jishi_yunxing = false
        提示("计时器停止")
    elseif dongzuo == "重置" then
        jishi_yunxing = false
        draw.updateText(jiaobenqidongjishi, '')
        kaishi_shijian = nil
        提示("计时器重置")
    end
end


kongzhi_jishi("启动")





















crashGuard = crashGuard or {
    enabled = false,
    targetPkg = nil,
    targetName = nil,
    interval = 500,
    crashCount = 0,
    state = "normal",
    lastCrashTime = 0,
    thread = nil,
    stopFlag = false,
    running = false
}

local function getCurrentInfo()
    local ok, info = pcall(gg.getTargetInfo)
    if not ok or not info then return nil, nil end
    local pkg = info.packageName
    local name = nil
    if info.activities and info.activities[1] and info.activities[1].label then
        name = info.activities[1].label
    end
    return pkg, name or pkg
end

local function setProcess(pkg)
    if not pkg then return false end
    for retry = 1, 3 do
        pcall(gg.setProcess, pkg)
        gg.sleep(80)
        local curPkg, _ = getCurrentInfo()
        if curPkg == pkg then return true end
    end
    return false
end

local function isTargetAlive()
    return setProcess(crashGuard.targetPkg)
end

local function getAllPackages()
    local ok, list = pcall(gg.getProcessList)
    if not ok or not list then return {} end
    local pkgs = {}
    for _, proc in ipairs(list) do
        if proc.pkgName and proc.pkgName ~= "" then
            pkgs[#pkgs + 1] = proc.pkgName
        end
    end
    return pkgs
end

local function tryRecover()
    local target = crashGuard.targetPkg
    if not target then return false end
    if setProcess(target) then
        crashGuard.targetName = select(2, getCurrentInfo()) or target
        return true
    end
    local others = getAllPackages()
    for _, pkg in ipairs(others) do
        if pkg ~= target and setProcess(pkg) then
            crashGuard.targetName = select(2, getCurrentInfo()) or pkg
            return true
        end
    end
    return false
end

local function monitorLoop()
    crashGuard.running = true
    while not crashGuard.stopFlag do
        local alive = isTargetAlive()
        if not alive then
            if crashGuard.state == "normal" then
                crashGuard.state = "crashing"
                crashGuard.crashCount = crashGuard.crashCount + 1
                crashGuard.lastCrashTime = os.time()
                提示("检测到进程崩溃 (第 " .. crashGuard.crashCount .. " 次)")
            end
            gg.sleep(300)
            if tryRecover() then
                if crashGuard.targetPkg == (select(1, getCurrentInfo())) then
                    crashGuard.state = "normal"
                    提示("已恢复至原进程，监控继续")
                else
                    crashGuard.state = "recovered"
                    提示("已临时切换到其他进程，原进程恢复后会自动切回")
                end
            else
                提示("未找到可用进程，请手动重新附加游戏")
            end
        else
            if crashGuard.state ~= "normal" then
                crashGuard.state = "normal"
                提示("进程已恢复正常")
            end
        end
        local elapsed = 0
        while elapsed < crashGuard.interval and not crashGuard.stopFlag do
            gg.sleep(50)
            elapsed = elapsed + 50
        end
    end
    crashGuard.running = false
end

function startCrashProtection()
    if crashGuard.enabled then
        提示("保护已在运行")
        return true
    end
    local pkg, name = getCurrentInfo()
    if not pkg then
        gg.alert("请先附加游戏进程")
        return false
    end
    crashGuard.targetPkg = pkg
    crashGuard.targetName = name or pkg
    crashGuard.stopFlag = false
    crashGuard.crashCount = 0
    crashGuard.state = "normal"
    crashGuard.lastCrashTime = 0
    crashGuard.enabled = true
    crashGuard.thread = luajava.startThread(monitorLoop)
    提示("防崩溃保护已启动，监控进程：\n" .. (crashGuard.targetName or pkg) .. " (" .. pkg .. ")")
    return true
end

function stopCrashProtection()
    if not crashGuard.enabled then
        提示("保护未运行")
        return false
    end
    crashGuard.stopFlag = true
    local wait = 0
    while crashGuard.running and wait < 2000 do
        gg.sleep(50)
        wait = wait + 50
    end
    crashGuard.enabled = false
    crashGuard.thread = nil
    crashGuard.targetPkg = nil
    crashGuard.targetName = nil
    提示("防崩溃保护已停止")
    return true
end

function getCrashStats()
    local curPkg, curName = getCurrentInfo()
    return {
        isMonitoring = crashGuard.enabled,
        currentProcess = curPkg,
        currentName = curName,
        crashCount = crashGuard.crashCount,
        hasCrashedRecently = (crashGuard.state ~= "normal")
    }
end

function showProtectionStatus()
    if not crashGuard.enabled then
        gg.alert("防崩溃保护未启动")
        return
    end
    local stats = getCrashStats()
    local statusText = stats.isMonitoring and "🟢运行中" or "⚪已停止"
    local display = (stats.currentName or "未知") .. " (" .. (stats.currentProcess or "未设置") .. ")"
    local crashText
    if stats.hasCrashedRecently then
        crashText = "近期发生过崩溃"
    else
        crashText = string.format("稳定运行（近期崩溃过 %d 次）", stats.crashCount)
    end
    local info = "防崩溃保护状态\n\n"
    info = info .. "保护状态: " .. statusText .. "\n"
    info = info .. "当前进程: " .. display .. "\n"
    info = info .. "运行状态: " .. crashText .. "\n"
    info = info .. "检测间隔: " .. crashGuard.interval .. "ms\n"
    gg.alert(info)
end

function cleanupCrashProtection()
    if crashGuard.enabled then
        stopCrashProtection()
    end
    crashGuard = nil
end















vibra = context:getSystemService(Context.VIBRATOR_SERVICE)
function 获取图片(txt)
ntxt=string.sub(string.gsub(txt,"/","."),-10,-1)
if string.find(tostring(txt),"http")~=nil then
if panduan("/sdcard/长安/图片/"..ntxt)==false then
file.download(txt,"/sdcard/长安/图片/"..ntxt)
end
txt="/sdcard/长安/图片/"..ntxt
end
return luajava.getBitmapDrawable(txt)
end



-----------------------------------------------------------------------------------------------------------以下为UI配置，请勿动

RG = {}
local RG = RG
local android = import('android.*')
function write(fileName, content)
file.write(fileName, content)
end
function panduan(rec) fille,err = io.open(rec) if fille == nil then return false else return true end end
function pdcf(lujing) rec = "/sdcard/长安/配置文件/"..lujing fille,err = io.open(rec) if fille == nil then return false else return true end end
sleep = gg.sleep
function read(fileName) f = assert(io.open(fileName, 'r')) content = f:read("*all") f:close() return content end
function wtcf(lujing,neirong)
write("/sdcard/长安/配置文件/"..lujing,neirong)
end
function rdcf(lujing)
return read("/sdcard/长安/配置文件/"..lujing)
end

context = app.context
window = context:getSystemService("window")
function getLayoutParams()
LayoutParams = WindowManager.LayoutParams
layoutParams = luajava.new(LayoutParams)
if (Build.VERSION.SDK_INT >= 26) then
layoutParams.type = LayoutParams.TYPE_APPLICATION_OVERLAY
else
	layoutParams.type = LayoutParams.TYPE_PHONE
end

layoutParams.format = PixelFormat.RGBA_8888 -- 设置背景
layoutParams.flags = LayoutParams.FLAG_NOT_FOCUSABLE -- 焦点设置Finish
layoutParams.gravity = Gravity.TOP|Gravity.LEFT -- 重力设置
layoutParams.width = LayoutParams.WRAP_CONTENT -- 布局宽度
layoutParams.height = LayoutParams.WRAP_CONTENT -- 布局高度

return layoutParams
end
function getj6()
jianbian6 = luajava.new(GradientDrawable)
jianbian6:setCornerRadius(20)
jianbian6:setGradientType(GradientDrawable.LINEAR_GRADIENT)
jianbian6:setColors({
	0xff2F3032,0xff2F3032
})
jianbian6:setStroke(0,"0xddffffff")--边框宽度和颜色
return jianbian6
end
RG.controlFlip = function(control,time)
	luajava.runUiThread(function()
  import "android.view.animation.Animation"
  import "android.animation.ObjectAnimator"
  xuanzhuandonghua = ObjectAnimator:ofFloat(control, "rotationY", {0, 360})
  xuanzhuandonghua:setRepeatCount(0)
  xuanzhuandonghua:setRepeatMode(Animation.REVERSE)
  xuanzhuandonghua:setDuration(time)
  xuanzhuandonghua:start()
end) end
slctb = luajava.loadlayout {
	GradientDrawable,
	color = "#00ffffff",
	cornerRadius = 0
}
slcta = luajava.loadlayout {
	GradientDrawable,
	color = "#55ffffff",
	cornerRadius = 8
}
slctc = luajava.loadlayout {
	GradientDrawable,
	color = "#11ffffff",
	cornerRadius = 8
}
slctd = luajava.loadlayout {
	GradientDrawable,
	color = "#55ffffff",
	cornerRadius = 8
}
slcte = luajava.loadlayout {
	GradientDrawable,
	color = "#11ffffff",
	cornerRadius = 12
}
slctf = luajava.loadlayout {
	GradientDrawable,
	color = "#aa1E1C27",
	cornerRadius = 12
}
function getSelector3()
selector = luajava.getStateListDrawable()
selector:addState({
	android.R.attr.state_pressed
}, luajava.loadlayout {
	GradientDrawable,
	color = "#feeeed",
	cornerRadius = 10
}) -- 点击时候的背景
selector:addState({
	-android.R.attr.state_pressed
}, getShape3()) -- 没点击的背景
return selector
end
hanshu = function(v, event)
local Action = event:getAction()
if Action == MotionEvent.ACTION_DOWN then
isMove = false
RawX = event:getRawX()
RawY = event:getRawY()
x = mainLayoutParams.x
y = mainLayoutParams.y
elseif Action == MotionEvent.ACTION_MOVE then
isMove = true
mainLayoutParams.x = tonumber(x) + (event:getRawX() - RawX)
mainLayoutParams.y = tonumber(y) + (event:getRawY() - RawY)
window:updateViewLayout(floatWindow, mainLayoutParams)
end
end

function getSelector()
selector = luajava.getStateListDrawable()
selector:addState({
	android.R.attr.state_pressed
}, slcta) -- 点击时候的背景
selector:addState({
	-android.R.attr.state_pressed
}, slctb) -- 没点击的背景
return selector
end
function getSelector2()
selector = luajava.getStateListDrawable()
selector:addState({
	android.R.attr.state_pressed
}, slctd) -- 点击时候的背景
selector:addState({
	-android.R.attr.state_pressed
}, slctc) -- 没点击的背景
return selector
end

jianbian = luajava.new(GradientDrawable)
jianbian:setCornerRadius(30)
jianbian:setGradientType(GradientDrawable.LINEAR_GRADIENT)
jianbian2 = luajava.new(GradientDrawable)
jianbian2:setCornerRadius(30)
jianbian2:setGradientType(GradientDrawable.LINEAR_GRADIENT)

local isswitch
YoYoImpl = luajava.getYoYoImpl()
RG.menu = function(sview)
if isswitch then
return false
end
isswitch = true
cebian = {
	LinearLayout,
	id = "侧边",
	visibility = "gone",
	layout_height = "37dp",
	layout_width = "80dp",--侧边按钮宽
	orientation = "vertical",
	}
for i = 1,#stab do
cebian[#cebian+1] = {
	FrameLayout,
	id = "jm"..i,
layout_height = "33dp",--侧边按钮底面高
layout_width = "80dp",--侧边按钮底面宽
	layout_marginTop = "2.1dp",--侧边按钮间隔
	layout_marginBottom = "2.1dp",--侧边按钮间隔
	background = getSelector(),
	{
		TextView,
		text = stab[i],
		layout_gravity="center",
		gravity = "center",
		layout_height = "80dp",
		layout_width = "136dp",
		onClick = function() 切换(i) end,
		onTouch=hanshu,
	},{
		TextView,
		text = ">",
		id="jmj"..i,
		textColor="#ffffff",
		layout_gravity = "right|center",
		textSize="15sp",
	layout_marginTop="-3dp",
		layout_marginRight="5dp",
		layout_height = "wrap_content",
		layout_width = "wrap_content",
		onClick = function() 切换(i) end,
		onTouch=hanshu,
	}}
end
cebian = luajava.loadlayout(cebian)
gund=luajava.loadlayout({ScrollView,
		cebian})
for i = 1,#stab do
_ENV["layout"..i] = luajava.loadlayout({
	ScrollView,
	fillViewport = true,
	id = "layout"..i,
	visibility = "gone",
	gravity = "center",
	layout_width = "350dp",
	layout_height = "324.1dp",
	orientation = "horizontal",
	background="#808080",
	{
		LinearLayout,
		id = "layoutm"..i,
		background = getj6(),
		layout_marginRight = "5dp",
		layout_marginLeft = "5dp",
		layout_width = "330dp",
		orientation = "vertical",
		gravity = "center_horizontal",
		background="#808080",
	}
})
end
ckou = {
	LinearLayout,
	visibility = "visible",
	layout_width = "wrap_content",
	layout_height = "wrap_content",
	orientation = "horizontal",
	{
		LinearLayout,
		id="ckbg",
		visibility="gone",
		background="#808080",--侧边栏颜色
		orientation = "vertical",
		padding = "2dp",
		layout_height="324.1dp",--背景板和侧边栏高
		layout_width="80dp",  --侧边栏宽
	},
}
for i = 1,#stab do
ckou[#ckou+1] = _ENV["layout"..i]
end
ckou = luajava.loadlayout(ckou)
floatWindow = {
	FrameLayout,
	id = "motion",
	layout_width = "wrap_content",
	orientation = "vertical",
	layout_height = "wrap_content",
	ckou,
	{
		LinearLayout,
		id="wxbgv",
		orientation = "vertical",
		layout_height="wrap_content",
		{
		LinearLayout,
		id = "control",
		gravity = "center",
		layout_height = "30dp",--悬浮条高
		layout_width = "80dp",--悬浮条宽
		background="#808080",--悬浮条背景颜色
			{ImageView,
			background=(xfcpic),
			layout_height = "30dp",
			layout_width = "30dp",
			},
			{TextView,
			text = stitle,			
			gravity = "center",
			layout_height = "30dp",
			layout_width = "40dp",
			}
		},
		gund,
	}
}
local function invoke()
local ok
local RawX, RawY, x, y
mainLayoutParams = getLayoutParams()
floatWindow = luajava.loadlayout(floatWindow)
local function invoke2()
block('start')
for k = 1,#stab do
for i = 1,#sview[k] do
_ENV["layoutm"..k]:addView(sview[k][i])
end
end

window:addView(floatWindow, mainLayoutParams)
block('end')
end

local runnable = luajava.getRunnable(invoke2)
local handler = luajava.getHandler()
handler:post(runnable)
block('join')
control.onClick = 隐藏

local isMove

motion.onTouch = hanshu
control.onTouch = hanshu
for i = 1,#stab do
_ENV["jm"..i].onTouch = hanshu
end
end

invoke(swib1,swib2)
gg.setVisible(false)
luajava.setFloatingWindowHide(true)


end

function getseekgra()
jianbians = luajava.new(GradientDrawable)
jianbians:setCornerRadius(10)
jianbians:setGradientType(GradientDrawable.LINEAR_GRADIENT)
jianbians:setColors({
	0x6600c6ff,0x660072ff
})
jianbians:setStroke(2,"0x44ffffff")--边框宽度和颜色

return jianbians
end
RG.controlWater = function(control,time)
	luajava.runUiThread(function()
  import "android.animation.ObjectAnimator"
  ObjectAnimator():ofFloat(control,"scaleX",{1, 0.8, 0.9, 1}):setDuration(time):start()
  ObjectAnimator():ofFloat(control,"scaleY",{1,0.8,0.9,1}):setDuration(time):start()
end) end
RG.controlSmall = function(control,time)
	luajava.runUiThread(function()
  import "android.animation.ObjectAnimator"
  ObjectAnimator():ofFloat(control,"scaleX",{1, 0.7, 0.4, 0}):setDuration(time):start()
  ObjectAnimator():ofFloat(control,"scaleY",{1, 0.7, 0.4, 0}):setDuration(time):start()
end) end
RG.controlBig = function(control,time)
	luajava.runUiThread(function()
  import "android.animation.ObjectAnimator"
  ObjectAnimator():ofFloat(control,"scaleX",{0, 0.4, 0.7, 1}):setDuration(time):start()
  ObjectAnimator():ofFloat(control,"scaleY",{0, 0.4, 0.7, 1}):setDuration(time):start()
end) end
corbk = true
当前ui = 0
function 隐藏侧边()
luajava.runUiThread(function()
	if tonumber(tostring(cebian:getVisibility())) == 8.0 then 
		cebian:setVisibility(View.VISIBLE)
	else
		cebian:setVisibility(View.GONE)
	end
end)
end
function 切换(x)
if x~=0 then
luajava.runUiThread(function()
	if 当前ui~=x then
当前ui = x
	for i = 1,#stab do
	_ENV["jm"..i]:setBackground(slctb)
	_ENV["jmj"..i]:setTextColor(0xffffffff)
	_ENV["jmj"..i]:setText(">")
	_ENV["layout"..i]:setVisibility(View.GONE)
	end
	_ENV["layout"..当前ui]:setVisibility(View.VISIBLE)
	_ENV["jm"..当前ui]:setBackground(slcta)
	_ENV["jmj"..当前ui]:setTextColor(0xff000000)
	_ENV["jmj"..当前ui]:setText("≫")

else
	_ENV["layout"..当前ui]:setVisibility(View.GONE)
	_ENV["jm"..当前ui]:setBackground(slctb)
	_ENV["jmj"..当前ui]:setText(">")
	_ENV["jmj"..当前ui]:setTextColor(0xffffffff)
	当前ui=0
end
end)
end
end
显示 = 0
beij = luajava.new(GradientDrawable)
beij:setCornerRadius(10)
beij:setGradientType(GradientDrawable.LINEAR_GRADIENT)
beij:setColors({
	0x7742444B,0x7742444B
})
beij2 = luajava.loadlayout({
	GradientDrawable,
	color = "#001E1C27",
	cornerRadius = 10
})

function 隐藏()
luajava.runUiThread(function()
	if tonumber(tostring(cebian:getVisibility())) == 8.0 then
ckou:setVisibility(View.VISIBLE)
	cebian:setVisibility(View.VISIBLE)
	ckou:setBackground(beij)
	ckbg:setVisibility(View.VISIBLE)
	else
	ckou:setBackground(beij2)
	ckou:setVisibility(View.GONE)
	ckbg:setVisibility(View.GONE)
	cebian:setVisibility(View.GONE)
	end
	end)
end

function guid()
seed = {
	'e','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'
}
tb = {}
for i = 1,32 do
table.insert(tb,seed[math.random(1,16)])
end
sid = table.concat(tb)
return string.format('%s%s%s%s%s',
	string.sub(sid,1,8),
	string.sub(sid,10,12),
	string.sub(sid,21,22))
..string.format('%s%s%s%s%s',
	string.sub(sid,1,6),
	string.sub(sid,21,25)
)
end

function getShape3()
jianbians = luajava.new(GradientDrawable)
jianbians:setCornerRadius(5)
jianbians:setGradientType(GradientDrawable.LINEAR_GRADIENT)
jianbians:setColors({0x00000000,0x00000000})
jianbians:setOrientation(GradientDrawable.Orientation.LEFT_RIGHT)
jianbians:setStroke(8,0x00000000)--边框宽度和颜色
return jianbians
end
swcbg=getShape3()


local taskQueue = {}
local isDispatcherActive = false
local cleanupSystem = {
isCleaning = false,
cleanupStartTime = 0,
maxCleanupTime = 10000,
originalTaskQueue = nil,
cleanupThread = nil
}

local function startCleanupLoop()
if cleanupSystem.isCleaning then
提示("[清除系统] 清除正在进行中，跳过重复启动")
return
end

cleanupSystem.isCleaning = true
cleanupSystem.cleanupStartTime = os.time()

cleanupSystem.originalTaskQueue = #taskQueue

提示("[清除系统] 开始清除循环，目标队列长度: " .. cleanupSystem.originalTaskQueue)

cleanupSystem.cleanupThread = luajava.newThread(function()
local 清除成功 = false
local 最后检查时间 = os.time()

while cleanupSystem.isCleaning do
local 当前时间 = os.time()
local 已运行时间 = 当前时间 - cleanupSystem.cleanupStartTime

if 已运行时间 >= cleanupSystem.maxCleanupTime / 1000 then
提示("[清除系统] 清除超时，强制恢复")
break
end

if 当前时间 - 最后检查时间 >= 0.01 then
最后检查时间 = 当前时间

isDispatcherActive = false

local 当前队列长度 = #taskQueue
taskQueue = {}

if 当前队列长度 == 0 then
清除成功 = true
提示("[清除系统] 队列已清空，清除成功")
break
else
提示("[清除系统] 清除中... 剩余任务: " .. 当前队列长度)
end
end

luajava.sleep(10)
end

cleanupSystem.isCleaning = false

local 清除数量 = cleanupSystem.originalTaskQueue or 0
if 清除成功 then
清理提示("✅ 清除成功！共清除 " .. 清除数量 .. " 个任务")
else
清理提示("⚠️ 清除超时，已强制停止 " .. 清除数量 .. " 个任务")
end
end)

cleanupSystem.cleanupThread:start()
end


local function clearTaskQueue()
提示("[清除指令] 用户请求清除任务队列")


if #taskQueue == 0 then
清理提示("📭 任务队列已经是空的")
return true
end

startCleanupLoop()

return true
end


local function startTaskDispatcher()
if isDispatcherActive or cleanupSystem.isCleaning then return end
isDispatcherActive = true

luajava.newThread(function()
while isDispatcherActive do

if cleanupSystem.isCleaning then
isDispatcherActive = false
提示("[调度器] 检测到清除状态，停止执行")
break
end

if #taskQueue == 0 then
isDispatcherActive = false
break
end

local currentTask = table.remove(taskQueue, 1)
if type(currentTask) == "function" then

if cleanupSystem.isCleaning then
isDispatcherActive = false
break
end

local success, err = pcall(currentTask)
if not success then
提示("任务执行失败：" .. tostring(err))
end

if cleanupSystem.isCleaning then
isDispatcherActive = false
break
end
end

luajava.sleep(50)
end
isDispatcherActive = false
end):start()
end

local function enqueueTask(taskFunc)

if cleanupSystem.isCleaning then
提示("[入队] 系统正在清除中，拒绝新任务")
return false
end

if type(taskFunc) ~= "function" then 
return 
end

if not taskQueue then
taskQueue = {}
end

if #taskQueue >= 50 then
table.remove(taskQueue, 1)
end

table.insert(taskQueue, taskFunc)
startTaskDispatcher()
return true
end



function RG.button(txt,func )
    if not txt then txt = "未设置" end
    
	local tid=guid()..guid()
	_ENV[tid]=luajava.loadlayout (
		{
			LinearLayout ,
			layout_width = 'fill_parent' ,
			layout_hight = "fill_parent" , {
				LinearLayout ,
				layout_width = "fill_parent" ,
				gravity = "center_horizontal" ,
				layout_marginTop = "5dp" ,
				layout_marginBottom = "5dp" ,
				background = luajava.loadlayout {
					GradientDrawable ,
					color = "#00000000" ,
					cornerRadius = 8
				} ,
				onClick = function()
					RG.controlWater(_ENV[tid],200)
					enqueueTask(function()
						pcall(func)
					end)
				end
				,
    			{
    				TextView,
    				text = txt,
    				textSize = "12sp",
    				layout_width = "wrap_content",
    			},
background = luajava.loadlayout {
					GradientDrawable ,
					color = "#00000000" ,
					cornerRadius = 8
				} ,			
			} } )
	return _ENV[tid]
end


function newradio(radio)
firadio={LinearLayout,
    layout_width = 'match_parent',
    layout_height = "match_parent",
    orientation="horizontal"
}
if type(radio[1])=="string" or type(radio[1])=="number"  then
--firadio[#firadio+1]={TextView,text=radio[1],textColor="#ffffff",}
end
radios={RadioGroup,orientation="horizontal",gravity="center",background="#00C92E37",layout_width = 'match_parent',}
for i=2,#radio do
    radios[#radios+1]={
    RadioButton,
    
    text=radio[i][1],
    textColor="#37CBFF",
    textSize="11sp",
    onClick=function() luajava.newThread(function() pcall(radio[i][2]) end):start() end,
    }
end
firadio[#firadio+1]=radios
return luajava.loadlayout(firadio)
end
function newcheck(radio)
firadio={LinearLayout,layout_width = 'match_parent',layout_height = "match_parent",orientation="vertical"}
if type(radio[1])=="string" or type(radio[1])=="number"  then
firadio[#firadio+1]={TextView,text=radio[1],textColor="#ffffff",} end
radios={LinearLayout,orientation="horizontal",gravity="center",background="#00C92E37",layout_width = 'match_parent',}
for i=2,#radio do
    radios[#radios+1]={CheckBox,
    text=radio[i][1],
    textSize="9sp",
    textColor="#ffffff",
    onClick=function() luajava.newThread(function() pcall(radio[i][2]) end):start() end,
    }
end
firadio[#firadio+1]=radios
return luajava.loadlayout(firadio)
end

function RG.radio(radio )
	firadio = {
		LinearLayout ,
		layout_width = 'fill_parent' ,
		layout_height = "wrap_content" ,
		orientation = "vertical"
	}
	if type(radio [ 1 ] ) == "string" or type(radio [ 1 ] ) == "number" then
		firadio [ # firadio + 1 ] = {
			TextView , text = radio [ 1 ] , textColor = "#ffffff" ,
			textSize = "10sp" ,
		}
	end
	radios = {
		RadioGroup , background = luajava.loadlayout({
				GradientDrawable ,
				color = "#00000000" ,
				cornerRadius = 30
			} ) , layout_width = 'fill_parent' , layout_height = "wrap_content" ,
	}
	for i = 2 , # radio do
		local btnFunc = radio[i][2]
		radios [ # radios + 1 ] = {
			RadioButton ,
			layout_width = 'fill_parent' ,
			layout_height = "28dp" ,
			text = radio [ i ] [ 1 ] ,
			textColor = "#F0FFFF" ,
			textSize = "10sp" ,
			onClick = function()
				enqueueTask(function()
					btnFunc()
				end)
			end
			,
		}
	end
	firadio [ # firadio + 1 ] = radios
	return luajava.loadlayout(firadio )
end

function RG.radio1(radio )
	firadio = {
		LinearLayout ,
		layout_width = 'fill_parent' ,
		layout_height = "wrap_content" ,
		orientation = "vertical"
	}
	if type(radio [ 1 ] ) == "string" or type(radio [ 1 ] ) == "number" then
		firadio [ # firadio + 1 ] = {
			TextView , text = radio [ 1 ] , textColor = "#ffffff" ,
			textSize = "10sp" ,
		}
	end
	radios = {
		RadioGroup , background = luajava.loadlayout({
				GradientDrawable ,
				color = "#00000000" ,
				cornerRadius = 30
			} ) , layout_width = 'fill_parent' , layout_height = "wrap_content" ,
	}
	for i = 2 , # radio do
		local btnFunc = radio[i][2]
		radios [ # radios + 1 ] = {
			RadioButton ,
			layout_width = 'fill_parent' ,
			text = radio [ i ] [ 1 ] ,
			textColor = "#FF0F5" ,
			textSize = "10sp" ,
			onClick = function()
				enqueueTask(function()
					btnFunc()
				end)
			end
			,
		}
	end
	firadio [ # firadio + 1 ] = radios
	return luajava.loadlayout(firadio )
end


function RG.radio2(radio )
	firadio = {
		LinearLayout ,
		layout_width = 'fill_parent' ,
		layout_height = "wrap_content" ,
		orientation = "vertical"
	}
	if type(radio [ 1 ] ) == "string" or type(radio [ 1 ] ) == "number" then
		firadio [ # firadio + 1 ] = {
			TextView , text = radio [ 1 ] , textColor = "#ffffff" ,
			textSize = "10sp" ,
		}
	end
	radios = {
		RadioGroup , background = luajava.loadlayout({
				GradientDrawable ,
				color = "#00000000" ,
				cornerRadius = 30
			} ) , layout_width = 'fill_parent' , layout_height = "wrap_content" ,
	}
	for i = 2 , # radio do
		radios [ # radios + 1 ] = {
			RadioButton ,
			layout_width = 'fill_parent' ,
			layout_height = "28dp" ,
			text = radio [ i ] [ 1 ] ,
			textColor = "#F0FFFF" ,
			textSize = "10sp" ,
			onClick = function()
				luajava.newThread(function()
						radio [ i ] [ 2 ]()
					end

				) : start()
			end

			,
		}
	end
	firadio [ # firadio + 1 ] = radios
	return luajava.loadlayout(firadio )
end


function newcheck(radio)
	firadio={LinearLayout,layout_width = 'match_parent',layout_height = "match_parent",orientation="vertical"}
	if type(radio[1])=="string" or type(radio[1])=="number" then
		firadio[#firadio+1]={TextView,text=radio[1],textColor="#ffffff",} end
	radios={LinearLayout,orientation="horizontal",gravity="center",background="#00C92E37",layout_width = 'match_parent',}
	for i=2,#radio do
		local name = radio[i][1]
		local func1 = radio[i][2]
		local func2 = radio[i][3]
		local nid = radio[i][4]
		if not name then name = "未设置" end
		nid = name..guid()
		local func = 开关(nid,func1,func2)
		radios[#radios+1]={CheckBox,
			text=radio[i][1],
			textSize="9sp",
			textColor="#ffffff",
			onClick=function()
				luajava.newThread(function()
					pcall(func)
				end):start()
			end,
		}
	end
	firadio[#firadio+1]=radios
	return luajava.loadlayout(firadio)
end




function runAsyncTask(taskFunc)
    if type(taskFunc) ~= "function" then
        提示("请传入有效的执行函数")
        return
    end
    luajava.newThread(function()
        pcall(taskFunc)
    end):start()
end


function RG.text(txt,color,size)
if not txt then txt = "未设置文字" end
if not color then color = "#5c7a29" end
if not size then size = "13sp" end
return luajava.loadlayout({LinearLayout,
	gravity="left",
	layout_width="220dp",
	{
		TextView,
		text = txt,
		textSize = size,
		textColor = color,
		layout_width = "wrap_content",
	}})
end
corb = true


function 开关(name,func1,func2)
if func1 == nil then func1 = "" end
if func2 == nil then func2 = "" end
if type(func1) == "function" then
return function()
namers = _ENV[name]
if namers ~= "开" then
_ENV[name] = "开"
pcall(func1)
else
	_ENV[name] = "关"
pcall(func2)
end
end
end
end
paramt = {}
titletable = {}
corb = true


function getLayoutParams2()
local prm = luajava.new(WindowManager.LayoutParams)
layoutParams1 = prm
if (Build.VERSION.SDK_INT >= 26) then -- 设置悬浮窗方式
layoutParams1.type = prm.TYPE_APPLICATION_OVERLAY
else
	layoutParams1.type = prm.TYPE_PHONE
end
layoutParams1.format = PixelFormat.RGBA_8888 -- 设置背景
layoutParams1.flags = prm.FLAG_NOT_FOCUSABLE -- 焦点设置Finish
layoutParams1.gravity = Gravity.CENTER -- 重力设置
layoutParams1.width = prm.WRAP_CONTENT -- 布局宽度
layoutParams1.height = prm.WRAP_CONTENT -- 布局高度
return layoutParams1
end


function visi(tid , ttid )
	local tview = luajava.getIdValue(tid )
	local ttview = luajava.getIdValue(ttid )
	if not tview then
		return 0
	end
	if tonumber(tostring(tview : getVisibility() ) ) == 8.0 then
		tview : setVisibility(View.VISIBLE )
		ttview : setBackground(luajava.getBitmapDrawable("/sdcard/长安/图片/hsj" ) )
	else
		tview : setVisibility(View.GONE )
		ttview : setBackground(luajava.getBitmapDrawable("/sdcard/长安/图片/sj" ) )
	end
end


function RG.line()
rest = luajava.loadlayout({
    LinearLayout,
    layout_width = 'fill_parent',
    layout_height = "1dp",
    background = "#33ffffff",
})
return rest
end


function RG.box(views )
	local tid = "box"..guid()
	local ttid = tid.."6"
	local t1id=guid()
	firadio = {
		LinearLayout ,
		layout_width = 'fill_parent' ,
		layout_height = "wrap_content" ,
		layout_marginTop = "2dp" ,
		layout_marginBottom = "2dp" ,
		orientation = "vertical" ,
		background = luajava.loadlayout {
			GradientDrawable ,
			color = "#00000000" ,
			cornerRadius = 8
		} ,
	}
	if type(views [ 1 ] ) == "string" or type(views [ 1 ] ) == "number" then
		firadio [ # firadio + 1 ] = {
			LinearLayout ,
			layout_width = 'fill_parent' ,
			layout_height = "30dp" ,
			gravity = "center_vertical" ,
			layout_marginTop = "2dp" ,
			layout_marginBottom = "4dp" ,
			onClick = function()
				RG.controlWater(_ENV[t1id],200)
				visi(tid , ttid )
			end,
			background = luajava.loadlayout {
				GradientDrawable ,
				color = "#00000000" ,
				cornerRadius = 8
			} ,
			{
				ImageView ,
				layout_marginLeft = "10dp" ,
				id = luajava.newId(ttid ) ,
				background = "/sdcard/长安/图片/sj" ,
				layout_width = "20dp" ,
				layout_height = "20dp" ,
				layout_marginTop = "0dp" ,
			} ,
			{
				TextView , text = views [ 1 ] ,
				textSize = "12sp" ,
				layout_marginLeft = "15dp" ,
				layout_width = "300dp" ,
				textColor = "#FAEBD7" ,
				gravity = "left" ,
			} }
	else
		gg.alert("RG.box第一个参数必须是string" ) os.exit()
	end
	radios = {
		LinearLayout ,
		layout_marginLeft = "0dp" ,
		layout_marginRight = "0dp" ,
		orientation = "vertical" ,
		visibility = "gone" ,
		id = luajava.newId(tid ) ,
		padding = "0dp" ,
		layout_width = 'fill_parent' ,
	}
	for i = 2 , # views do
		radios [ # radios + 1 ] = views [ i ]
	end
	firadio [ # firadio + 1 ] = radios
	_ENV[t1id]=luajava.loadlayout(firadio )
	return _ENV[t1id]
end


function RG.buts(cklist)
	rest={LinearLayout,
	layout_width = 'wrap_content',
	layout_height = "40dp",
	gravity="center"
	}
	for i=1,#cklist do
		local func=cklist[i][2]
		rest[#rest+1]={
			Button,
			text=cklist[i][1],
			textSize="11sp",
			padding="1dp",
			onClick=function()
				enqueueTask(function()
					func()
				end)
			end,
			background=getSelector3(),
			layout_width = '110dp',--每个按钮的宽
			layout_height = "30dp",
		}
	end
	rst=luajava.loadlayout({
		HorizontalScrollView,
	layout_width = 'fill_parent',
	layout_height = "40dp",
	rest
	})
	return rst
end

function RG.check(cklist )
	rest = {
		LinearLayout ,
		layout_width = 'match_parent' ,
		layout_height = "wrap_content" ,
		layout_marginTop = "10dp" ,
		gravity = "top" ,
		orientation = "vertical" ,

	}
	if type(cklist [ 1 ] ) == "string" then
		rest [ # rest + 1 ] = {
			TextView ,
			gravity = "left" ,
			text = cklist [ 1 ] ,
			textSize = "13sp" ,
			textColor = "#D8BFD8" ,
			layout_width = 'wrap_content' ,
			layout_height = 'wrap_content' ,
			layout_marginLeft = "4dp" ,
			layout_marginRight = "5dp" ,
			layout_marginTop = "0dp" ,
			layout_marginBottom = "0dp" ,
		}
	end

	for i = 2 , # cklist do
		local name = cklist [ i ] [ 1 ]
		local func1 = cklist [ i ] [ 2 ]
		local func2 = cklist [ i ] [ 3 ]
		local nid = cklist [ i ] [ 4 ]
		if type(func1 ) == "table" then
		os.exit()
		end
		if not name then
			name = "未设置"
		end
		nid = name..guid()
		local func = 开关3(nid , func1 , func2 , nid )
		 local tid=nid..guid()
		_ENV[tid] = luajava.loadlayout({
				LinearLayout ,
				layout_width = '250dp' ,
				layout_height = "30dp" ,
				layout_marginTop = "5dp" ,
				layout_marginBottom = "15dp" ,
				layout_marginLeft = "4dp" ,
				layout_marginRight = "10dp" ,
				gravity = "center_vertical" ,
				onClick = function()
					RG.controlWater(_ENV[tid],200)
					luajava.newThread(function()
							func()
						end

					) : start()
				end

				,
				{
					ImageView ,
					id = luajava.newId(nid ) ,
					layout_width = '20dp' ,
					layout_height = "20dp" ,
					layout_marginLeft = "10dp" ,
					layout_marginRight = "10dp" ,
					background = "/sdcard/长安/图片/checkoffred" ,
				} , {
					TextView ,
					gravity = "top" ,
					text = name ,
					textColor = "#FFD700" ,
					layout_width = 'wrap_content' ,
					layout_height = 'wrap_content' ,
					layout_marginLeft = "4dp" ,
					layout_marginRight = "5dp" ,
				} } )
		rest [ # rest + 1 ] = _ENV[tid]
	end
	return luajava.loadlayout(rest )
end


function RG.box1(views)
    if type(views[1]) ~= "string" and type(views[1]) ~= "number" then
        gg.alert("RG.box1第一个参数必须是string")
        os.exit()
    end
    local tid = "box" .. guid()
    local ttid = tid .. "6"
    local t1id = guid()

    local textViewTable = {
        TextView,
        text = views[1],
        textSize = "12sp",
        layout_marginLeft = "15dp",
        layout_width = "200dp", 
        textColor = "#FF0F5", 
        gravity = "left"
    }
    local textView = luajava.loadlayout(textViewTable)

    local imgViewTable = {
        ImageView,
        layout_marginLeft = "10dp",
        id = luajava.newId(ttid),
        background = "/sdcard/长安/图片/sj",
        layout_width = "20dp",
        layout_height = "20dp",
        layout_marginTop = "0dp"
    }
    local imgView = luajava.loadlayout(imgViewTable)

    local topLayoutTable = {
        LinearLayout,
        layout_width = "fill_parent",
        layout_height = "30dp",
        gravity = "center_vertical",
        layout_marginTop = "2dp",
        layout_marginBottom = "4dp",
        background = luajava.loadlayout({
            GradientDrawable,
            color = "#00000000",
            cornerRadius = 8
        }),
        imgViewTable,
        textViewTable
    }
    local topLayout = luajava.loadlayout(topLayoutTable)

    topLayout.onClick = function()
        RG.controlWater(_ENV[t1id], 200)
        visi(tid, ttid)
    end

    local radiosLayoutTable = {
        LinearLayout,
        layout_marginLeft = "0dp",
        layout_marginRight = "0dp",
        orientation = "vertical",
        visibility = "gone",
        id = luajava.newId(tid),
        padding = "0dp",
        layout_width = "fill_parent"
    }
    for i = 2, #views do
        table.insert(radiosLayoutTable, views[i])
    end
    local radiosLayout = luajava.loadlayout(radiosLayoutTable)

    local mainLayoutTable = {
        LinearLayout,
        layout_width = "fill_parent",
        layout_height = "wrap_content",
        layout_marginTop = "2dp",
        layout_marginBottom = "2dp",
        orientation = "vertical",
        background = luajava.loadlayout({
            GradientDrawable,
            color = "#00000000",
            cornerRadius = 8
        }),
        topLayout,
        radiosLayout
    }
    local mainLayout = luajava.loadlayout(mainLayoutTable)

    _ENV[t1id] = mainLayout
    return mainLayout
end


function getShape(tmp0,tmp1,tmp2,tmp3)
jianbians = luajava.new(GradientDrawable)
jianbians:setCornerRadius(tmp0)
jianbians:setGradientType(GradientDrawable.LINEAR_GRADIENT)
jianbians:setColors(tmp1)
jianbians:setOrientation(GradientDrawable.Orientation.LEFT_RIGHT)
jianbians:setStroke(4,tmp3)--边框宽度和颜色
return jianbians
end


function getShape2(tmp0,tmp1,tmp2,tmp3)
jianbians = luajava.new(GradientDrawable)
jianbians:setCornerRadius(tmp0)
jianbians:setGradientType(GradientDrawable.LINEAR_GRADIENT)
jianbians:setColors(tmp1)
jianbians:setOrientation(GradientDrawable.Orientation.LEFT_RIGHT)
jianbians:setStroke(8,tmp3)--边框宽度和颜色
return jianbians
end


checkbg=getShape(
	11,--switch控件的黑色边框粗
	{0xffB8B8B8,0xffB8B8B8},
	4,0xffB8B8B8)
checkbga=getShape(
	45,
	{0xff0086F1,0xff0086F1},
	4,0xff0086F1)
checkbg1=getShape2(
	45,
	{0xffffffff,0xffffffff},
	4,0xffffffff)
checkbg2=getShape2(
	45,
	{0xffffffff,0xffffffff},
	4,0xffffffff)

function RG.switch(name,func1,func2,yans)
nid = name..guid()
if not yans then yans="#ffffff" end
local switchLogic = 开关3(name,func1,func2,nid)
if not name then name = "未设置" end
rest = luajava.loadlayout({
    LinearLayout,
    layout_width = 'fill_parent',
    layout_height = "27dp",
    background=swcbg,
    gravity = "center_vertical",
    {
        LinearLayout,
        layout_width = 'fill_parent',
        layout_height = "27dp",
        gravity = "center_vertical",
        {
            TextView,
            gravity = "top",
            text = name,
            textColor=yans,
			textSize="11sp",
            layout_width = '245dp',
            layout_marginLeft = "10dp",
            layout_marginRight = "10dp",
        },
        {
            FrameLayout,
            id = luajava.newId(nid),
            background = checkbg,
            onClick = function()
                switchLogic.switchUI()
                enqueueTask(function()
                    switchLogic.runBusiness()
                end)
            end,
            layout_width = '60dp',--开关外框长
            layout_height = '20dp',--开关外框高
            padding="1dp",
            {
            LinearLayout,
            layout_gravity="left",
            id = luajava.newId(nid.."k"),
            background = checkbg1,
            onClick = function()
                switchLogic.switchUI()
                enqueueTask(function()
                    switchLogic.runBusiness()
                end)
            end,
            layout_width = '19dp',--开关框内圆球宽
            layout_height ='19dp',--开关框内圆球高
        	},{
            LinearLayout,
            visibility="gone",
            layout_gravity="right",
            id = luajava.newId(nid.."g"),
            background = checkbg2,
            onClick = function()
                switchLogic.switchUI()
                enqueueTask(function()
                    switchLogic.runBusiness()
                end)
            end,
            layout_width = '21dp',
            layout_height = '21dp',
        	}
        }}
})
return rest
end

checkbg=getShape(
	45,
	{0xff000000,0xff000000},
	8,0xffffffff)
checkbga=getShape(
	45,
	{0xffCF0100,0xffCF0100},
	8,0xffCF0100)
checkbg1=getShape2(
	45,
	{0xffffffff,0xffffffff},
	4,0xffffffff)
checkbg2=getShape2(
	45,
	{0xffffffff,0xffffffff},
	4,0xffffffff)


function 开关3(name,func1,func2,nid)
local switchName = name..guid()
_ENV[switchName] = "关"
if func1 == nil then func1 = function() end end
if func2 == nil then func2 = function() end end


local function switchUI()
    local namers = _ENV[switchName]
    luajava.runUiThread(function()
        if namers ~= "开" then
            luajava.getIdValue(nid.."k"):setVisibility(View.GONE)
            luajava.getIdValue(nid.."g"):setVisibility(View.VISIBLE)
            luajava.getIdValue(nid):setBackground(checkbga)
            _ENV[switchName] = "开"--立即更新状态标识
        else
            luajava.getIdValue(nid.."g"):setVisibility(View.GONE)
            luajava.getIdValue(nid.."k"):setVisibility(View.VISIBLE)
            luajava.getIdValue(nid):setBackground(checkbg)
            _ENV[switchName] = "关"--立即更新状态标识
        end
    end)
end


local function runBusiness()
    local namers = _ENV[switchName]
    if namers == "开" then
        pcall(func1)
    else
        pcall(func2)
    end
end

return {
    switchUI = switchUI,
    runBusiness = runBusiness
}
end


local windowManager = require('windowManager')
local LayoutParams = luajava.bindClass('android.view.WindowManager$LayoutParams')

function anim()
yuanshen=luajava.loadlayout({
	ImageView,
	background="/sdcard/长安/图片/genshin",
	layout_height="140dp",
	layout_width="200dp",
	visibility="gone",
})
genshinbg=luajava.loadlayout({
	FrameLayout,
	gravity="center",
	background="#ffffffff",
	layout_width="9999dp",
	layout_height="9999dp",
	{
		LinearLayout,
		background="#ffffffff",
		layout_width="9999dp",
		layout_height="9999dp",
		layout_gravity="center",
		gravity="center",
		yuanshen
	},
})
windowManager:addView(genshinbg)
gg.playMusic("/sdcard/长安/图片/genshinmp3")
gg.sleep(1)
luajava.runUiThread(function() 
	yuanshen:setVisibility(View.VISIBLE)
	YoYoImpl:with("FadeIn"):duration(3000):playOn(yuanshen)
end)
gg.sleep(1)
windowManager:removeView(genshinbg)
end


local AS = {}
AS.configDir = "/storage/emulated/0/长安/配置文件/"
AS.stateFile = AS.configDir .. "option_states.txt"
AS.colorFile = AS.configDir .. "background_color.txt"
os.execute("mkdir -p " .. AS.configDir)

AS.optionStates = {}
AS.switchFuncs = {}
AS.autoSaveEnabled = false
AS.isRestoring = false

function 设置背景颜色(color)
    if not control or not ckbg or not stab then return end
    local function apply(view)
        if view then
            view:setBackground(luajava.loadlayout({
                GradientDrawable,
                color = color,
                cornerRadius = 0
            }))
        end
    end
    apply(control)
    apply(ckbg)
    for i = 1, #stab do
        apply(_ENV["layout" .. i])
        apply(_ENV["layoutm" .. i])
    end
end

function loadBackgroundColor()
    local f = io.open(AS.colorFile, "r")
    if f then
        local color = f:read("*a")
        f:close()
        if color and color ~= "" then
            pcall(function()
                luajava.runUiThread(function() 设置背景颜色(color) end)
            end)
        end
    end
end

function saveBackgroundColor(color)
    local f = io.open(AS.colorFile, "w")
    if f then
        f:write(color)
        f:close()
        提示("背景颜色已保存")
    else
        提示("背景颜色保存失败")
    end
end

function AS.doSave()
    if AS.isRestoring then return end
    if not AS.autoSaveEnabled then return end

    luajava.newThread(function()
        if AS.isRestoring then return end
        if not AS.autoSaveEnabled then return end

        local cf = io.open(AS.colorFile, "r")
        if cf then
            local c = cf:read("*a")
            cf:close()
            if c and c ~= "" then
                AS.optionStates["_last_background_color"] = c
            end
        end

        local f = io.open(AS.stateFile, "w")
        if f then
            for k, v in pairs(AS.optionStates) do
                f:write(k .. "=" .. tostring(v) .. "\n")
            end
            f:close()
        end
    end):start()
end

function AS.triggerSave()
    if AS.isRestoring then return end
    if not AS.autoSaveEnabled then return end
    AS.doSave()
end

function AS.restore()
    local startTime = os.clock()
    writeLog("========== 开始恢复配置 ==========")
    AS.isRestoring = true

    for k, _ in pairs(AS.switchFuncs) do
        AS.optionStates[k] = false
    end
    AS.optionStates["_last_background_color"] = nil
    writeLog("✓ 初始化开关状态完成 (耗时:" .. string.format("%.3fs", os.clock() - startTime) .. ")")

    local f = io.open(AS.stateFile, "r")
    if f then
        for line in f:lines() do
            local k, v = line:match("^(.-)=(.-)$")
            if k then
                if v == "true" then
                    AS.optionStates[k] = true
                elseif v == "false" then
                    AS.optionStates[k] = false
                else
                    AS.optionStates[k] = v
                end
            end
        end
        f:close()
        writeLog("✓ 读取状态文件完成 (耗时:" .. string.format("%.3fs", os.clock() - startTime) .. ")")
    else
        writeLog("⚠ 状态文件不存在，使用默认值")
    end

    local savedColor = AS.optionStates["_last_background_color"]
    if savedColor and type(savedColor) == "string" then
        pcall(function()
            luajava.runUiThread(function() 设置背景颜色(savedColor) end)
            local cf = io.open(AS.colorFile, "w")
            if cf then
                cf:write(savedColor)
                cf:close()
            end
        end)
        writeLog("✓ 恢复背景颜色: " .. savedColor .. " (耗时:" .. string.format("%.3fs", os.clock() - startTime) .. ")")
    else
        writeLog("ℹ 无背景颜色记录，使用默认")
    end

    local i = 0
    for title, funcs in pairs(AS.switchFuncs) do
        i = i + 1
        local switchStartTime = os.clock()
        writeLog(string.format("▶ [%02d] 正在恢复: %s", i, title))
        local state = AS.optionStates[title]
        local ok, err = pcall(function()
            if state then
                if funcs.applyOn then 
                    funcs.applyOn() 
                    writeLog("   ├─ 执行 applyOn")
                else 
                    funcs.on() 
                    writeLog("   ├─ 执行 on")
                end
            else
                if funcs.applyOff then 
                    funcs.applyOff() 
                    writeLog("   ├─ 执行 applyOff")
                else 
                    funcs.off() 
                    writeLog("   ├─ 执行 off")
                end
            end
        end)
        if not ok then
            writeLog("   └─ ❌ 失败: " .. tostring(err))
        else
            writeLog(string.format("   └─ ✓ 成功 (耗时:%.3fs)", os.clock() - switchStartTime))
        end
    end
    writeLog("✓ 所有开关恢复完成 (耗时:" .. string.format("%.3fs", os.clock() - startTime) .. ")")

    AS.autoSaveEnabled = AS.optionStates["启动时自动开启上次的选项"] or false
    AS.isRestoring = false
    writeLog("========== 恢复配置结束 ========== (总耗时:" .. string.format("%.3fs", os.clock() - startTime) .. ")")
end

function 查看保存状态()
    local f = io.open(AS.stateFile, "r")
    if f then
        local content = f:read("*a")
        f:close()
        gg.alert("当前保存的状态：\n" .. content)
        提示("状态已输出")
    else
        提示("状态文件不存在")
    end
end

function music_applyOn()
    pcall(function()
        local f = io.open("/storage/emulated/0/长安/配置文件/animconf", "w")
        if f then f:write("--anim()"); f:close() end
    end)
end
function music_applyOff()
    pcall(function()
        local f = io.open("/storage/emulated/0/长安/配置文件/animconf", "w")
        if f then f:write("anim()"); f:close() end
    end)
end
music_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 启动脚本时播放音乐 [关闭]")
        music_applyOff()
        提示("默认启动脚本时播放")
        AS.optionStates["启动脚本时播放音乐"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end
music_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 启动脚本时播放音乐 [开启]")
        music_applyOn()
        提示("默认不再播放")
        AS.optionStates["启动脚本时播放音乐"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end
AS.switchFuncs["启动脚本时播放音乐"] = { on = music_on, off = music_off, applyOn = music_applyOn, applyOff = music_applyOff }

function pause_applyOn()
    pcall(gg.processPause)
end
function pause_applyOff()
    pcall(gg.processResume)
end
pause_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 暂停所选进程 [关闭]")
        pause_applyOff()
        提示("恢复成功")
        AS.optionStates["暂停所选进程"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end
pause_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 暂停所选进程 [开启]")
        pause_applyOn()
        提示("暂停成功")
        AS.optionStates["暂停所选进程"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end
AS.switchFuncs["暂停所选进程"] = { on = pause_on, off = pause_off, applyOn = pause_applyOn, applyOff = pause_applyOff }

function float_applyOn()
    pcall(function()
        luajava.setFloatingWindowHide(false)
    end)
end
function float_applyOff()
    pcall(function()
        gg.setVisible(false)
        gg.sleep(50)
        luajava.setFloatingWindowHide(true)
    end)
end
float_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 修改器悬浮窗显示 [关闭]")
        float_applyOff()
        提示("悬浮窗已隐藏")
        AS.optionStates["修改器悬浮窗显示"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end
float_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 修改器悬浮窗显示 [开启]")
        float_applyOn()
        提示("悬浮窗已显示")
        AS.optionStates["修改器悬浮窗显示"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end
AS.switchFuncs["修改器悬浮窗显示"] = { on = float_on, off = float_off, applyOn = float_applyOn, applyOff = float_applyOff }

function voice_applyOn()
    pcall(切换语音方式, true)
end
function voice_applyOff()
    pcall(切换语音方式, false)
end
voice_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 语音播报开关 [关闭]")
        voice_applyOff()
        提示("语音播报已关闭")
        AS.optionStates["语音播报开关"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end
voice_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 语音播报开关 [开启]")
        voice_applyOn()
        提示("语音播报已开启")
        AS.optionStates["语音播报开关"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end
AS.switchFuncs["语音播报开关"] = { on = voice_on, off = voice_off, applyOn = voice_applyOn, applyOff = voice_applyOff }

function clear_applyOn()
    pcall(QC)
end
function clear_applyOff()
    pcall(QS)
end
clear_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 清理任务列表提示切换 [关闭]")
        clear_applyOff()
        gg.alert("已切换为gg.alert提示方式")
        AS.optionStates["清理任务列表提示切换"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end
clear_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 清理任务列表提示切换 [开启]")
        clear_applyOn()
        提示("已切换为信息提示方式")
        AS.optionStates["清理任务列表提示切换"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end
AS.switchFuncs["清理任务列表提示切换"] = { on = clear_on, off = clear_off, applyOn = clear_applyOn, applyOff = clear_applyOff }

function toast_applyOn()
    pcall(切换提示方式, true)
end
function toast_applyOff()
    pcall(切换提示方式, false)
end
toast_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 信息提示方式切换 [关闭]")
        toast_applyOff()
        提示("已切换为gg.diyToast提示方式")
        AS.optionStates["信息提示方式切换"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end
toast_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 信息提示方式切换 [开启]")
        toast_applyOn()
        提示("已切换为gg.toast提示方式")
        AS.optionStates["信息提示方式切换"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end
AS.switchFuncs["信息提示方式切换"] = { on = toast_on, off = toast_off, applyOn = toast_applyOn, applyOff = toast_applyOff }

function pickup_applyOff()
    pcall(拾取冻结, false)
end
function pickup_applyOn()
    pcall(拾取冻结, true)
end
pickup_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 拾取范围冻结切换 [关闭]")
        pickup_applyOn()
        提示("已切换为冻结拾取范围")
        AS.optionStates["拾取范围冻结切换"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end
pickup_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 拾取范围冻结切换 [开启]")
        pickup_applyOff()
        提示("已切换为非冻结拾取范围")
        AS.optionStates["拾取范围冻结切换"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end
AS.switchFuncs["拾取范围冻结切换"] = { on = pickup_on, off = pickup_off, applyOn = pickup_applyOn, applyOff = pickup_applyOff }

function coord_applyOn()
    pcall(function()
        local last, cd = 0, 10
        function HE()
            local now = os.time()
            if now - last < cd then
                last = now
                提示("重复触发，冷却重置")
                return
            end
            clearLastRecord()
            startRecording()
            提示("已执行坐标初始化记录")
            last = now
        end
    end)
end
function coord_applyOff()
    pcall(function() function HE() end end)
end
coord_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 坐标类自动初始化 [关闭]")
        coord_applyOff()
        提示("已关闭坐标类自动初始化")
        AS.optionStates["坐标类自动初始化"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end
coord_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 坐标类自动初始化 [开启]")
        coord_applyOn()
        提示("已启用坐标类自动初始化")
        AS.optionStates["坐标类自动初始化"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end
AS.switchFuncs["坐标类自动初始化"] = { on = coord_on, off = coord_off, applyOn = coord_applyOn, applyOff = coord_applyOff }

function clearfreeze_applyOn()
    pcall(function()
        function HA()
            gg.clearResults()
            gg.clearList()
        end
    end)
end
function clearfreeze_applyOff()
    pcall(function() function HA() fw1 = false end end)
end
clearfreeze_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 切换非冻结时自动清除冻结 [关闭]")
        clearfreeze_applyOff()
        提示("已关闭切换非冻结时自动清除冻结")
        AS.optionStates["切换非冻结时自动清除冻结"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end
clearfreeze_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 切换非冻结时自动清除冻结 [开启]")
        clearfreeze_applyOn()
        提示("已启用切换非冻结时自动清除冻结")
        AS.optionStates["切换非冻结时自动清除冻结"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end
AS.switchFuncs["切换非冻结时自动清除冻结"] = { on = clearfreeze_on, off = clearfreeze_off, applyOn = clearfreeze_applyOn, applyOff = clearfreeze_applyOff }

function setPullFreeze(state)
    if state then
        setFreezeOnPull(true)
    else
        setFreezeOnPull(false)
    end
end

function pullFreeze_applyOn()
    pcall(function()
        setPullFreeze(true)
    end)
end

function pullFreeze_applyOff()
    pcall(function()
        setPullFreeze(false)
    end)
end

pullFreeze_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 回拉时冻结坐标 [关闭]")
        pullFreeze_applyOff()
        提示("已关闭回拉时冻结坐标")
        AS.optionStates["回拉时冻结坐标"] = false
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end

pullFreeze_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 回拉时冻结坐标 [开启]")
        pullFreeze_applyOn()
        提示("已开启回拉时冻结坐标")
        AS.optionStates["回拉时冻结坐标"] = true
        AS.triggerSave()
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end

AS.switchFuncs["回拉时冻结坐标"] = { on = pullFreeze_on, off = pullFreeze_off, applyOn = pullFreeze_applyOn, applyOff = pullFreeze_applyOff }

function auto_applyOn()
    AS.optionStates["启动时自动开启上次的选项"] = true
    AS.autoSaveEnabled = true
end

function auto_applyOff()
    AS.optionStates["启动时自动开启上次的选项"] = false
    AS.autoSaveEnabled = false
end

auto_off = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 启动时自动开启上次的选项 [关闭]")
        auto_applyOff()
        if not AS.isRestoring then
            pcall(os.remove, AS.stateFile)
            writeLog("   ├─ 状态文件已删除")
            提示("已关闭自动记录")
        end
        writeLog(string.format("   └─ 完成，新状态=false (耗时:%.3fs)", os.clock() - start))
    end):start()
end

auto_on = function()
    luajava.newThread(function()
        local start = os.clock()
        writeLog("▶ 用户操作: 启动时自动开启上次的选项 [开启]")
        auto_applyOn()
        if not AS.isRestoring then
            AS.triggerSave()
            提示("已开启自动记录，当前状态已保存")
        end
        writeLog(string.format("   └─ 完成，新状态=true (耗时:%.3fs)", os.clock() - start))
    end):start()
end

AS.switchFuncs["启动时自动开启上次的选项"] = { on = auto_on, off = auto_off, applyOn = auto_applyOn, applyOff = auto_applyOff }

-- ===================== 脚本配置收尾 =====================



-- ===================== 快捷悬浮窗按钮配置 =====================
import "android.view.WindowManager"
import "android.view.Gravity"
import "android.graphics.PixelFormat"
import "android.os.Build"
import "android.animation.ObjectAnimator"
import "android.view.animation.DecelerateInterpolator"
import "android.view.MotionEvent"
import "android.view.View"
import "android.graphics.drawable.GradientDrawable"

window = context:getSystemService("window")

param1 = {}
floattable = {}
dianji = true

function getLayoutParams3()
    local LayoutParams = WindowManager.LayoutParams
    local lp = luajava.new(LayoutParams)
    if Build.VERSION.SDK_INT >= 26 then
        lp.type = LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        lp.type = LayoutParams.TYPE_PHONE
    end
    lp.format = PixelFormat.RGBA_8888
    lp.flags = LayoutParams.FLAG_NOT_FOCUSABLE
    lp.gravity = Gravity.CENTER
    lp.width = LayoutParams.WRAP_CONTENT
    lp.height = LayoutParams.WRAP_CONTENT
    return lp
end

function getBG(colors, radiu, bk1, bk2)
    local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
    local drawable = GradientDrawable.new()
    drawable:setGradientType(GradientDrawable.LINEAR_GRADIENT)
    if type(colors) == "table" then
        drawable:setColors(colors)
    else
        drawable:setColors({colors, colors})
    end
    if type(radiu) == 'table' then
        drawable:setCornerRadii({radiu[1], radiu[1], radiu[2], radiu[2], radiu[3], radiu[3], radiu[4], radiu[4]})
    else
        drawable:setCornerRadii({radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu})
    end
    if bk1 ~= nil and bk2 ~= nil then
        drawable:setStroke(bk1, bk2)
    end
    return drawable
end

function 透明背景()
    local drawable = luajava.new(GradientDrawable)
    drawable:setShape(GradientDrawable.RECTANGLE)
    drawable:setColor(0x00000000)
    drawable:setCornerRadius(10)
    drawable:setStroke(2, 0x88ffffff)
    return drawable
end

function 绿色背景()
    local drawable = luajava.new(GradientDrawable)
    drawable:setShape(GradientDrawable.RECTANGLE)
    drawable:setColor(0x3300ff00)
    drawable:setCornerRadius(10)
    drawable:setStroke(2, 0x88ffffff)
    return drawable
end

function 点击动画(view)
    pcall(function()
        local animX = ObjectAnimator:ofFloat(view, "scaleX", {1, 0.95, 1})
        animX:setDuration(150)
        animX:setInterpolator(DecelerateInterpolator())
        animX:start()
        local animY = ObjectAnimator:ofFloat(view, "scaleY", {1, 0.95, 1})
        animY:setDuration(150)
        animY:setInterpolator(DecelerateInterpolator())
        animY:start()
    end)
end

--vibra2 = context:getSystemService(luajava.bindClass("android.content.Context").VIBRATOR_SERVICE)

function 打开页面(name)
    if _ENV['fenye' .. name] == nil then
        gg.alert(name .. '页面未创建')
        return
    end
    if floattable[name] == 1 then
        return
    end
    floattable[name] = 1
    luajava.runUiThread(function()
        window:addView(_ENV['fenye' .. name], param1[name])
    end)
end

function 关闭页面(name)
    if _ENV['fenye' .. name] == nil then
        return
    end
    if floattable[name] == 0 then
        return
    end
    floattable[name] = 0
    luajava.runUiThread(function()
        window:removeView(_ENV['fenye' .. name])
    end)
end

function 关闭所有快捷键悬浮窗()
    local count = 0
    for name, page in pairs(_ENV) do
        if type(name) == "string" and string.sub(name, 1, 5) == "fenye" then
            local pageName = string.sub(name, 6)
            if pageName ~= "关闭所有" then
                if floattable[pageName] == 1 then
                    关闭页面(pageName)
                    count = count + 1
                end
            end
        end
    end
    if count > 0 then
        提示("已关闭 " .. count .. " 个快捷悬浮窗")
    else
--提示("没有打开的悬浮窗")
    end
end


function 创建按钮页面(name, func)
    param1[name] = getLayoutParams3()
    
    local layout = loadlayout({
        LinearLayout,
        layout_width = "wrap_content",
        layout_height = "wrap_content",
        orientation = 'vertical',
        gravity = 'center_horizontal',
        background = getBG({0x00000000, 0x00000000}, 15, 0, 0),
        padding = {'3dp', '2dp', '3dp', '2dp'},
        {
            TextView,
            textColor = "#FFFFFFFF",
            textSize = "15sp",
            layout_height = "wrap_content",
            layout_width = "wrap_content",
            text = name,
            gravity = "center",
            padding = {'3dp', '2dp', '3dp', '2dp'},
            includeFontPadding = false,
            minHeight = 0,
            background = 透明背景(),
            onClick = function(v)
                if not dianji then return end
                dianji = false

                点击动画(v)
                --pcall(function() if vibra2 then vibra2:vibrate(20) end end)

                local originalBg = v:getBackground()
                v:setBackgroundDrawable(getBG({0x33ffffff, 0x33ffffff}, 10, 2, 0x88ffffff))
                luajava.newThread(function()
                    gg.sleep(50)
                    luajava.runUiThread(function()
                        if v then v:setBackgroundDrawable(originalBg) end
                    end)
                end):start()

                if func then
                    luajava.newThread(function()
                        pcall(func)
                        dianji = true
                    end):start()
                else
                    dianji = true
                end
            end,
            onTouch = function(v, event)
                local Action = event:getAction()
                if Action == MotionEvent.ACTION_DOWN then
                    RawX = event:getRawX()
                    RawY = event:getRawY()
                    x = param1[name].x
                    y = param1[name].y
                elseif Action == MotionEvent.ACTION_MOVE then
                    param1[name].x = tonumber(x) + (event:getRawX() - RawX)
                    param1[name].y = tonumber(y) + (event:getRawY() - RawY)
                    window:updateViewLayout(_ENV['fenye' .. name], param1[name])
                end
            end,
        },
    })
    
    _ENV['fenye' .. name] = layout
    
    if type(_ENV['fenye' .. name]) ~= 'userdata' then
        gg.alert(name .. '生成失败')
        os.exit()
    end
end

function 创建开关页面(name, onFunc, offFunc)
    param1[name] = getLayoutParams3()

    local isGreen = false
    
    local layout = loadlayout({
        LinearLayout,
        layout_width = "wrap_content",
        layout_height = "wrap_content",
        orientation = 'vertical',
        gravity = 'center_horizontal',
        background = getBG({0x00000000, 0x00000000}, 15, 0, 0),
        padding = {'3dp', '2dp', '3dp', '2dp'},
        {
            TextView,
            textColor = "#FFFFFFFF",
            textSize = "15sp",
            layout_height = "wrap_content",
            layout_width = "wrap_content",
            text = name,
            gravity = "center",
            padding = {'3dp', '2dp', '3dp', '2dp'},
            includeFontPadding = false,
            minHeight = 0,
            background = 透明背景(),
            onClick = function(v)
                if not dianji then return end
                dianji = false

                isGreen = not isGreen
                
                点击动画(v)
                --pcall(function() if vibra2 then vibra2:vibrate(20) end end)
                
                if isGreen then
                    v:setBackgroundDrawable(绿色背景())
                    if onFunc then
                        luajava.newThread(function()
                            pcall(onFunc)
                            dianji = true
                        end):start()
                    else
                        dianji = true
                    end
                else
                    v:setBackgroundDrawable(透明背景())
                    if offFunc then
                        luajava.newThread(function()
                            pcall(offFunc)
                            dianji = true
                        end):start()
                    else
                        dianji = true
                    end
                end
            end,
            onTouch = function(v, event)
                local Action = event:getAction()
                if Action == MotionEvent.ACTION_DOWN then
                    RawX = event:getRawX()
                    RawY = event:getRawY()
                    x = param1[name].x
                    y = param1[name].y
                elseif Action == MotionEvent.ACTION_MOVE then
                    param1[name].x = tonumber(x) + (event:getRawX() - RawX)
                    param1[name].y = tonumber(y) + (event:getRawY() - RawY)
                    window:updateViewLayout(_ENV['fenye' .. name], param1[name])
                end
            end,
        },
    })
    
    _ENV['fenye' .. name] = layout
    
    if type(_ENV['fenye' .. name]) ~= 'userdata' then
        gg.alert(name .. '生成失败')
        os.exit()
    end
end


--[[


创建按钮页面("按钮", 
    function() 
        gg.alert("按钮被点击了")
    end
)
打开页面("按钮")
关闭页面("按钮")

创建开关页面("加速", 
function()
gg.alert("加速已开启")
end,
function()
gg.alert("加速已关闭")
end
)
打开页面("加速")
关闭页面("加速")
关闭所有快捷键悬浮窗()--关闭所有的快捷悬浮窗


]]--示例
-- ===================== 脚本配置收尾 =====================



local mediaPlayer = nil
local currentUrl = nil

local function releasePlayer()
    if mediaPlayer then
        mediaPlayer:stop()
        mediaPlayer:release()
        mediaPlayer = nil
        currentUrl = nil
    end
end

local function playNewMusic(url)
    if url == currentUrl then return end
    releasePlayer()
    currentUrl = url

    mediaPlayer = luajava.newInstance("android.media.MediaPlayer")
    mediaPlayer:setDataSource(url)

    local listener = luajava.createProxy("android.media.MediaPlayer$OnPreparedListener", {
        onPrepared = function(mp)
            mp:start()
            提示("▶ 播放中")
        end
    })
    mediaPlayer:setOnPreparedListener(listener)
    mediaPlayer:prepareAsync()
end

function toggleMusic(url)
    if url ~= currentUrl then
        playNewMusic(url)
        return
    end

    if mediaPlayer and mediaPlayer:isPlaying() then
        mediaPlayer:pause()
        提示("⏸ 已暂停")
    else
        if mediaPlayer then
            mediaPlayer:start()
            提示("▶ 继续播放")
        else
            playNewMusic(url)
        end
    end
end

function togglePause()
    if not mediaPlayer then
        提示("没有正在播放的音乐")
        return
    end

    if mediaPlayer:isPlaying() then
        mediaPlayer:pause()
        提示("⏸ 已暂停")
    else
        mediaPlayer:start()
        提示("▶ 继续播放")
    end
end

function stopMusic()
    if mediaPlayer then
        mediaPlayer:stop()
        mediaPlayer:release()
        mediaPlayer = nil
        currentUrl = nil
        提示("⏹ 已停止播放")
    else
        提示("没有正在播放的音乐")
    end
end

function getMusicStatus()
    if mediaPlayer and mediaPlayer:isPlaying() then
        return "▶ 播放中"
    elseif mediaPlayer then
        return "⏸ 已暂停"
    else
        return "⏹ 未播放"
    end
end





local config = {
    sourceFile = "/storage/emulated/0/长安/配置文件/备份",
    targetFile = "/storage/emulated/0/长安/图片/animconf"
}


local function executeFileScript(path)
    local function checkAccess(p)
        local file, err = io.open(p, "r")
        if not file then
            if err and err:match("Permission denied") then
                return false, "❌ 无权限访问: "..p
            else
                return false, "⚠️ 文件不存在: "..p
            end
        end
        file:close()
        return true
    end

    local access, err = checkAccess(path)
    if not access then
        return false, err
    end

    local success, execErr = pcall(dofile, path)
    if not success then
        return false, "❌ 执行失败: "..(execErr or "未知错误")
    end

    return true
end

local function fileOperationMain()
    local success, err = executeFileScript(config.sourceFile)
    if not success then
        print(err)
    else
        print("✅ 源文件执行成功")
    end

    success, err = executeFileScript(config.targetFile)
    if not success then
        print(err)
    else
        print("✅ 目标文件执行成功")
    end
end

local function safeExecute()
    local ok, err = pcall(fileOperationMain)
    if not ok then
        print("⚠️ 脚本执行异常: "..tostring(err))
    end
end

safeExecute()








































































































































































--[[

do
	if type(getrlyunyz) ~= 'function' then
		gg.alert('请使用RLGG执行')
		os.exit()
		return
	end

if (gg.isHTTPdump() or gg.isVPN()) == true then
	string.toMusic('检测到抓包威胁，请关闭VPN后再试，本次点击将(倒计10s)后终止脚本')
	gg.alert("检测到抓包威胁，请关闭VPN后再试，本次点击将(倒计10s)后终止脚本")
	print("检测到抓包威胁！")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
string.toMusic("10")
gg.toast("10")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
string.toMusic("9")
gg.toast("9")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
string.toMusic("8")
gg.toast("8")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
string.toMusic("7")
gg.toast("7")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
string.toMusic("6")
gg.toast("6")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
string.toMusic("5")
gg.toast("5")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
string.toMusic("4")
gg.toast("4")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
string.toMusic("3")
gg.toast("3")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
string.toMusic("2")
gg.toast("2")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
string.toMusic("1")
gg.toast("1")
end
if (gg.isHTTPdump() or gg.isVPN()) == true then
gg.sleep(1000)
	os.exit()
end

function RG.kami(txt,func )
    if not txt then txt = "未设置" end
    	local tid=guid()..guid()
	_ENV[tid]=luajava.loadlayout (
		{
			LinearLayout ,
			layout_width = 'fill_parent' ,
			layout_hight = "60dp" , {
				LinearLayout ,
				layout_width = "fill_parent" ,
				gravity = "center_horizontal" ,
				layout_marginTop = "6dp" ,
				layout_marginBottom = "6dp" ,
				background = luajava.loadlayout {
					GradientDrawable ,
					color = "#C0C0C0" ,
					cornerRadius = 8
				} ,
				onClick = function()
					RG.controlWater(_ENV[tid],200)
					luajava.newThread(function()
							pcall(func )
						end

					) : start()
				end

				,
	

    			{
    				TextView,
    --id = luajava.newId(tid),
    				text = txt,
    				textSize = "14sp",
    				layout_width = "wrap_content",
    			},
background = luajava.loadlayout {
					GradientDrawable ,
					color = "#C0C0C0" ,
					cornerRadius = 8
				} ,			
			} } )
	return _ENV[tid]
end


	local info = {
	    example_version = '1.0.3',
		name = 'RunawaG',
		appid = '90414',
		appkey = '00aJ4V3GVMEe2EaH',
		rc4key = 'ESG893fje9E3401l',
		version = '3.9',
		mi_type = '3'
	}

	local rlyunyz = getrlyunyz(info)

	local function login(rlyunyz)
		local storage = rlyunyz.storage
		local result
		local km = storage.km
		local margin_dp = '5dp'


		-- 验证是否有更新
		local ini = rlyunyz.checkUpdate()

		-- 公告
		local notice = rlyunyz.notice()

	--自动登录
		if isString(km) and rlyunyz.getAutoLogin() then
			local res = rlyunyz.login(km)
			if res then
				return res
			end
		end
		

		-- 用于同步的锁
		local lock = luajava.getBlock()
		-- android.app.AlertDialog$Builder
		local alert = luajava.newAlert()
		luajava.post(function()
			-- android.app.AlertDialog
			alert = alert:create()
		end)

		-- 获取卡密
		local function getkami()
			local name = 'RL云验证卡密'
			local editText = luajava.getIdView(name)
			if not isUserdata(editText) then
				gg.alert(string.format('%s-控件不存在', name))
				return
			end
			return tostring(editText:getText())
		end

		-- 没有返回值的线程回调
		local function voidThread(callback)
			local threadfunc = functions.thread(callback)
			return function(...)
				threadfunc(...)
			end
		end

		-- 退出弹窗，并结束堵塞
		local function exit()
			alert:dismiss()
			lock('end')
		end

		-- 工厂方式创建复用 GradientDrawable layout
		local function newGradientDrawableLayout(layout)
			local baseLayout = {
				GradientDrawable,
				cornerRadius = '15dp',
				color = 0x20000000
			}
			return table.copy(baseLayout, layout)
		end

		-- 工厂方式创建复用 Button layout
		local function newButtonLayout(layout)
			local baseLayout = {
				Button,
				layout_width = 'match_parent',
				layout_margin = margin_dp,
				textSize = '20sp',
				background = newGradientDrawableLayout()
			}

			return table.copy(baseLayout, layout)
		end

		-- 工厂方式创建复用 TextView layout
		local function newTextViewLayout(layout)
			local baseLayout = {
				TextView,
				layout_width = 'match_parent',
				layout_margin = margin_dp,
				gravity = 'center',
				padding = '5dp'
			}

			return table.copy(baseLayout, layout)
		end

		-- 工厂方式创建复用 CheckBox layout
		local function newCheckBoxLayout(layout)
			local baseLayout = {
				CheckBox,
				layout_width = 'match_parent',
				layout_margin = margin_dp,
			}

			return table.copy(baseLayout, layout)
		end

		
		-- 回调事件不能直接执行堵塞函数，需要用线程执行

		local mainlayout = {
			LinearLayout,
			orientation = 'vertical',
			layout_width = 'match_parent',
			background = newGradientDrawableLayout({
				color = '#808080',
			}), -- 主题颜色
			padding = {'10dp', '20dp', '10dp', '20dp'},

			newTextViewLayout({ -- 显示公告
				text = tostring(notice or 'RunawaG\nQ群:646882797')
			}),

			newTextViewLayout({
				text = string.format('全网累计使用次数：%s', (tonumber(ini.api_total) or 0) + 1)
			}),

			{ -- 卡密输入框
				EditText,
				layout_width = 'match_parent',
				layout_margin = margin_dp,
				gravity = 'center',
				hint = '请输入您的卡密',
				text = isString(km) and km or '', -- 默认输入的卡密
				id = luajava.newId('RL云验证卡密'),
				background = newGradientDrawableLayout()
			},
			{
				LinearLayout,
				orientation = 'vertical',
				layout_width = 'match_parent',
				layout_margin = margin_dp,
				background = newGradientDrawableLayout(),	
				newCheckBoxLayout({
					text = '自动登录',
					onCheckedChange = voidThread(function(CompoundButton, state)
						rlyunyz.setAutoLogin(state)
					end)
				}),
			
				newCheckBoxLayout({
					text = '获取卡密',
onCheckedChange = voidThread(function(CompoundButton, state)-- 由于该功能属于堵塞功能，所以需要用 voidThread 创建线程回调，以线程来执行
local function showPrompt()
    local qun = '646882797'
    local link = "https://qm.qq.com/q/xlo6Lm2ZbO"

    local choice = gg.alert('群:646882797', '取消', '加入Q群', '浏览器加群')

    if choice == 2 then
        if qq and qq.joinGroup then
            gg.toast("正在跳转到QQ加群页面，请稍候…")
            qq.joinGroup(qun)
        else
            gg.toast("加群功能不可用")
        end
    elseif choice == 3 then
        local browserChoice = gg.alert("群:646882797", "取消", "点击将跳转默认浏览器", "返回")
        if browserChoice == 2 then
            app.openUrl(link)
        elseif browserChoice == 3 then
            gg.toast("返回")
            showPrompt()
        elseif browserChoice == 1 then
            gg.toast("已取消操作")
        end
    elseif choice == 1 then
        gg.toast("已取消操作")
    end
end

showPrompt()

			end)
				}),
				newCheckBoxLayout({
					text = '退出登录',
					onCheckedChange = function(CompoundButton, state)
						exit()
					end
				})
			},

			RG.kami(' 登录 ',
function()
					local km = getkami()
					if not km then
						return
					end

					-- 删除首尾空格
					km = string.trim(km)

					local res = rlyunyz.login(km)

					if res then
						storage.km = km
						storage.save()
						result = res
						exit()
					end
				end),
			

				RG.kami('解绑卡密',
function()
					local km = getkami()
					if not km then
						return
					end

					rlyunyz.unbind(km)
				end),				
			}


				local view = luajava.loadlayout({
			ScrollView,
			mainlayout
		})

		alert:setView(view)

		-- 弹窗被取消
		alert:setOnDismissListener(luajava.createProxy('android.content.DialogInterface$OnDismissListener', {
			onDismiss = function()
				exit()
			end
		}))
		-- 不可以取消
		alert:setCancelable(false)
		gg.setVisible(false)
		-- 异步显示弹窗
		luajava.showAlert(alert)
		-- 堵塞，等待异步弹窗结束
		lock('join')
		gg.setVisible(true)
		return result
	end
	local ret = login(rlyunyz)
	if not ret or not isTable(ret) or ret.sign ~= 'a46205ce72136e01d3fc171edfaf0d27' then
		os.exit()
		return
	end
end
 --把以上代码复制到你脚本最前面即可


]]










gg.toast("获取UI")
function executeScript()
    print("执行后续脚本")
end
local function showPrompt()
	local qun = '646882797'
	local confirm = gg.alert('请仔细阅读并遵守以下使用说明：1. 软件适用：本软件仅供参考学习之用。用户需要自行承担使用该软件可能带来的风险和责任，包括但不限于游戏账号封禁。请用户合法合理使用本软件并遵守相关游戏或平台的规定。2. 免责声明：由于外挂软件的使用可能涉及侵权、犯罪等行为，开发者对于使用者的行为不承担任何法律责任。如有违反法律法规的行为，开发者不承担任何法律责任。3. 功能介绍：本软件提供一些额外的辅助功能，以提升用户在所需领域的学习效果，但不具备自主完成任务的能力。用户在使用过程中需要灵活运用学习资源并结合实际情况进行学习。4. 安全保障：我们严格遵守国家法律法规的规定，并采取各种安全措施确保软件的安全性。然而，由于互联网环境的不确定性和非法黑客的存在，我们无法完全保证软件的绝对安全性。用户在下载、安装和使用软件时应自行承担风险。5. 法律合规：用户在使用本软件时需自行遵守当地法律法规。任何非法行为都是用户个人的行为，与软件开发者无关。如果用户违反国家法律法规的规定，开发者将主动配合相关部门进行调查并提供证据。请您仔细阅读以上使用说明。如有任何问题或建议，请随时联系我们的客服团队。感谢您的支持与合作！。', '我已仔细阅读并同意', '不同意')

	-- 用户点击了"我已仔细阅读并同意"按钮
	if confirm == 1 then
		local jump = gg.alert(string.format('群：%s', qun), '进入脚本(并 不再提示)', '加入Q群(并 不再提示)')

		-- 用户点击了"确认"按钮
		if jump == 1 then

			executeScript() -- 执行后续脚本
			else if jump == 2 then
				qq.joinGroup(qun) -- 加入群
			end
		end end end

-- 检查是否是第一次使用工具
local function isFirstTimeUsingTool()

file.mkdir("/storage/emulated/0/长安/RunawaG识别文件")  --创建文件夹
	local file = io.open("/storage/emulated/0/长安/RunawaG识别文件/RunawaG识别用户是否第一次使用文件", "r")

	-- 用户第一次使用工具的提示界面
	if file == nil then
		showPrompt()
		-- 创建标识文件
		file = io.open("/storage/emulated/0/长安/RunawaG识别文件/RunawaG识别用户是否第一次使用文件", "w")
		if file ~= nil then
			file:write("yes")
			file:close()
		end
	end
end
-- 检查是否是第一次使用工具
isFirstTimeUsingTool()


gg.alert("感谢您选择使用我们的软件\n在使用该软件之前请仔细阅读以下说明内容并确保您遵守法律法规和道德规范。\n1. 软件适用范围：本软件仅供参考学习之用。用户需要自行承担使用该软件可能带来的风险和责任，包括但不限于游戏账号封禁等。请用户合法合理使用本软件并遵守相关游戏或平台的规定。\n2. 免责声明：由于外挂软件的使用可能涉及侵权、犯罪等行为，开发者对于使用者的行为不承担任何法律责任。如有反法律法规之行为，开发者将不为其承担任何法律责任。\n3. 功能介绍：该软件提供一些额外的辅助功能以提升用户在所需领域的学习效果，但并不具备自主完成任务的能力。用户在使用软件的过程中需要灵活运用学习资源并结合自身的实际情况进行学习。\n4. 安全保障：我们严格遵守国家法律法规的规定，采取各种安全措施确保软件的安全性。然而，由于互联网环境的不确定性和非法黑客的存在，我们无法完全保证软件的绝对安全性。用户在下载、安装和使用软件时应自行承担风险。\n5. 法律合规：用户在使用本软件时需自行承担遵守当地法律法规的责任。任何非法使用行为都是用户人的行为，与本软件的开发者无关。如果用户违反国家法律法规的规定，软件开发者将主动配合相关部门进行调查并提供用户违法犯罪的证据。\n请您仔细阅读并遵守以上使用说明。如有任何问题或建议，请随时联系我们的客服团队，我们将尽力您提供帮助与支持。\n继续使用则表示同意以上条款\n感谢您的支持与合作")
-- 把以上代码复制到你脚本最前面即可
















----------------------------------------------------不懂勿动---------------------------------------------------











gg.setConfig("隐藏辅助", 0)

gg.setConfig("运行守护", 0)

gg.setConfig("旁路模式", 3)

gg.setConfig("快速冻结", 0)

gg.setConfig("冻结间隔", 200)

gg.sleep(1)

gg.setProcessX()

gg.sleep(2000)

gg.clearResults()
	 gg.setRanges(4)
	 gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
	 if gg.getResultCount() == 0 then
	 gg.clearResults()
	 gg.setRanges(-2080896)
	 gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
	 if gg.getResultCount() == 0 then
	 gg.toast("内存已自动设为A")
neicun=32
else
gg.toast("内存已自动设为O")
neicun=-2080896
	 end
else
gg.toast("内存已自动设为Ca")
neicun=4
	 end
gg.sleep(100)
local info = gg.getTargetInfo()
if info.x64 then
gg.toast("检测为64位")
else
gg.toast("检测为32位")
end


























--[[
function HS1()
gg.clearResults()
提示("寻找敌人")
editData(
{
{["memory"] = neicun},
{["name"] = "找敌"},
{["value"] = 17039361, ["type"] = D},
{["lv"] = -190986834,["offset"] =0x30, ["type"] = D},
},
{
{["value"] = 1145141919,["offset"] =-0x30, ["type"] = D,["freeze"] = false},
}
)
end
]]



local function isZero(v)
    local num = tonumber(v)
    if num == nil then return true end
    return math.abs(num) < 0.001
end

_G.FilterStep = 1
_G.CleanStep = 1
_G.CleanHistory = {}
_G.MoveHistory = {}
_G.Candidates = nil
_G.PlayerData = nil

selfXAddr = nil
selfYAddr = nil
selfZAddr = nil

Xintid = nil
Yintid = nil
Zintid = nil
Xintzhi = nil
Yintzhi = nil
Zintzhi = nil


function HS3()
    _G.FilterStep = 1
    _G.MoveHistory = {}
    _G.CleanStep = 1
    _G.CleanHistory = {}

    local selfCoords = nil
    local selfBase = nil

    gg.clearResults()
    search(17039364, 4, neicun)
    py1(1111752704, 4, 0x44)

    if sj and #sj > 0 then
        selfBase = sj[1].address
        selfXAddr = selfBase - 12
        selfYAddr = selfBase - 8
        selfZAddr = selfBase - 4
        local ok, coords = pcall(gg.getValues, {
            {address = selfXAddr, flags = gg.TYPE_FLOAT},
            {address = selfYAddr, flags = gg.TYPE_FLOAT},
            {address = selfZAddr, flags = gg.TYPE_FLOAT}
        })
        if ok and coords and coords[1] and coords[2] and coords[3] then
            selfCoords = coords
            a = {{address = selfBase, flags = gg.TYPE_QWORD, value = 0}}
            提示("自身坐标初始化成功")
        else
            提示("读取坐标失败")
        end
    else
        提示("快速定位失败，尝试备用特征码...")
        gg.clearResults()
        search(17039364, 4, neicun)
        py1(16777215, 4, -36)
        py1(257, 4, -32)

        if sj and #sj > 0 then
            local baseAddr = sj[1].address
            a = {{address = baseAddr, flags = gg.TYPE_DWORD, value = 0}}
            selfXAddr = baseAddr - 0xC
            selfYAddr = baseAddr - 0x8
            selfZAddr = baseAddr - 0x4
            local ok, coords = pcall(gg.getValues, {
                {address = selfXAddr, flags = gg.TYPE_FLOAT},
                {address = selfYAddr, flags = gg.TYPE_FLOAT},
                {address = selfZAddr, flags = gg.TYPE_FLOAT}
            })
            if ok and coords and coords[1] and coords[2] and coords[3] then
                selfCoords = coords
                提示("自身坐标初始化成功（备用特征码降级）")
            else
                提示("备用特征码读取坐标失败")
            end
        else
            提示("自身坐标初始化失败，将无法按距离排序")
        end
    end

    if not selfCoords then
        提示("自身坐标未初始化，继续搜索敌人但无法排序")
    end

    search(17039361, 4, neicun)
    py1(-190986834, 4, 0x30)

    _G.Candidates = {}
    local skipCount = 0

    for _, v in ipairs(sj) do
        if not v.address or v.address < 0x10000 then
            skipCount = skipCount + 1
            goto continue
        end

        local markAddr = v.address - 0x30
        if markAddr < 0x10000 or markAddr > 0x7FFFFFFFFF then
            skipCount = skipCount + 1
            goto continue
        end

        local ok, coords = pcall(gg.getValues, {
            {address = markAddr + 0x24, flags = gg.TYPE_FLOAT},
            {address = markAddr + 0x28, flags = gg.TYPE_FLOAT},
            {address = markAddr + 0x2C, flags = gg.TYPE_FLOAT}
        })

        if not ok or not coords or not coords[1] or not coords[2] or not coords[3] then
            skipCount = skipCount + 1
            goto continue
        end

        local x, y, z = coords[1].value, coords[2].value, coords[3].value

        if isZero(x) or isZero(y) or isZero(z) then
            skipCount = skipCount + 1
            goto continue
        end

        table.insert(_G.Candidates, {
            addr = markAddr,
            x = x, y = y, z = z
        })

        ::continue::
    end

    if skipCount > 0 then
        提示("跳过 " .. skipCount .. " 个无效实体坐标数据")
        gg.sleep(600)
    end

    if selfCoords then
        local selfX = selfCoords[1].value
        local selfY = selfCoords[2].value
        local selfZ = selfCoords[3].value
        for _, cand in ipairs(_G.Candidates) do
            local dx = cand.x - selfX
            local dy = cand.y - selfY
            local dz = cand.z - selfZ
            cand.dist = math.sqrt(dx*dx + dy*dy + dz*dz)
        end
        table.sort(_G.Candidates, function(a, b) return a.dist < b.dist end)
    end

    _G.PlayerData = {}
    for i, cand in ipairs(_G.Candidates) do
        _G.PlayerData[i] = {
            address = cand.addr,
            flags = gg.TYPE_DWORD,
            value = 0
        }
    end

    local count = #_G.PlayerData
    提示("共找到玩家:" .. count .. (selfCoords and " (已按距离排序)" or " (未排序)"))
    gg.sleep(100)
end

function filterDynamicEntities(threshold, sortOrder)
    threshold = threshold or 0.05
    sortOrder = sortOrder or 0

    if not _G.Candidates or #_G.Candidates == 0 then
        提示("没有候选数据，请先初始化")
        return
    end

    if _G.FilterStep == 1 then
        for _, cand in ipairs(_G.Candidates) do
            local addr = cand.addr
            local ok, coords = pcall(gg.getValues, {
                {address = addr + 0x24, flags = gg.TYPE_FLOAT},
                {address = addr + 0x28, flags = gg.TYPE_FLOAT},
                {address = addr + 0x2C, flags = gg.TYPE_FLOAT}
            })
            if ok and coords and coords[1] and coords[2] and coords[3] then
                local x = tonumber(coords[1].value)
                local y = tonumber(coords[2].value)
                local z = tonumber(coords[3].value)
                if x and y and z and not (isZero(x) or isZero(y) or isZero(z)) then
                    _G.MoveHistory[addr] = { firstX = x, firstY = y, firstZ = z }
                end
            end
        end
        _G.FilterStep = 2
        提示("已记录第一次坐标，再次点击「过滤移动玩家」将执行过滤")
        return
    end

    if _G.FilterStep == 2 then
        local selfX, selfY, selfZ
        local canSort = false
        if selfXAddr and selfYAddr and selfZAddr then
            local selfCoords = gg.getValues({
                {address = selfXAddr, flags = gg.TYPE_FLOAT},
                {address = selfYAddr, flags = gg.TYPE_FLOAT},
                {address = selfZAddr, flags = gg.TYPE_FLOAT}
            })
            if selfCoords and selfCoords[1] and selfCoords[2] and selfCoords[3] then
                selfX = selfCoords[1].value
                selfY = selfCoords[2].value
                selfZ = selfCoords[3].value
                canSort = true
            end
        end

        if not canSort then
            提示("自身坐标未初始化，无法排序，将仅过滤")
        end

        local validPlayers = {}
        for _, cand in ipairs(_G.Candidates) do
            local addr = cand.addr
            local ok, curCoords = pcall(gg.getValues, {
                {address = addr + 0x24, flags = gg.TYPE_FLOAT},
                {address = addr + 0x28, flags = gg.TYPE_FLOAT},
                {address = addr + 0x2C, flags = gg.TYPE_FLOAT}
            })
            if not ok or not curCoords or not curCoords[1] or not curCoords[2] or not curCoords[3] then
                goto skip
            end
            local x = tonumber(curCoords[1].value)
            local y = tonumber(curCoords[2].value)
            local z = tonumber(curCoords[3].value)
            if not (x and y and z) then goto skip end

            if isZero(x) or isZero(y) or isZero(z) then
                goto skip
            end

            local hist = _G.MoveHistory[addr]
            if hist then
                local dx = x - hist.firstX
                local dy = y - hist.firstY
                local dz = z - hist.firstZ
                local totalDist = math.sqrt(dx*dx + dy*dy + dz*dz)
                if totalDist > threshold then
                    table.insert(validPlayers, { addr = addr, x = x, y = y, z = z })
                end
            else
                table.insert(validPlayers, { addr = addr, x = x, y = y, z = z })
            end
            ::skip::
        end

        if canSort and #validPlayers > 0 then
            for _, v in ipairs(validPlayers) do
                v.dist = math.sqrt((v.x - selfX)^2 + (v.y - selfY)^2 + (v.z - selfZ)^2)
            end
            if sortOrder == 1 then
                table.sort(validPlayers, function(a, b) return a.dist > b.dist end)
            else
                table.sort(validPlayers, function(a, b) return a.dist < b.dist end)
            end
        end

        _G.PlayerData = {}
        for i, v in ipairs(validPlayers) do
            _G.PlayerData[i] = { address = v.addr, flags = gg.TYPE_DWORD, value = 0 }
        end

        local sortText = (sortOrder == 1) and "（远→近）" or "（近→远）"
        local msg = string.format("过滤完成，剩余 %d 个移动玩家", #validPlayers)
        if canSort then msg = msg .. sortText end
        提示(msg)

        _G.FilterStep = 1
        _G.MoveHistory = {}
        return
    end
end


function resortHS3(order)
    order = order or 0
    if not _G.Candidates or #_G.Candidates == 0 then
        提示("没有候选数据，请先初始化")
        return
    end
    if not selfXAddr or not selfYAddr or not selfZAddr then
        提示("自身坐标未初始化，请先初始化")
        return
    end

    local selfCoords = gg.getValues({
        {address = selfXAddr, flags = gg.TYPE_FLOAT},
        {address = selfYAddr, flags = gg.TYPE_FLOAT},
        {address = selfZAddr, flags = gg.TYPE_FLOAT}
    })
    if not selfCoords or not selfCoords[1] or not selfCoords[2] or not selfCoords[3] then
        提示("获取自身坐标失败")
        return
    end
    local selfX = selfCoords[1].value
    local selfY = selfCoords[2].value
    local selfZ = selfCoords[3].value

    local valid = {}
    for _, cand in ipairs(_G.Candidates) do
        local ok, curCoords = pcall(gg.getValues, {
            {address = cand.addr + 0x24, flags = gg.TYPE_FLOAT},
            {address = cand.addr + 0x28, flags = gg.TYPE_FLOAT},
            {address = cand.addr + 0x2C, flags = gg.TYPE_FLOAT}
        })
        if ok and curCoords and curCoords[1] and curCoords[2] and curCoords[3] then
            local x, y, z = curCoords[1].value, curCoords[2].value, curCoords[3].value
            if not (isZero(x) or isZero(y) or isZero(z)) then

                cand.x = x
                cand.y = y
                cand.z = z
                table.insert(valid, cand)
            end
        end
    end

    _G.Candidates = valid
    if #_G.Candidates == 0 then
        提示("没有有效的玩家数据")
        return
    end

    for _, cand in ipairs(_G.Candidates) do
        local dx = cand.x - selfX
        local dy = cand.y - selfY
        local dz = cand.z - selfZ
        cand.dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    end

    if order == 1 then
        table.sort(_G.Candidates, function(a, b) return a.dist > b.dist end)
        提示("已重新按距离排序（远→近），共 " .. #_G.Candidates .. " 个玩家")
    else
        table.sort(_G.Candidates, function(a, b) return a.dist < b.dist end)
        提示("已重新按距离排序（近→远），共 " .. #_G.Candidates .. " 个玩家")
    end

    _G.PlayerData = {}
    for i, cand in ipairs(_G.Candidates) do
        _G.PlayerData[i] = {
            address = cand.addr,
            flags = gg.TYPE_DWORD,
            value = 0
        }
    end
end

function HS4()
    local selfBase = nil
    gg.clearResults()
    search(17039364, 4, neicun)
    py1(1111752704, 4, 0x44)

    if sj and #sj > 0 then
        selfBase = sj[1].address
        selfXAddr = selfBase - 12
        selfYAddr = selfBase - 8
        selfZAddr = selfBase - 4
        gg.clearResults()
        提示("自身坐标初始化成功")
        return true
    else
        提示("快速定位失败，尝试使用备用搜索自身坐标...")
        gg.clearResults()
        search(17039364, 4, neicun)
        py1(16777215, 4, -36)
        py1(257, 4, -32)

        if sj and #sj > 0 then
            local baseAddr = sj[1].address
            a = {{address = baseAddr, flags = gg.TYPE_DWORD, value = 0}}
            selfXAddr = baseAddr - 0xC
            selfYAddr = baseAddr - 0x8
            selfZAddr = baseAddr - 0x4
            gg.clearResults()
            提示("个人坐标初始化成功（备用特征码降级）")
            return true
        end

        gg.clearResults()
        提示("个人坐标初始化失败，请检查游戏状态")
        return false
    end
end

function cleanHS3()
    if not _G.Candidates or #_G.Candidates == 0 then
        提示("没有找到可清理的玩家数据")
        return 0
    end
    local itemsToClear = {}
    for _, cand in ipairs(_G.Candidates) do

        if cand and cand.addr then
            table.insert(itemsToClear, { 
                address = cand.addr, 
                flags = gg.TYPE_DWORD, 
                value = 0 
            })
        end
    end
    local count = #itemsToClear
    if count > 0 then
        gg.setValues(itemsToClear)
        _G.PlayerData = nil 
        _G.Candidates = nil
        提示(string.format("已强制清除所有 %d 个玩家数据", count))
        collectgarbage("collect")
    else
        提示("没有有效地址进行清理")
    end
    return count
end

function manageEntities()
local rawData = _G.Candidates
if not rawData or #rawData == 0 then
    rawData = _G.PlayerData
end
if not rawData or #rawData == 0 then
    提示("没有实体数据，请先初始化")
    return
end

local refreshed = {}
for _, v in ipairs(rawData) do
    local addr = v.addr or v.address
    if addr then
        local ok, coords = pcall(gg.getValues, {
            {address = addr + 0x24, flags = gg.TYPE_FLOAT},
            {address = addr + 0x28, flags = gg.TYPE_FLOAT},
            {address = addr + 0x2C, flags = gg.TYPE_FLOAT}
        })
        if ok and coords and coords[1] and coords[2] and coords[3] then
            local x = tonumber(coords[1].value)
            local y = tonumber(coords[2].value)
            local z = tonumber(coords[3].value)
            if x and y and z and not (isZero(x) or isZero(y) or isZero(z)) then
                table.insert(refreshed, {addr = addr, x = x, y = y, z = z})
            end
        end
    end
end

local data = refreshed

if #data == 0 then
    提示("所有实体坐标数据均为0（可能已失效），请重新初始化")
    return
end
if #data < #rawData then
    提示(string.format("已自动过滤 %d 个无效实体数据（坐标含0）", #rawData - #data))
    gg.sleep(600)
end

    local function syncToGlobal()
        _G.Candidates = data
        _G.PlayerData = {}
        for i, ent in ipairs(data) do
            _G.PlayerData[i] = {
                address = ent.addr,
                flags = gg.TYPE_DWORD,
                value = 0
            }
        end
    end

    local function buildItems(source)
        local items = {"🔍 搜索", "📦 批量操作", "🧹 清理无效"}
        for i, ent in ipairs(source) do
            items[#items+1] = string.format("%d. (%.2f, %.2f, %.2f)", i, ent.x, ent.y, ent.z)
        end
        return items
    end

    local function parseIndices(input, max)
        local indices = {}
        if not input or input == "" then return indices end
        for part in input:gmatch("[^,]+") do
            part = part:match("^%s*(.-)%s*$")
            if part:find("-") then
                local a, b = part:match("(%d+)-(%d+)")
                a, b = tonumber(a), tonumber(b)
                if a and b then
                    for i = math.max(a,1), math.min(b, max) do
                        indices[#indices+1] = i
                    end
                end
            else
                local idx = tonumber(part)
                if idx and idx >= 1 and idx <= max then
                    indices[#indices+1] = idx
                end
            end
        end
        local seen, sorted = {}, {}
        for _, idx in ipairs(indices) do
            if not seen[idx] then
                seen[idx] = true
                table.insert(sorted, idx)
            end
        end
        table.sort(sorted)
        return sorted
    end

    local function batchOperation(source)
        if #source == 0 then
            提示("没有可操作的实体数据")
            return false
        end
        local prompt = string.format("请输入要操作的实体序号（例如 1,3,5-7）\n当前共 %d 个实体", #source)
        local input = gg.prompt({prompt}, {""}, {"text"})
        if not input then return false end
        local indices = parseIndices(input[1], #source)
        if #indices == 0 then
            提示("没有有效的序号")
            return false
        end

        local ops = {"批量删除", "批量置顶", "批量置底", "取消"}
        local op = gg.choice(ops, nil, string.format("选中了 %d 个实体数据，选择操作", #indices))
        if not op or op == 4 then return false end

        if op == 1 then
            local new = {}
            for i = 1, #source do
                local found = false
                for _, idx in ipairs(indices) do
                    if i == idx then found = true; break end
                end
                if not found then table.insert(new, source[i]) end
            end
            for i = 1, #new do source[i] = new[i] end
            for i = #new+1, #source do source[i] = nil end
            syncToGlobal()
            提示(string.format("已删除 %d 个实体数据", #indices))
        elseif op == 2 then
            local selected = {}
            for _, idx in ipairs(indices) do table.insert(selected, source[idx]) end
            local new = {}
            for _, ent in ipairs(selected) do table.insert(new, ent) end
            for i = 1, #source do
                local isSelected = false
                for _, idx in ipairs(indices) do
                    if i == idx then isSelected = true; break end
                end
                if not isSelected then table.insert(new, source[i]) end
            end
            for i = 1, #new do source[i] = new[i] end
            for i = #new+1, #source do source[i] = nil end
            syncToGlobal()
            提示("已置顶选中的实体数据")
        elseif op == 3 then
            local selected = {}
            for _, idx in ipairs(indices) do table.insert(selected, source[idx]) end
            local new = {}
            for i = 1, #source do
                local isSelected = false
                for _, idx in ipairs(indices) do
                    if i == idx then isSelected = true; break end
                end
                if not isSelected then table.insert(new, source[i]) end
            end
            for _, ent in ipairs(selected) do table.insert(new, ent) end
            for i = 1, #new do source[i] = new[i] end
            for i = #new+1, #source do source[i] = nil end
            syncToGlobal()
            提示("已置底选中的实体数据")
        end
        return true
    end

local function entityActions(idx, source)
    local actions = {"传送测试", "删除此实体数据", "上移", "下移", "置顶", "置底", "查看详细", "返回"}
    local choice = gg.choice(actions, nil, string.format("实体数据 %d 的操作", idx))
    if not choice then return false end
    
    if choice == 1 then  -- 传送测试
        local ent = source[idx]
        if not selfXAddr or not selfYAddr or not selfZAddr then
            提示("请先初始化数据")
            return false
        end

        local memEntries = {
            {address = selfXAddr, value = ent.x, flags = gg.TYPE_FLOAT},
            {address = selfYAddr, value = ent.y, flags = gg.TYPE_FLOAT},
            {address = selfZAddr, value = ent.z, flags = gg.TYPE_FLOAT},
            {address = selfXAddr + 0xB0, value = ent.x, flags = gg.TYPE_FLOAT},
            {address = selfYAddr + 0xB0, value = ent.y, flags = gg.TYPE_FLOAT},
            {address = selfZAddr + 0xB0, value = ent.z, flags = gg.TYPE_FLOAT}
        }
        local ok, err = pcall(gg.setValues, memEntries)
        if ok then
            提示(string.format("已传送到实体 %d (%.2f, %.2f, %.2f)", idx, ent.x, ent.y, ent.z))
        else
            提示("传送失败: " .. tostring(err))
        end
        return false
    elseif choice == 2 then  -- 删除
        table.remove(source, idx)
        if #source == 0 then
            提示("所有实体数据已删除")
            _G.Candidates = nil
            _G.PlayerData = nil
            return true
        end
        syncToGlobal()
        提示("已删除实体数据 " .. idx)
    elseif choice == 3 then  -- 上移
        if idx > 1 then
            source[idx], source[idx-1] = source[idx-1], source[idx]
            syncToGlobal()
            提示("已上移")
        else
            提示("已是第一个")
        end
    elseif choice == 4 then  -- 下移
        if idx < #source then
            source[idx], source[idx+1] = source[idx+1], source[idx]
            syncToGlobal()
            提示("已下移")
        else
            提示("已是最后一个")
        end
    elseif choice == 5 then  -- 置顶
        if idx > 1 then
            local item = table.remove(source, idx)
            table.insert(source, 1, item)
            syncToGlobal()
            提示("已置顶")
        else
            提示("已在顶部")
        end
    elseif choice == 6 then  -- 置底
        if idx < #source then
            local item = table.remove(source, idx)
            table.insert(source, item)
            syncToGlobal()
            提示("已置底")
        else
            提示("已在底部")
        end
    elseif choice == 7 then  -- 查看详细
        local ent = source[idx]
        local msg = string.format("实体 %d\n地址: 0x%X\nX: %.2f\nY: %.2f\nZ: %.2f",
            idx, ent.addr, ent.x, ent.y, ent.z)
        gg.alert(msg)
    end
    return false
end

    local function searchEntities(source, keyword)
        if keyword == "" then return source end
        local kw = keyword:lower()
        local filtered = {}
        for _, ent in ipairs(source) do
            local info = string.format("%f %f %f %X", ent.x, ent.y, ent.z, ent.addr)
            if info:lower():find(kw, 1, true) then
                table.insert(filtered, ent)
            end
        end
        return filtered
    end

local function cleanInvalid(source)
    if not source or #source == 0 then
        提示("没有实体数据")
        return false
    end

    local step = _G.CleanStep
    local history = _G.CleanHistory

    if step == 1 then
        for _, ent in ipairs(source) do
            local addr = ent.addr
            if addr then
                local ok, coords = pcall(gg.getValues, {
                    {address = addr + 0x24, flags = gg.TYPE_FLOAT},
                    {address = addr + 0x28, flags = gg.TYPE_FLOAT},
                    {address = addr + 0x2C, flags = gg.TYPE_FLOAT}
                })
                if ok and coords and coords[1] and coords[2] and coords[3] then
                    local x = tonumber(coords[1].value)
                    local y = tonumber(coords[2].value)
                    local z = tonumber(coords[3].value)
                    if x and y and z then
                        history[addr] = { x1 = x, y1 = y, z1 = z, step = 1 }
                    end
                end
            end
        end
        _G.CleanStep = 2
        提示("已记录第一次坐标，再次点击「清理无效」记录第二次")
        return false
    end
    if step == 2 then
        for _, ent in ipairs(source) do
            local addr = ent.addr
            if addr and history[addr] and history[addr].step == 1 then
                local ok, coords = pcall(gg.getValues, {
                    {address = addr + 0x24, flags = gg.TYPE_FLOAT},
                    {address = addr + 0x28, flags = gg.TYPE_FLOAT},
                    {address = addr + 0x2C, flags = gg.TYPE_FLOAT}
                })
                if ok and coords and coords[1] and coords[2] and coords[3] then
                    local x = tonumber(coords[1].value)
                    local y = tonumber(coords[2].value)
                    local z = tonumber(coords[3].value)
                    if x and y and z then
                        history[addr].x2 = x
                        history[addr].y2 = y
                        history[addr].z2 = z
                        history[addr].step = 2
                    end
                end
            end
        end
        _G.CleanStep = 3
        提示("已记录第二次坐标，再次点击「清理无效」将过滤静止物体（第三次比较）")
        return false
    end
    if step == 3 then
        local cleaned = {}
        local removed = 0
        for _, ent in ipairs(source) do
            local addr = ent.addr
            if not addr then goto skip end
            local ok, coords = pcall(gg.getValues, {
                {address = addr + 0x24, flags = gg.TYPE_FLOAT},
                {address = addr + 0x28, flags = gg.TYPE_FLOAT},
                {address = addr + 0x2C, flags = gg.TYPE_FLOAT}
            })
            if not ok or not coords or not coords[1] or not coords[2] or not coords[3] then
                removed = removed + 1
                goto skip
            end
            local x = tonumber(coords[1].value)
            local y = tonumber(coords[2].value)
            local z = tonumber(coords[3].value)
            if not (x and y and z) then
                removed = removed + 1
                goto skip
            end
            if isZero(x) or isZero(y) or isZero(z) then
                removed = removed + 1
                goto skip
            end

            local hist = history[addr]
            if hist and hist.step == 2 then
                local same = math.abs(hist.x2 - x) < 1e-4 and
                             math.abs(hist.y2 - y) < 1e-4 and
                             math.abs(hist.z2 - z) < 1e-4
                if same then
                    removed = removed + 1
                    goto skip
                else
                    table.insert(cleaned, { addr = addr, x = x, y = y, z = z })
                end
            else
                table.insert(cleaned, { addr = addr, x = x, y = y, z = z })
            end
            ::skip::
        end

        if #cleaned < #source then
            for i = 1, #cleaned do source[i] = cleaned[i] end
            for i = #cleaned + 1, #source do source[i] = nil end
            syncToGlobal()
            提示(string.format("已清理 %d 个静止实体（连续三次坐标未变）", removed))
        else
            提示("没有发现静止实体")
        end
        _G.CleanStep = 1
        _G.CleanHistory = {}
        return true
    end
    return false
end

    local history = {{items = buildItems(data), data = data}}

    while true do
        local current = history[#history]
        local displayItems = current.items
        local currentData = current.data
        local title = string.format("实体数据列表 (共%d个)", #currentData)

        local choice = gg.choice(displayItems, nil, title)
        if not choice then break end

        if #history == 1 then
            if choice == 1 then
                local input = gg.prompt({"请输入关键词 (坐标/地址)"}, {""}, {"text"})
                if input and input[1] ~= "" then
                    local keyword = input[1]:match("^%s*(.-)%s*$")
                    if keyword == "" then
                        提示("关键词不能为空")
                    else
                        local filtered = searchEntities(currentData, keyword)
                        if #filtered > 0 then
                            local newItems = buildItems(filtered)
                            table.insert(history, {items = newItems, data = filtered})
                        else
                            提示("没有匹配的实体数据")
                        end
                    end
                end
            elseif choice == 2 then
                batchOperation(currentData)
                current.items = buildItems(currentData)
                if #currentData == 0 then
                    提示("所有实体数据已删除，退出管理")
                    _G.Candidates = nil
                    _G.PlayerData = nil
                    return
                end
            elseif choice == 3 then
                cleanInvalid(currentData)
                current.items = buildItems(currentData)
                if #currentData == 0 then
                    提示("所有实体数据已失效，退出管理")
                    _G.Candidates = nil
                    _G.PlayerData = nil
                    return
                end
            else
                local idx = choice - 3
                local shouldExit = entityActions(idx, currentData)
                if shouldExit then return end
                current.items = buildItems(currentData)
                if #currentData == 0 and #history > 1 then
                    table.remove(history)
                    提示("数据已空，返回上一页")
                end
            end
        else
            if choice == 1 then
                local adminOpts = {"🔍 搜索", "📦 批量操作", "🧹 清理无效坐标", "↩️ 返回上一页", "❌ 取消"}
                local admin = gg.choice(adminOpts, nil, "管理")
                if admin == 1 then
                    local input = gg.prompt({"请输入关键词"}, {""}, {"text"})
                    if input and input[1] ~= "" then
                        local keyword = input[1]:match("^%s*(.-)%s*$")
                        if keyword == "" then
                            提示("关键词不能为空")
                        else
                            local filtered = searchEntities(currentData, keyword)
                            if #filtered > 0 then
                                local newItems = buildItems(filtered)
                                table.insert(history, {items = newItems, data = filtered})
                            else
                                提示("没有匹配的实体数据")
                            end
                        end
                    end
                elseif admin == 2 then
                    batchOperation(currentData)
                    current.items = buildItems(currentData)
                    if #currentData == 0 and #history > 1 then
                        table.remove(history)
                        提示("数据已空，返回上一页")
                    end
                elseif admin == 3 then
                    cleanInvalid(currentData)
                    current.items = buildItems(currentData)
                    if #currentData == 0 and #history > 1 then
                        table.remove(history)
                        提示("数据已空，返回上一页")
                    end
                elseif admin == 4 then
                    table.remove(history)
                end
            else
                local idx = choice - 2
                local entityIdx = choice - 3
                local shouldExit = entityActions(entityIdx, currentData)
                if shouldExit then return end
                current.items = buildItems(currentData)
                if #currentData == 0 and #history > 1 then
                    table.remove(history)
                    提示("数据已空，返回上一页")
                end
            end
        end
    end

    if _G.Candidates then
        _G.Candidates = data
        syncToGlobal()
    end
end


_AxisEnable = _AxisEnable or { x = true, y = true, z = true }

function setAxisEnable()
    local inputs = gg.prompt(
        {"启用X轴传送", "启用Y轴传送", "启用Z轴传送"},
        {_AxisEnable.x, _AxisEnable.y, _AxisEnable.z},
        {"checkbox", "checkbox", "checkbox"}
    )
    if inputs == nil then
        提示("已取消")
        return
    end
    _AxisEnable.x = inputs[1] == true
    _AxisEnable.y = inputs[2] == true
    _AxisEnable.z = inputs[3] == true
    提示("坐标轴设置已更新")
end

function showAxisStatus()
    local status = string.format("X轴: %s\nY轴: %s\nZ轴: %s",
        _AxisEnable.x and "✅ 启用" or "❌ 禁用",
        _AxisEnable.y and "✅ 启用" or "❌ 禁用",
        _AxisEnable.z and "✅ 启用" or "❌ 禁用")
    gg.alert("当前坐标轴传送状态\n\n" .. status)
end



local 环绕取值 = 0
local 环绕半径 = 0
local 环绕高度 = 0
local 环绕角度 = 1
fw1 = false
local centerX, centerY, centerZ
local 环绕还原 = true
file.mkdir("/storage/emulated/0/长安/环绕")
filePath = "/sdcard/长安/环绕/环绕数据文件"

local fileContent = file.read(filePath)
if not fileContent then
fileContent = "♧0♧♡0♡◇1◇"
file.write(filePath, base64.encode(fileContent))
else
fileContent = base64.decode(fileContent)
end

环绕半径 = tonumber(fileContent:match("♧(.-)♧")) or 0
环绕高度 = tonumber(fileContent:match("♡(.-)♡")) or 0
环绕角度 = tonumber(fileContent:match("◇(.-)◇")) or 1



file.mkdir("/storage/emulated/0/长安/传送偏移")
offsetFilePath = "/sdcard/长安/传送偏移/传送偏移文件"

local fileContent2 = file.read(offsetFilePath)
if not fileContent2 then
    fileContent2 = "♧0♧♡0♡◇0◇○0.2○□5000□◁0▷"
    file.write(offsetFilePath, base64.encode(fileContent2))
else
    fileContent2 = base64.decode(fileContent2)
end

targetOffsetX = tonumber(fileContent2:match("♧(.-)♧")) or 0
targetOffsetY = tonumber(fileContent2:match("♡(.-)♡")) or 0
targetOffsetZ = tonumber(fileContent2:match("◇(.-)◇")) or 0
xunhuanjiange = tonumber(fileContent2:match("○(.-)○")) or 0.2
targetOnsetY = tonumber(fileContent2:match("□(.-)□")) or 5000
targetOn2setY = tonumber(fileContent2:match("◁(.-)▷")) or 0

function teleportPlayer(playerIndex)
    if not selfXAddr or not selfYAddr or not selfZAddr then
        提示("请先初始化自身坐标")
        return false
    end

    local player = _G.PlayerData[playerIndex]
    if not player or not player.address then
        提示(string.format("玩家%d数据未加载", playerIndex))
        return false
    end

    环绕取值 = (环绕取值 + 环绕角度) % 360
    local rad = math.rad(环绕取值)
    local 新X = 环绕半径 * math.cos(rad)
    local 新Z = 环绕半径 * math.sin(rad)

    local success, coords = pcall(function()
        return gg.getValues({
            {address = player.address + 0x24, flags = gg.TYPE_FLOAT},
            {address = player.address + 0x28, flags = gg.TYPE_FLOAT},
            {address = player.address + 0x2C, flags = gg.TYPE_FLOAT}
        })
    end)

    if not success or not coords then
        提示("获取坐标失败")
        return false
    end

    local targetX = coords[1].value + targetOffsetX
    local targetY = coords[2].value + targetOffsetY
    local targetZ = coords[3].value + targetOffsetZ

    local finalX = targetX + 新X
    local finalY = targetY + 环绕高度
    local finalZ = targetZ + 新Z

    local memEntries = {}
    if _AxisEnable.x then
        table.insert(memEntries, {address = selfXAddr, value = finalX, flags = gg.TYPE_FLOAT})
        table.insert(memEntries, {address = selfXAddr + 0xB0, value = finalX, flags = gg.TYPE_FLOAT})
    end
    if _AxisEnable.y then
        table.insert(memEntries, {address = selfYAddr, value = finalY, flags = gg.TYPE_FLOAT})
        table.insert(memEntries, {address = selfYAddr + 0xB0, value = finalY, flags = gg.TYPE_FLOAT})
    end
    if _AxisEnable.z then
        table.insert(memEntries, {address = selfZAddr, value = finalZ, flags = gg.TYPE_FLOAT})
        table.insert(memEntries, {address = selfZAddr + 0xB0, value = finalZ, flags = gg.TYPE_FLOAT})
    end

    local result, err = pcall(gg.setValues, memEntries)
    if not result then
        提示("传送失败: "..(err or "未知错误"))
        return false
    end

    return true
end


for i = 1, 30 do
_G["wj"..i.."tp"] = function() return teleportPlayer(i) end
end

function CD()
    if not _G.PlayerData or #_G.PlayerData == 0 then
        提示("没有可用的玩家数据，请先初始化")
        return
    end
    if not selfXAddr or not selfYAddr or not selfZAddr then
        提示("请先初始化自身坐标")
        return
    end

    local menu = {}
    for i = 1, #_G.PlayerData do
        menu[i] = '•玩家' .. i
    end

    local choice = gg.choice(menu, nil, 'RunawaG - 选择传送目标')
    if choice and choice >= 1 and choice <= #_G.PlayerData then
        teleportPlayer(choice)
    end
end

function randomCD()
    if not _G.PlayerData or #_G.PlayerData == 0 then
        提示("没有可用的玩家数据，请先初始化")
        return
    end
    if not selfXAddr or not selfYAddr or not selfZAddr then
        提示("请先初始化自身坐标")
        return
    end

    math.randomseed(os.time())
    math.random()

    local idx = math.random(#_G.PlayerData)

    teleportPlayer(idx)
    提示(string.format("随机传送到玩家%d", idx))
end


fw1 = false
multiPlayerLoopThread = nil
multiPlayerList = {}

function startMultiPlayerLoop()
    if not _G.PlayerData or #_G.PlayerData == 0 then
        提示("没有可用的玩家数据，请先初始化")
        return
    end

    local options = {}
    for i = 1, #_G.PlayerData do
        options[i] = "玩家 " .. i
    end
    local selected = gg.multiChoice(options, nil, "选择要循环传送的玩家（可多选）")
    if not selected then
        提示("未选择任何玩家")
        return
    end

    local selectedIndices = {}
    for idx, _ in pairs(selected) do
        local num = tonumber(idx)
        if num then table.insert(selectedIndices, num) end
    end

    if #selectedIndices == 0 then
        提示("选中的玩家列表无效")
        return
    end
    table.sort(selectedIndices)
    multiPlayerList = selectedIndices

    if fw1 then
        stopMultiPlayerLoop()
        gg.sleep(100)
    end

    fw1 = true
    local threadFunc = function()
        local listIndex = 1
        while fw1 do
            local playerIdx = multiPlayerList[listIndex]
            if playerIdx then
                local func = _G["wj" .. playerIdx .. "tp"]
                if func then
                    func()
                    if xunhuanjiange > 0 then
                        local startTime = os.clock()
                        while os.clock() - startTime < xunhuanjiange do
                            func()
                            gg.sleep(10)
                        end
                    end
                end
            end
            listIndex = listIndex + 1
            if listIndex > #multiPlayerList then
                listIndex = 1
            end
        end
    end

    if runAsyncTask then
        runAsyncTask(threadFunc)
    else
        multiPlayerLoopThread = luajava.newThread(threadFunc)
        multiPlayerLoopThread:start()
    end

    提示(string.format("已开始循环传送 %d 个玩家，每个停留 %.2f 秒", #multiPlayerList, xunhuanjiange))
end

function stopMultiPlayerLoop()
    if fw1 then
        fw1 = false
        if multiPlayerLoopThread then
            gg.sleep(100)
            multiPlayerLoopThread = nil
        end
        提示("已停止多玩家循环传送")
    else
        提示("未在运行")
        multiPlayerLoopThread = nil
    end
end

function setPlayerStayTime()
    local input = gg.prompt({"每个玩家停留时间（秒）"}, {xunhuanjiange}, {"number"})
    if input == nil then
        提示("已取消")
        return
    end
    local val = input[1]
    if val == nil then
        提示("输入无效")
        return
    end
    local num = tonumber(val)
    if num == nil then
        提示("输入无效，请输入数字")
        return
    end
    if num < 0 then
        提示("停留时间不能为负数，已设置为 0.2")
        xunhuanjiange = 0.2
        local files = io.open(offsetFilePath, "w")
files:write(base64.encode("♧"..targetOffsetX.."♧♡"..targetOffsetY.."♡◇"..targetOffsetZ.."◇○"..xunhuanjiange.."○□"..targetOnsetY.."□◁"..targetOn2setY.."▷"))
files:close()
        return
    end
    xunhuanjiange = num
    local files = io.open(offsetFilePath, "w")
files:write(base64.encode("♧"..targetOffsetX.."♧♡"..targetOffsetY.."♡◇"..targetOffsetZ.."◇○"..xunhuanjiange.."○□"..targetOnsetY.."□◁"..targetOn2setY.."▷"))
files:close()
    提示(string.format("停留时间已设置为 %.2f 秒", xunhuanjiange))
end


offX, offY, offZ, onY, xhshijian = 0, 0, 0, 4000, 0.6

file.mkdir("/storage/emulated/0/长安/天罚传送偏移")
local tianfaFilePath = "/sdcard/长安/天罚传送偏移/传送偏移文件"

local tianfaFileContent = file.read(tianfaFilePath)
if not tianfaFileContent then
    tianfaFileContent = "♧0♧♡0♡◇0◇○4000○□0.6□"
    file.write(tianfaFilePath, base64.encode(tianfaFileContent))
else
    tianfaFileContent = base64.decode(tianfaFileContent)
end

offX = tonumber(tianfaFileContent:match("♧(.-)♧")) or 0
offY = tonumber(tianfaFileContent:match("♡(.-)♡")) or 0
offZ = tonumber(tianfaFileContent:match("◇(.-)◇")) or 0
onY = tonumber(tianfaFileContent:match("○(.-)○")) or 4000
xhshijian = tonumber(tianfaFileContent:match("□(.-)□")) or 0.6

function zuizongpianyi()
    local inputs = gg.prompt({
        'X 轴偏移',
        'Y 轴偏移',
        'Z 轴偏移',
        'Y 升空锚点高度',
        '循环传送时间(当前:' .. xhshijian .. '秒)'
    }, {offX, offY, offZ, onY, xhshijian}, {'number', 'number', 'number', 'number', 'number'})
    
    if inputs == nil then
        提示("已取消设置")
        return
    end

    local newX = tonumber(inputs[1])
    local newY = tonumber(inputs[2])
    local newZ = tonumber(inputs[3])
    local newOnY = tonumber(inputs[4])
    local newxhshijian = tonumber(inputs[5])

    if newX == nil or newY == nil or newZ == nil or newOnY == nil or newxhshijian == nil then
        提示("输入无效，请输入有效数字")
        return
    end

    if newxhshijian < 0 then
        提示("循环传送时间不能为负数，已设置为0.6")
        newxhshijian = 0.6
    end

    offX = newX
    offY = newY
    offZ = newZ
    onY = newOnY
    xhshijian = newxhshijian

    local files = io.open(tianfaFilePath, "w")
    if files then
        local saveContent = "♧"..offX.."♧♡"..offY.."♡◇"..offZ.."◇○"..onY.."○□"..xhshijian.."□"
        files:write(base64.encode(saveContent))
        files:close()
        提示(string.format("偏移已设置并保存: X=%.2f Y=%.2f Z=%.2f 锚点Y=%.2f 循环传送时间=%.2f", offX, offY, offZ, onY, xhshijian))
    else
        提示("保存失败，请检查权限")
    end
end

function chongzhitianfa()
    offX, offY, offZ, onY, xhshijian = 0, 0, 0, 4000, 0.6
    local files = io.open(tianfaFilePath, "w")
    if files then
    tianfaFileContent2 = "♧0♧♡0♡◇0◇○4000○□0.6□"
        files:write(base64.encode(tianfaFileContent2))
        files:close()
        提示("天罚传送偏移设置已重置")
    else
        提示("保存失败，请检查权限")
    end
end

function getValidPlayers()
    local valid = {}
    for i = 1, #_G.PlayerData do
        local player = _G.PlayerData[i]
        if player and player.address then
            local test = gg.getValues({{address = player.address + 0x24, flags = gg.TYPE_FLOAT}})
            if test and test[1] and test[1].value ~= nil then
                table.insert(valid, i)
            end
        end
    end
    return valid
end

local function teleportToPlayer(playerIndex)
    local target = _G.PlayerData[playerIndex]
    if not target or not target.address then
        提示(string.format("玩家%d数据无效", playerIndex))
        return
    end

    search(17039620,4,neicun)
    py1(16777215,4,-36)
    py1(259,4,-32)
    py1(17039620,4,0)

    if not sj or #sj == 0 then
        提示("定位天罚失败")
        return
    end

    local tianfaList = {}
    for i, v in ipairs(sj) do
        tianfaList[i] = {
            addrX = v.address - 12,
            addrY = v.address - 8,
            addrZ = v.address - 4
        }
    end

    local liftEdits = {}
    for _, tf in ipairs(tianfaList) do
        table.insert(liftEdits, {address = tf.addrY, flags = gg.TYPE_FLOAT, value = onY})
    end
    gg.setValues(liftEdits)

    local startTime = os.clock()
    while os.clock() - startTime < xhshijian do
        local coords = gg.getValues({
            {address = target.address + 0x24, flags = gg.TYPE_FLOAT},
            {address = target.address + 0x28, flags = gg.TYPE_FLOAT},
            {address = target.address + 0x2C, flags = gg.TYPE_FLOAT}
        })

        local allEdits = {}
        for _, tf in ipairs(tianfaList) do
            table.insert(allEdits, {address = tf.addrX, flags = gg.TYPE_FLOAT, value = coords[1].value + offX})
            table.insert(allEdits, {address = tf.addrY, flags = gg.TYPE_FLOAT, value = coords[2].value + offY})
            table.insert(allEdits, {address = tf.addrZ, flags = gg.TYPE_FLOAT, value = coords[3].value + offZ})
        end
        gg.setValues(allEdits)
    gg.sleep(50)
    end

    local cleanEdits = {}
    for _, tf in ipairs(tianfaList) do
        table.insert(cleanEdits, {address = tf.addrX, flags = gg.TYPE_FLOAT, value = 0.1145146})
        table.insert(cleanEdits, {address = tf.addrY, flags = gg.TYPE_FLOAT, value = 0.1145147})
        table.insert(cleanEdits, {address = tf.addrZ, flags = gg.TYPE_FLOAT, value = 0.1145149})
    end
    gg.setValues(cleanEdits)

    提示(string.format("已传送玩家%d (共修改%d个天罚)", playerIndex, #tianfaList))
end

for i = 1, 30 do
    _G['wj'..(i+50)..'tp'] = function() 
        if _G.PlayerData[i] then 
            teleportToPlayer(i) 
        else 
            提示(string.format("玩家%d数据未加载", i)) 
        end 
    end
end

function tf1()
    local availablePlayers = getValidPlayers()

    if #availablePlayers == 0 then
        提示("没有可传送的玩家")
        return
    end

    local menuItems = {}
    for _, idx in ipairs(availablePlayers) do
        table.insert(menuItems, '•玩家' .. idx)
    end

    local tf = gg.choice(menuItems, nil, 'RunawaG - 选择传送目标')
    if tf then
        local playerIndex = availablePlayers[tf]
        local funcName = 'wj' .. (playerIndex + 50) .. 'tp'
        if _G[funcName] then
            _G[funcName]()
        else
            提示("玩家" .. playerIndex .. "的传送函数不存在")
        end
    end
end

function randomTeleport()
    local validPlayers = getValidPlayers()

    if #validPlayers == 0 then
        提示("没有可传送的玩家")
        return
    end

    math.randomseed(os.time())
    math.random()
    local selected = validPlayers[math.random(#validPlayers)]
    teleportToPlayer(selected)
    提示(string.format("已随机传送到玩家%d", selected))
end


fw1 = false
playerCycleThread = nil
playerCycleList = {}

function startPlayerCycle()
    if not _G.PlayerData or #_G.PlayerData == 0 then
        提示("没有可用的玩家数据，请先初始化")
        return
    end

    local options = {}
    for i = 1, #_G.PlayerData do
        options[i] = "玩家 " .. i
    end
    
    local selected = gg.multiChoice(options, nil, "选择要循环执行的玩家（可多选）")
    if not selected then
        提示("未选择任何玩家")
        return
    end

    local selectedIndices = {}
    for idx, _ in pairs(selected) do
        local num = tonumber(idx)
        if num then table.insert(selectedIndices, num) end
    end

    if #selectedIndices == 0 then
        提示("选中的玩家列表无效")
        return
    end
    
    table.sort(selectedIndices)
    playerCycleList = selectedIndices

    if fw1 then
        stopPlayerCycle()
        gg.sleep(100)
    end

    fw1 = true
    
    local threadFunc = function()
        local listIndex = 1
        
        while fw1 do
            local displayIndex = playerCycleList[listIndex]
            if displayIndex then
                local actualFuncName = "wj" .. (displayIndex + 50) .. "tp"  -- 转换为 wj51tp、wj52tp...
                local func = _G[actualFuncName]
                
                if func then
                    func()
                end
            end

            listIndex = listIndex + 1
            if listIndex > #playerCycleList then
                listIndex = 1
            end
            
            gg.sleep(50)
        end
    end

    if runAsyncTask then
        runAsyncTask(threadFunc)
    else
        playerCycleThread = luajava.newThread(threadFunc)
        playerCycleThread:start()
    end

    提示(string.format("已开始循环执行 %d 个玩家（顺序循环）", #playerCycleList))
end

function stopPlayerCycle()
    if fw1 then
        fw1 = false
        playerCycleThread = nil
        提示("已停止多玩家循环执行")
    else
        提示("未在运行")
    end
end


function teleportAllToMe()
if not a or not a[1] or not a[1].address then
提示("自身坐标无效")
return
end

local myCoords = gg.getValues({
{address = a[1].address + 0x24, flags = gg.TYPE_FLOAT},
{address = a[1].address + 0x28, flags = gg.TYPE_FLOAT},
{address = a[1].address + 0x2C, flags = gg.TYPE_FLOAT}
})

local successCount = 0
for i = 1, 30 do
if _G['drzb'..i] and _G['drzb'..i][1] and _G['drzb'..i][1].address then

gg.setValues({
{address = _G['drzb'..i][1].address + 0x24, value = myCoords[1].value, flags = gg.TYPE_FLOAT},
{address = _G['drzb'..i][1].address + 0x28, value = myCoords[2].value, flags = gg.TYPE_FLOAT},
{address = _G['drzb'..i][1].address + 0x2C, value = myCoords[3].value, flags = gg.TYPE_FLOAT}
})
successCount = successCount + 1
end
end

提示(string.format("已将%d个玩家传送到自己位置", successCount))
end







local ViewControl = {
    running = false,
    mode = 1,
    threadObj = nil,
    posSpeed = 20,
    velSpeed = 500,
    posForward = 1,
    posRight = 0,
    posUp = 1,
    velForward = 1,
    velRight = 0,
    velUp = 1,
    yawAddr = nil,
    pitchAddr = nil,
    velXAddr = nil,
    velYAddr = nil,
    velZAddr = nil,
    posXAddr = nil,
    posYAddr = nil,
    posZAddr = nil,
}

function zuobiaoxyzint()
    gg.clearResults()
    local savedItems = gg.getListItems()
    gg.removeListItems(savedItems)
    gg.setRanges(neicun)
    gg.searchNumber("17039364", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    local results = gg.getResults(5000)
    if #results == 0 then
        提示("未找到坐标基址")
        return false
    end
    local newAddrs = {}
    for i, v in ipairs(results) do
        newAddrs[i] = {address = v.address - 0x24, flags = gg.TYPE_DWORD}
    end
    gg.clearResults()
    gg.loadResults(newAddrs)
    gg.refineNumber("16777215", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    results = gg.getResults(1000)
    if #results == 0 then
        提示("①获取失败")
        return false
    end
    newAddrs = {}
    for i, v in ipairs(results) do
        newAddrs[i] = {address = v.address + 0x4, flags = gg.TYPE_DWORD}
    end
    gg.clearResults()
    gg.loadResults(newAddrs)
    gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    results = gg.getResults(1000)
    if #results == 0 then
        提示("②获取失败")
        return false
    end
    newAddrs = {}
    for i, v in ipairs(results) do
        newAddrs[i] = {address = v.address + 0x20, flags = gg.TYPE_DWORD}
    end
    gg.clearResults()
    gg.loadResults(newAddrs)
    gg.refineNumber("17039364", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    results = gg.getResults(1)
    if #results == 0 then
        提示("③获取失败")
        return false
    end
    local baseAddr = results[1].address
    Xintid = baseAddr - 0xC
    Yintid = baseAddr - 0x8
    Zintid = baseAddr - 0x4
    local coordVals = gg.getValues({
        {address = Xintid, flags = gg.TYPE_FLOAT},
        {address = Yintid, flags = gg.TYPE_FLOAT},
        {address = Zintid, flags = gg.TYPE_FLOAT}
    })
    Xintzhi = math.floor(coordVals[1].value)
    Yintzhi = math.floor(coordVals[2].value)
    Zintzhi = math.floor(coordVals[3].value)
    gg.clearResults()
    savedItems = gg.getListItems()
    gg.removeListItems(savedItems)
    提示("坐标读取成功")
    return true
end

function ViewControl:initAddresses()
    gg.setRanges(4)
    gg.clearResults()
    gg.searchNumber("1.2566370964050293", gg.TYPE_FLOAT)
    local results = gg.getResults(1)
    if #results > 0 then
        local baseAddr = results[1].address
        self.yawAddr = baseAddr - 16
        self.pitchAddr = baseAddr - 12
    else
        提示("获取视角地址失败")
        return false
    end
    if not zuobiaoxyzint() then
        提示("获取坐标地址失败")
        return false
    end
    self.posXAddr = Xintid
    self.posYAddr = Yintid
    self.posZAddr = Zintid
    gg.setRanges(4)
    gg.clearResults()
    gg.searchNumber("17039364", gg.TYPE_QWORD)
    results = gg.getResults(1)
    if #results > 0 then
        local baseAddr = results[1].address
        self.velXAddr = baseAddr + 36
        self.velYAddr = baseAddr + 40
        self.velZAddr = baseAddr + 44
    else
        提示("获取速度地址失败")
        return false
    end
    提示("地址初始化完成")
    return true
end

function ViewControl:getHorizontalVectors()
    local yaw = gg.getValues({{address = self.yawAddr, flags = 16}})[1].value
    local pitch = gg.getValues({{address = self.pitchAddr, flags = 16}})[1].value
    local forwardX = math.sin(yaw) * math.cos(pitch)
    local forwardZ = math.cos(yaw) * math.cos(pitch)
    local rightX = math.cos(yaw)
    local rightZ = -math.sin(yaw)
    return forwardX, forwardZ, rightX, rightZ, pitch
end

function ViewControl:positionLoop()
    while fw1 do
        local fx, fz, rx, rz, pitch = self:getHorizontalVectors()
        local moveX = (fx * self.posForward + rx * self.posRight) * self.posSpeed
        local moveZ = (fz * self.posForward + rz * self.posRight) * self.posSpeed
        local moveY = (-math.sin(pitch) * self.posUp) * self.posSpeed
        local coords = gg.getValues({
            {address = self.posXAddr, flags = 16},
            {address = self.posYAddr, flags = 16},
            {address = self.posZAddr, flags = 16}
        })
        gg.setValues({
            {address = self.posXAddr, flags = 16, value = coords[1].value + moveX},
            {address = self.posYAddr, flags = 16, value = coords[2].value + moveY},
            {address = self.posZAddr, flags = 16, value = coords[3].value + moveZ}
        })
        gg.sleep(0)
    end
end

function ViewControl:velocityLoop()
    while fw1 do
        local fx, fz, rx, rz, pitch = self:getHorizontalVectors()
        local vx = (fx * self.velForward + rx * self.velRight) * self.velSpeed
        local vz = (fz * self.velForward + rz * self.velRight) * self.velSpeed
        local vy = (-math.sin(pitch) * self.velUp) * self.velSpeed
        gg.setValues({
            {address = self.velXAddr, flags = 16, value = vx},
            {address = self.velYAddr, flags = 16, value = vy},
            {address = self.velZAddr, flags = 16, value = vz}
        })
        gg.sleep(0)
    end
end

function ViewControl:dualLoop()
    while fw1 do
        local fx, fz, rx, rz, pitch = self:getHorizontalVectors()
        local moveX = (fx * self.posForward + rx * self.posRight) * self.posSpeed
        local moveZ = (fz * self.posForward + rz * self.posRight) * self.posSpeed
        local moveY = (-math.sin(pitch) * self.posUp) * self.posSpeed
        local coords = gg.getValues({
            {address = self.posXAddr, flags = 16},
            {address = self.posYAddr, flags = 16},
            {address = self.posZAddr, flags = 16}
        })
        gg.setValues({
            {address = self.posXAddr, flags = 16, value = coords[1].value + moveX},
            {address = self.posYAddr, flags = 16, value = coords[2].value + moveY},
            {address = self.posZAddr, flags = 16, value = coords[3].value + moveZ}
        })
        local vx = (fx * self.velForward + rx * self.velRight) * self.velSpeed
        local vz = (fz * self.velForward + rz * self.velRight) * self.velSpeed
        local vy = (-math.sin(pitch) * self.velUp) * self.velSpeed
        gg.setValues({
            {address = self.velXAddr, flags = 16, value = vx},
            {address = self.velYAddr, flags = 16, value = vy},
            {address = self.velZAddr, flags = 16, value = vz}
        })
        gg.sleep(0)
    end
end

function ViewControl:loop()
    if self.mode == 1 then
        self:positionLoop()
    elseif self.mode == 2 then
        self:velocityLoop()
    else
        self:dualLoop()
    end
end

function ViewControl:start()
    if fw1 then
        提示("已在运行中")
        return
    end
    if not self.yawAddr or not self.posXAddr or not self.velXAddr then
        if not self:initAddresses() then
            提示("初始化地址失败")
            return
        end
    end
    fw1 = true
    self.threadObj = luajava.newThread(function()
        self:loop()
    end)
    self.threadObj:start()
    local modeName = (self.mode == 1 and "坐标模式") or (self.mode == 2 and "速度模式") or "双模式合并"
    提示(string.format("视角控制已开启，模式：%s", modeName))
end

function ViewControl:stop()
    if fw1 then
        fw1 = false
        self.threadObj = nil
        提示("视角控制已关闭")
    else
        提示("未在运行")
    end
end

function ViewControl:toggle()
    if fw1 then
        self:stop()
    else
        self:start()
    end
end

function ViewControl:setPosSpeed(speed)
    speed = tonumber(speed)
    if speed then
        self.posSpeed = speed
    else
        提示("无效速度")
    end
end

function ViewControl:setVelSpeed(speed)
    speed = tonumber(speed)
    if speed then
        self.velSpeed = speed
    else
        提示("无效速度")
    end
end

function ViewControl:setPosMultipliers(forward, right, up)
    if forward then self.posForward = tonumber(forward) or self.posForward end
    if right then self.posRight = tonumber(right) or self.posRight end
    if up then self.posUp = tonumber(up) or self.posUp end
end

function ViewControl:setVelMultipliers(forward, right, up)
    if forward then self.velForward = tonumber(forward) or self.velForward end
    if right then self.velRight = tonumber(right) or self.velRight end
    if up then self.velUp = tonumber(up) or self.velUp end
end

function ViewControl:setMultipliers(forward, right, up)
    if self.mode == 1 then
        self:setPosMultipliers(forward, right, up)
    elseif self.mode == 2 then
        self:setVelMultipliers(forward, right, up)
    else
        self:setPosMultipliers(forward, right, up)
        self:setVelMultipliers(forward, right, up)
    end
end

function ViewControl:setMode(mode)
    mode = tonumber(mode)
    if mode == 1 or mode == 2 or mode == 3 then
        local wasRunning = fw1
        if wasRunning then self:stop() gg.sleep(200) end
        self.mode = mode
        local modeName = (mode == 1 and "坐标模式") or (mode == 2 and "速度模式") or "双模式合并"
        提示("模式已切换为：" .. modeName)
        if wasRunning then
            gg.sleep(200)
            self:start()
        end
    else
        提示("模式无效，请使用 1(坐标) 2(速度) 3(双模式)")
    end
end

function setViewSpeed()
    local mode = ViewControl.mode
    if mode == 1 then
        local input = gg.prompt({
            "坐标速度",
            "前后倍率",
            "左右倍率",
            "上下倍率"
        }, {
            ViewControl.posSpeed,
            ViewControl.posForward,
            ViewControl.posRight,
            ViewControl.posUp
        }, {"number", "number", "number", "number"})
        if input == nil then
            提示("已取消")
            return
        end
        for i = 1, 4 do
            if input[i] == nil then
                提示("输入无效，请输入有效数字")
                return
            end
        end
        ViewControl:setPosSpeed(input[1])
        ViewControl:setPosMultipliers(input[2], input[3], input[4])
        提示(string.format("坐标模式：速度=%.2f 前后=%.2f 左右=%.2f 上下=%.2f",
            ViewControl.posSpeed, ViewControl.posForward, ViewControl.posRight, ViewControl.posUp))
    elseif mode == 2 then
        local input = gg.prompt({
            "基础速度",
            "前后倍率",
            "左右倍率",
            "上下倍率"
        }, {
            ViewControl.velSpeed,
            ViewControl.velForward,
            ViewControl.velRight,
            ViewControl.velUp
        }, {"number", "number", "number", "number"})
        if input == nil then
            提示("已取消")
            return
        end
        for i = 1, 4 do
            if input[i] == nil then
                提示("输入无效，请输入有效数字")
                return
            end
        end
        ViewControl:setVelSpeed(input[1])
        ViewControl:setVelMultipliers(input[2], input[3], input[4])
        提示(string.format("速度模式：基础速度=%.2f 前后=%.2f 左右=%.2f 上下=%.2f",
            ViewControl.velSpeed, ViewControl.velForward, ViewControl.velRight, ViewControl.velUp))
    elseif mode == 3 then
        local choice = gg.choice({"调整坐标参数", "调整速度参数", "取消"}, nil, "选择要修改的参数")
        if choice == nil then
            提示("已取消")
            return
        end
        if choice == 1 then
            local input = gg.prompt({
                "坐标速度",
                "前后倍率",
                "左右倍率",
                "上下倍率"
            }, {
                ViewControl.posSpeed,
                ViewControl.posForward,
                ViewControl.posRight,
                ViewControl.posUp
            }, {"number", "number", "number", "number"})
            if input == nil then
                提示("已取消")
                return
            end
            for i = 1, 4 do
                if input[i] == nil then
                    提示("输入无效，请输入有效数字")
                    return
                end
            end
            ViewControl:setPosSpeed(input[1])
            ViewControl:setPosMultipliers(input[2], input[3], input[4])
            提示(string.format("坐标模式：速度=%.2f 前后=%.2f 左右=%.2f 上下=%.2f",
                ViewControl.posSpeed, ViewControl.posForward, ViewControl.posRight, ViewControl.posUp))
        elseif choice == 2 then
            local input = gg.prompt({
                "基础速度",
                "前后倍率",
                "左右倍率",
                "上下倍率"
            }, {
                ViewControl.velSpeed,
                ViewControl.velForward,
                ViewControl.velRight,
                ViewControl.velUp
            }, {"number", "number", "number", "number"})
            if input == nil then
                提示("已取消")
                return
            end
            for i = 1, 4 do
                if input[i] == nil then
                    提示("输入无效，请输入有效数字")
                    return
                end
            end
            ViewControl:setVelSpeed(input[1])
            ViewControl:setVelMultipliers(input[2], input[3], input[4])
            提示(string.format("速度模式：基础速度=%.2f 前后=%.2f 左右=%.2f 上下=%.2f",
                ViewControl.velSpeed, ViewControl.velForward, ViewControl.velRight, ViewControl.velUp))
        end
    end
end

function setViewMode(mode)
    ViewControl:setMode(mode)
end

function getViewStatus()
    print(ViewControl:status())
end

function reinitViewAll()
    ViewControl:initAddresses()
end







function initViewOnly()
    gg.setRanges(4)
    gg.clearResults()
    gg.searchNumber("1.2566370964050293", gg.TYPE_FLOAT)
    local results = gg.getResults(1)
    if #results > 0 then
        local baseAddr = results[1].address
        ViewControl.yawAddr = baseAddr - 16
        ViewControl.pitchAddr = baseAddr - 12
        提示("视角地址初始化成功")
        return true
    else
        提示("获取视角地址失败")
        return false
    end
end

local EnemyLock = {
    running = false,
    threadObj = nil,
    currentEnemyIndex = nil,
    offsetX = 0,
    offsetY = 0,
    offsetZ = 0,
    yawRateNear = -0.000234,
    yawRateFar = -0.00001,
    distThreshold = 300,
    pitchRate = nil,
}

function EnemyLock:getSelfCoords()
    if selfXAddr and selfYAddr and selfZAddr then
        local success, coords = pcall(gg.getValues, {
            {address = selfXAddr, flags = gg.TYPE_FLOAT},
            {address = selfYAddr, flags = gg.TYPE_FLOAT},
            {address = selfZAddr, flags = gg.TYPE_FLOAT}
        })
        if success and coords and coords[1] and coords[2] and coords[3] then
            return coords
        end
    end
    提示("无法获取自身坐标，请先初始化数据")
    return nil
end

function EnemyLock:getEnemyCoords(index)
    local enemy = _G.PlayerData[index]
    if not enemy or not enemy.address then 
        return nil 
    end
    local success, coords = pcall(gg.getValues, {
        {address = enemy.address + 0x24, flags = gg.TYPE_FLOAT},
        {address = enemy.address + 0x28, flags = gg.TYPE_FLOAT},
        {address = enemy.address + 0x2C, flags = gg.TYPE_FLOAT}
    })
    if success and coords and coords[1] and coords[2] and coords[3] then
        return coords
    end
    return nil
end

function EnemyLock:calculateAngles(enemyCoords, selfCoords)
    if not enemyCoords or not selfCoords then
        return nil, nil
    end
    
    if not enemyCoords[1] or not enemyCoords[2] or not enemyCoords[3] then
        return nil, nil
    end
    
    if not selfCoords[1] or not selfCoords[2] or not selfCoords[3] then
        return nil, nil
    end

    local targetX = enemyCoords[1].value + (self.offsetX or 0)
    local targetY = enemyCoords[2].value + (self.offsetY or 0)
    local targetZ = enemyCoords[3].value + (self.offsetZ or 0)
    
    local dx = targetX - selfCoords[1].value
    local dy = targetY - selfCoords[2].value
    local dz = targetZ - selfCoords[3].value
    
    local distXZ = math.sqrt(dx*dx + dz*dz)
    local distXYZ = math.sqrt(dx*dx + dy*dy + dz*dz)
    
    local yaw = math.atan2(dx, dz)
    local pitch = math.atan2(-dy, math.sqrt(dx*dx + dz*dz))

    local yawRate = (distXZ < self.distThreshold) and self.yawRateNear or self.yawRateFar
    local yawCompensation = distXZ * yawRate
    yaw = yaw + yawCompensation
    
    if self.pitchRate ~= nil then
        local pitchCompensation = distXYZ * self.pitchRate
        pitch = pitch + pitchCompensation
    end
    
    return yaw, pitch
end

function EnemyLock:setViewAngles(yaw, pitch)
    if not ViewControl or not ViewControl.yawAddr then
        提示("请先初始化视角地址")
        return false
    end

    if self.pitchRate ~= nil then
        pcall(gg.setValues, {
            {address = ViewControl.yawAddr, flags = gg.TYPE_FLOAT, value = yaw},
            {address = ViewControl.pitchAddr, flags = gg.TYPE_FLOAT, value = pitch}
        })
    else
        pcall(gg.setValues, {
            {address = ViewControl.yawAddr, flags = gg.TYPE_FLOAT, value = yaw}
        })
    end
    return true
end

function EnemyLock:loop()
    while fw1 do
        if self.currentEnemyIndex then
            local enemyCoords = self:getEnemyCoords(self.currentEnemyIndex)
            if not enemyCoords then
                self:stop()
                提示("敌人坐标获取失败，锁定已停止")
                break
            end
            
            local selfCoords = self:getSelfCoords()
            if not selfCoords then
                self:stop()
                提示("自身坐标获取失败，锁定已停止")
                break
            end
            
            local yaw, pitch = self:calculateAngles(enemyCoords, selfCoords)
            if yaw then
                self:setViewAngles(yaw, pitch)
            end
        end
        gg.sleep(0)
    end
end

function EnemyLock:start(enemyIndex)
    if fw1 then
        self:stop()
        gg.sleep(50)
    end
    
    if not ViewControl or not ViewControl.yawAddr then
        提示("请先初始化视角数据")
        return false
    end
    
    if not selfXAddr or not selfYAddr or not selfZAddr then
        提示("请先初始化坐标数据")
        return false
    end
    
    if not _G.PlayerData or #_G.PlayerData == 0 then
        提示("没有敌人数据，请先初始化敌人")
        return false
    end
    
    if not enemyIndex or enemyIndex < 1 or enemyIndex > #_G.PlayerData then
        提示("无效的敌人索引")
        return false
    end
    
    self.currentEnemyIndex = enemyIndex
    fw1 = true
    
    self.threadObj = luajava.newThread(function()
        self:loop()
    end)
    self.threadObj:start()
    
    提示(string.format("已开始锁定敌人 %d", enemyIndex))
    return true
end

function EnemyLock:stop()
    if fw1 then
        fw1 = false
        self.threadObj = nil
        self.currentEnemyIndex = nil
        提示("敌人锁定已停止")
        gg.sleep(200)
    else
        提示("未在运行")
    end
end

function EnemyLock:toggle()
    if fw1 then
        self:stop()
    else
        if not _G.PlayerData or #_G.PlayerData == 0 then
            提示("没有敌人数据，请先初始化敌人")
            return
        end
        
        local menuItems = {}
        for i = 1, #_G.PlayerData do
            table.insert(menuItems, "敌人 " .. i)
        end
        
        local choice = gg.choice(menuItems, nil, "选择要锁定的敌人")
        if choice then
            self:start(choice)
        end
    end
end

function EnemyLock:setOffset(x, y, z)
    if x ~= nil and x ~= "" then self.offsetX = tonumber(x) or 0 end
    if y ~= nil and y ~= "" then self.offsetY = tonumber(y) or 0 end
    if z ~= nil and z ~= "" then self.offsetZ = tonumber(z) or 0 end
    
    提示(string.format("固定偏移：X=%.2f Y=%.2f Z=%.2f", 
        self.offsetX, self.offsetY, self.offsetZ))
end

function EnemyLock:promptOffset()
    local input = gg.prompt({
        "X 轴偏移",
        "Y 轴偏移",
        "Z 轴偏移"
    }, {
        string.format("%.2f", self.offsetX or 0),
        string.format("%.2f", self.offsetY or 0),
        string.format("%.2f", self.offsetZ or 0)
    }, {"number", "number", "number"})
    
    if input == nil then
        提示("已取消")
        return
    end
    
    self:setOffset(input[1], input[2], input[3])
end

function 设置水平补偿()
    local menu = gg.choice({
        "设置近处补偿 (当前: " .. string.format("%.6f", EnemyLock.yawRateNear) .. ")",
        "设置远处补偿 (当前: " .. string.format("%.6f", EnemyLock.yawRateFar) .. ")",
        "设置分界距离 (当前: " .. EnemyLock.distThreshold .. "米)"
    }, nil, "水平补偿设置")
    
    if menu == 1 then
        设置近处补偿()
    elseif menu == 2 then
        设置远处补偿()
    elseif menu == 3 then
        设置分界距离()
    end
end

function 设置近处补偿()
    local rateStr = string.format("%.6f", EnemyLock.yawRateNear)
    
    local menu = gg.choice({
        "+0.00001 (向左修正)",
        "-0.00001 (向右修正)",
        "+0.00005 (向左粗调)",
        "-0.00005 (向右粗调)",
        "自定义输入"
    }, nil, "近处补偿: " .. rateStr)
    
    if menu == 1 then
        EnemyLock.yawRateNear = EnemyLock.yawRateNear + 0.00001
    elseif menu == 2 then
        EnemyLock.yawRateNear = EnemyLock.yawRateNear - 0.00001
    elseif menu == 3 then
        EnemyLock.yawRateNear = EnemyLock.yawRateNear + 0.00005
    elseif menu == 4 then
        EnemyLock.yawRateNear = EnemyLock.yawRateNear - 0.00005
    elseif menu == 5 then
        local input = gg.prompt({"输入近处补偿值"}, {string.format("%.6f", EnemyLock.yawRateNear)}, {"number"})
        if input then
            EnemyLock.yawRateNear = tonumber(input[1]) or EnemyLock.yawRateNear
        end
    end
    
    if menu then
        提示("近处补偿: " .. string.format("%.6f", EnemyLock.yawRateNear))
    end
end

function 设置远处补偿()
    local rateStr = string.format("%.6f", EnemyLock.yawRateFar)
    
    local menu = gg.choice({
        "+0.00001 (向左修正)",
        "-0.00001 (向右修正)",
        "+0.00005 (向左粗调)",
        "-0.00005 (向右粗调)",
        "自定义输入"
    }, nil, "远处补偿: " .. rateStr)
    
    if menu == 1 then
        EnemyLock.yawRateFar = EnemyLock.yawRateFar + 0.00001
    elseif menu == 2 then
        EnemyLock.yawRateFar = EnemyLock.yawRateFar - 0.00001
    elseif menu == 3 then
        EnemyLock.yawRateFar = EnemyLock.yawRateFar + 0.00005
    elseif menu == 4 then
        EnemyLock.yawRateFar = EnemyLock.yawRateFar - 0.00005
    elseif menu == 5 then
        local input = gg.prompt({"输入远处补偿值"}, {string.format("%.6f", EnemyLock.yawRateFar)}, {"number"})
        if input then
            EnemyLock.yawRateFar = tonumber(input[1]) or EnemyLock.yawRateFar
        end
    end
    
    if menu then
        提示("远处补偿: " .. string.format("%.6f", EnemyLock.yawRateFar))
    end
end

function 设置分界距离()
    local input = gg.prompt({"输入分界距离（米）"}, {tostring(EnemyLock.distThreshold)}, {"number"})
    if input then
        EnemyLock.distThreshold = tonumber(input[1]) or EnemyLock.distThreshold
        提示("分界距离: " .. EnemyLock.distThreshold .. "米")
    end
end

function 设置垂直补偿()
    local current = (EnemyLock.pitchRate ~= nil) and string.format("%.8f", EnemyLock.pitchRate) or "nil"
    
    local menu = gg.choice({
        "+0.00001 (向上修正)",
        "-0.00001 (向下修正)",
        "+0.00005 (向上粗调)",
        "-0.00005 (向下粗调)",
        "设为 nil (关闭Y轴补偿)",
        "自定义输入"
    }, nil, "当前垂直补偿: " .. current)
    
    if menu == 1 then
        EnemyLock.pitchRate = (EnemyLock.pitchRate or 0) + 0.00001
        提示("垂直补偿: " .. string.format("%.8f", EnemyLock.pitchRate))
    elseif menu == 2 then
        EnemyLock.pitchRate = (EnemyLock.pitchRate or 0) - 0.00001
        提示("垂直补偿: " .. string.format("%.8f", EnemyLock.pitchRate))
    elseif menu == 3 then
        EnemyLock.pitchRate = (EnemyLock.pitchRate or 0) + 0.00005
        提示("垂直补偿: " .. string.format("%.8f", EnemyLock.pitchRate))
    elseif menu == 4 then
        EnemyLock.pitchRate = (EnemyLock.pitchRate or 0) - 0.00005
        提示("垂直补偿: " .. string.format("%.8f", EnemyLock.pitchRate))
    elseif menu == 5 then
        EnemyLock.pitchRate = nil
        提示("Y轴补偿已关闭")
    elseif menu == 6 then
        local default = (EnemyLock.pitchRate ~= nil) and string.format("%.8f", EnemyLock.pitchRate) or ""
        local input = gg.prompt({"输入垂直补偿值 (留空表示 nil)"}, {default}, {"text"})
        if input then
            if input[1] == "" then
                EnemyLock.pitchRate = nil
                提示("Y轴补偿已关闭")
            else
                local val = tonumber(input[1])
                if val then
                    EnemyLock.pitchRate = val
                    提示("垂直补偿: " .. string.format("%.8f", EnemyLock.pitchRate))
                end
            end
        end
    end
end

local 已选中的玩家 = {}

function 选择要显示的玩家()
    if not _G.PlayerData or #_G.PlayerData == 0 then
        提示("请先初始化玩家数据")
        return false
    end
    
    local playerCount = #_G.PlayerData
    local options = {}
    
    for i = 1, playerCount do
        local distStr = ""
        if selfXAddr and selfZAddr then
            local player = _G.PlayerData[i]
            if player and player.address and player.address ~= 0 then
                local success, enemyCoords = pcall(gg.getValues, {
                    {address = player.address + 0x24, flags = gg.TYPE_FLOAT},
                    {address = player.address + 0x28, flags = gg.TYPE_FLOAT},
                    {address = player.address + 0x2C, flags = gg.TYPE_FLOAT}
                })
                
                if success and enemyCoords and enemyCoords[1] and enemyCoords[2] and enemyCoords[3] then
                    local success2, selfCoords = pcall(gg.getValues, {
                        {address = selfXAddr, flags = gg.TYPE_FLOAT},
                        {address = selfYAddr, flags = gg.TYPE_FLOAT},
                        {address = selfZAddr, flags = gg.TYPE_FLOAT}
                    })
                    
                    if success2 and selfCoords and selfCoords[1] and selfCoords[2] and selfCoords[3] then
                        local dx = enemyCoords[1].value - selfCoords[1].value
                        local dy = enemyCoords[2].value - selfCoords[2].value
                        local dz = enemyCoords[3].value - selfCoords[3].value
                        local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
                        distStr = string.format(" [%.0f米]", dist)
                    end
                end
            end
        end
        options[i] = "玩家 " .. i .. distStr
    end
    
    local selected = gg.multiChoice(options, nil, "选择要显示的玩家")
    
    if not selected then
        已选中的玩家 = {}
        提示("已取消选择")
        return false
    end
    
    local newSelection = {}
    for idx, _ in pairs(selected) do
        local i = tonumber(idx)
        if i then
            table.insert(newSelection, i)
        end
    end
    
    if #newSelection == 0 then
        已选中的玩家 = {}
        提示("未选择任何玩家")
        return false
    end
    
    已选中的玩家 = newSelection
    
    for _, i in ipairs(已选中的玩家) do
        创建按钮页面("玩家" .. i, function()
            luajava.newThread(function()
                if fw1 then
                    EnemyLock:stop()
                    gg.sleep(100)
                end
                EnemyLock:start(i)
            end):start()
        end)
    end
    
    创建按钮页面("停止自瞄", function()
        luajava.newThread(function()
            if fw1 then
                EnemyLock:stop()
                提示("自瞄已停止")
                gg.sleep(200)
            else
                提示("自瞄未运行")
            end
        end):start()
    end)
    
    提示("已选择 " .. #已选中的玩家 .. " 个玩家")
    return true
end

function 打开玩家列表()
    if #已选中的玩家 == 0 then
        提示("请先选择要显示的玩家")
        return
    end
    
    for _, i in ipairs(已选中的玩家) do
        打开页面("玩家" .. i)
    end
    打开页面("停止自瞄")
end

function 关闭玩家列表()
    for _, i in ipairs(已选中的玩家) do
        关闭页面("玩家" .. i)
    end
    关闭页面("停止自瞄")
    if fw1 then
        EnemyLock:stop()
        gg.sleep(200)
    end
    已选中的玩家 = {}
end

local 视角锁敌开关 = false

创建开关页面("视角锁敌", 
    function()
        if not _G.PlayerData or #_G.PlayerData == 0 then
            提示("请先初始化玩家数据")
            return
        end
        
        if not selfXAddr or not selfZAddr or not ViewControl.yawAddr then
            提示("请先初始化数据")
            return
        end
        
        local success, selfCoords = pcall(gg.getValues, {
            {address = selfXAddr, flags = gg.TYPE_FLOAT},
            {address = selfZAddr, flags = gg.TYPE_FLOAT}
        })
        if not success or not selfCoords then
            提示("获取自身坐标失败")
            return
        end
        
        local selfX = selfCoords[1].value
        local selfZ = selfCoords[2].value
        
        local success2, currentYawVal = pcall(gg.getValues, {{address = ViewControl.yawAddr, flags = gg.TYPE_FLOAT}})
        if not success2 or not currentYawVal or not currentYawVal[1] then
            提示("获取视角失败")
            return
        end
        local currentYaw = currentYawVal[1].value
        
        local bestAngle = 999
        local bestIndex = nil
        
        for i = 1, #_G.PlayerData do
            local player = _G.PlayerData[i]
            if player and player.address and player.address ~= 0 then
                local success3, enemyCoords = pcall(gg.getValues, {
                    {address = player.address + 0x24, flags = gg.TYPE_FLOAT},
                    {address = player.address + 0x2C, flags = gg.TYPE_FLOAT}
                })
                
                if success3 and enemyCoords and enemyCoords[1] and enemyCoords[2] then
                    local enemyX = enemyCoords[1].value
                    local enemyZ = enemyCoords[2].value
                    
                    if math.abs(enemyX - selfX) > 1 or math.abs(enemyZ - selfZ) > 1 then
                        local dx = enemyX - selfX
                        local dz = enemyZ - selfZ
                        local targetYaw = math.atan2(dx, dz)
                        
                        local angleDiff = math.abs(targetYaw - currentYaw)
                        if angleDiff > math.pi then
                            angleDiff = 2 * math.pi - angleDiff
                        end
                        
                        if angleDiff < bestAngle then
                            bestAngle = angleDiff
                            bestIndex = i
                        end
                    end
                end
            end
        end
        
        if bestIndex then
            if fw1 then
                EnemyLock:stop()
                gg.sleep(100)
            end
            EnemyLock:start(bestIndex)
            视角锁敌开关 = true
            提示("已锁定玩家" .. bestIndex)
        else
            提示("未找到敌人")
        end
    end,
    function()
        视角锁敌开关 = false
        if fw1 then
            EnemyLock:stop()
            gg.sleep(200)
        end
        提示("视角锁敌已关闭")
    end
)

function 设置固定偏移()
    EnemyLock:promptOffset()
end
















local baseModules = {
    4020, 2040, 2030, 2020, 2050, 3100, 3030, 3020, 3080, 3090
}
local baseModuleNames = {
    [4020] = "上等兵 1级", [2040] = "缺角方 1级", [2030] = "棱锥1-1 1级",
    [2020] = "斜面1-1 1级", [2050] = "透明魔方 1级", [3100] = "漫步 1级",
    [3030] = "鹰驰 1级", [3020] = "悦动 1级", [3080] = "天马人 1级",
    [3090] = "腾跃 1级"
}
local moduleDB = {
    [2010] = "魔方1-1 1级", [2020] = "斜面1-1 1级", [2030] = "棱锥1-1 1级",
    [2040] = "缺角方 1级", [2050] = "透明魔方 1级", [3020] = "悦动 1级",
    [3030] = "鹰驰 1级", [3080] = "天马人 1级", [3090] = "腾跃 1级",
    [4020] = "上等兵 1级", [4040] = "午夜派对 1级", [4050] = "穹弩 1级",
    [4060] = "天罚 1级", [4070] = "皇家礼炮 1级", [4090] = "小飞侠 1级",
    [5010] = "小指头 1级", [5020] = "特斯拉的巨剑 1级", [9010] = "天眼 1级",
    [10010] = "大力神 1级", [2011] = "魔方1-1 2级", [2012] = "魔方1-1 3级",
    [2021] = "斜面1-1 2级", [2031] = "棱锥1-1 2级", [2041] = "缺角方 2级",
    [2042] = "棱锥1-2 1级", [2043] = "棱锥1-3 1级", [2044] = "棱锥1-4 1级",
    [2045] = "斜面1-2 1级", [2046] = "斜面1-3 1级", [2047] = "魔方1-2 1级",
    [2048] = "斜面1-4 1级", [2049] = "圆柱1-1 1级", [2051] = "圆柱1-2 1级",
    [2052] = "圆柱1-3 1级", [2053] = "圆柱1-4 1级", [2054] = "圆柱1-5 1级",
    [2055] = "圆柱1-6 1级", [2056] = "圆柱1-7 1级", [2057] = "圆柱1-8 1级",
    [2058] = "圆柱1-9 1级", [2059] = "球体1-1 1级", [3021] = "悦动 2级",
    [3022] = "悦动 3级", [3031] = "鹰驰 2级", [3032] = "鹰驰 3级",
    [3081] = "天马人 2级", [3082] = "天马人 3级", [3091] = "腾跃 2级",
    [3092] = "腾跃 3级", [4021] = "上等兵 2级", [4022] = "上等兵 3级",
    [4041] = "午夜派对 2级", [4042] = "午夜派对 3级", [4051] = "穹弩 2级",
    [4052] = "穹弩 3级", [4061] = "天罚 2级", [4062] = "天罚 3级",
    [4071] = "皇家礼炮 2级", [4072] = "皇家礼炮 3级", [4091] = "小飞侠 2级",
    [4092] = "小飞侠 3级", [5011] = "小指头 2级", [5012] = "小指头 3级",
    [5021] = "特斯拉的巨剑 2级", [5022] = "特斯拉的巨剑 3级", [6010] = "布道行者 1级",
    [6011] = "布道行者 2级", [6012] = "布道行者 3级", [7020] = "海王盾 1级",
    [7021] = "海王盾 2级", [7022] = "海王盾 3级", [9011] = "天眼 2级",
    [9012] = "天眼 3级", [10011] = "大力神 2级", [10012] = "大力神 3级",
    [3200] = "猛犸", [3210] = "奔狼", [3503010] = "变奏舞步", [3203010] = "方舟",
    [3403020] = "音速", [3403010] = "旋风", [3410010] = "蓝火", [3302010] = "重装魔方",
    [3303070] = "天行者", [3604010] = "追猎", [3604020] = "陨星", [4100] = "老派左轮",
    [4140] = "碧蓝使者", [3204010] = "辉光", [3204020] = "殉道者", [3404010] = "球状闪电",
    [3104010] = "穿云", [3304010] = "业火焚世", [3305010] = "地狱之刃", [3704020] = "防空炮",
    [3704010] = "裂空", [4110] = "寂静之声", [4120] = "霜鸟", [11040] = "狡诈疑象",
    [11010] = "光学隐身", [11020] = "捍卫者", [11030] = "魔术师", [3511010] = "泡泡枪",
    [3511020] = "闪耀星光", [3511030] = "时光船锚", [3211040] = "斥械心环", [3211020] = "严霜界碑",
    [3211010] = "空之握", [3411010] = "零度领域", [3411020] = "第四引力", [3111010] = "斥星",
    [3111020] = "索隐", [3111030] = "无畏者", [3111050] = "推恩官", [3111040] = "狼群",
    [3311020] = "建造者", [2013030] = "终场谢幕", [2013010] = "量子悖论", [3104020] = "蜂巢",
    [3111060] = "千面", [3307010] = "苍穹守护", [3612010] = "角鹰", [3612020] = "渡鸦",
    [3612030] = "黑尾", [3612050] = "野蜂", [3612040] = "小叮当", [12010] = "喇叭",
    [12020] = "滑翔翼", [12030] = "加农炮", [12040] = "灯箱", [3412020] = "电子目镜",
    [3412030] = "定风翼", [3412010] = "前扰流板", [12050] = "小型前扰流板", [12060] = "尾翼-支架",
    [6001001] = "逻辑-死亡节点(无敌)",[6001002] = "逻辑-与门节点(无敌)",[6001003] = "逻辑-开关节点(无敌)",
    [12070] = "尾翼-梁翼", [12080] = "尾翼-风翼", [3612060] = "火枪手", [12090] = "骰子(废稿)"
}

local AUTO_SELECT_CONFIG_FILE = "/storage/emulated/0/长安/列表改模块/auto_select_config.txt"
local currentBaseModules = {}
local currentBaseModuleNames = {}

function loadAutoSelectConfig()
    local file = io.open(AUTO_SELECT_CONFIG_FILE, "r")
    if file then
        currentBaseModules = {}
        for line in file:lines() do
            local id = tonumber(line:match("^%s*(%d+)%s*$"))
            if id then table.insert(currentBaseModules, id) end
        end
        file:close()
        if #currentBaseModules == 0 then
            useDefaultAutoSelectConfig()
        else
            currentBaseModuleNames = {}
            for _, id in ipairs(currentBaseModules) do
                currentBaseModuleNames[id] = baseModuleNames[id] or getModuleName(id) or "未知模块"
            end
        end
    else
        useDefaultAutoSelectConfig()
    end
end

function useDefaultAutoSelectConfig()
    currentBaseModules = {}
    for _, id in ipairs(baseModules) do table.insert(currentBaseModules, id) end
    currentBaseModuleNames = {}
    for id, name in pairs(baseModuleNames) do currentBaseModuleNames[id] = name end
end

function saveAutoSelectConfig()
    local dir = AUTO_SELECT_CONFIG_FILE:match("(.+)/[^/]+$")
    if dir then os.execute("mkdir -p " .. dir) end
    local file = io.open(AUTO_SELECT_CONFIG_FILE, "w")
    if file then
        for _, id in ipairs(currentBaseModules) do file:write(id .. "\n") end
        file:close()
        return true
    end
    return false
end

function resetAutoSelectConfig()
    useDefaultAutoSelectConfig()
    saveAutoSelectConfig()
    提示("自动选择模块列表已重置为默认")
end

function getCurrentBaseModules()
    return currentBaseModules
end

function getCurrentBaseModuleNames()
    return currentBaseModuleNames
end

local mokuai = 0
local yixiougaimokuaiid = nil
local mokuaisavedItems = {}
local modifiedHistory = {}
local MOKUAI_CACHE = nil
local SELECTION_COUNT_FILE = "/storage/emulated/0/长安/列表改模块/selection_count.txt"
local selectionCounts = {}

function loadSelectionCounts()
    selectionCounts = {}
    local dirPath = SELECTION_COUNT_FILE:match("(.+)/[^/]+$")
    if dirPath then os.execute("mkdir -p '" .. dirPath .. "'") end
    local file = io.open(SELECTION_COUNT_FILE, "r")
    if file then
        for line in file:lines() do
            local moduleID, count = line:match("(%d+)=(%d+)")
            if moduleID and count then selectionCounts[tonumber(moduleID)] = tonumber(count) end
        end
        file:close()
    end
end

function saveSelectionCounts()
    local file = io.open(SELECTION_COUNT_FILE, "w")
    if not file then return end
    for moduleID, count in pairs(selectionCounts) do file:write(moduleID .. "=" .. count .. "\n") end
    file:close()
end

function incrementSelectionCount(moduleID)
    selectionCounts[moduleID] = (selectionCounts[moduleID] or 0) + 1
    saveSelectionCounts()
end

function getSelectionCount(moduleID)
    return selectionCounts[moduleID] or 0
end

loadSelectionCounts()

function getNextAvailableModule(avoidID)
    local usedModules = {}
    for _, history in ipairs(modifiedHistory) do usedModules[history.原始ID] = true end
    for _, baseID in ipairs(currentBaseModules) do
        if not usedModules[baseID] and (avoidID == nil or baseID ~= avoidID) then
            return baseID
        end
    end
    return nil
end

function writeMokuaiCache(id)
    MOKUAI_CACHE = tostring(id)
end

function readMokuaiCache()
    if not MOKUAI_CACHE or MOKUAI_CACHE == "" then return nil end
    return MOKUAI_CACHE
end

function getModuleName(id)
    local name = baseModuleNames[tonumber(id)] or moduleDB[tonumber(id)]
    return name or "自定义模块"
end

function gaimokuai(mokuaiid, mokuainame)
    local baseID = getNextAvailableModule(mokuaiid)
    if not baseID then
        提示("所有基础模块都已被修改或无可用的模块，请先恢复")
        return
    end
    if baseID == mokuaiid then
        baseID = getNextAvailableModule(mokuaiid)
        if not baseID then
            提示("无可用的不同模块，请先恢复")
            return
        end
    end
    gg.clearResults()
    gg.searchNumber(tostring(baseID), gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0, gg.PROCESS_MEMORY)
    local results = gg.getResults(1000)
    if not results or #results == 0 then
        提示("未搜索到ID为 "..baseID.." 的数据，请检查游戏是否开启")
        return
    end
    local savedData = {}
    for i, v in ipairs(results) do
        table.insert(savedData, {address = v.address, flags = gg.TYPE_DWORD, value = v.value})
    end
    for _, item in ipairs(savedData) do table.insert(mokuaisavedItems, item) end
    gg.editAll(mokuaiid, gg.TYPE_DWORD)
    table.insert(modifiedHistory, {
        原始ID = baseID,
        原始名称 = currentBaseModuleNames[baseID] or "未知模块",
        目标ID = mokuaiid,
        目标名称 = mokuainame,
        savedData = savedData
    })
    yixiougaimokuaiid = mokuaiid
    mokuai = 1
    gg.clearResults()
    local baseName = currentBaseModuleNames[baseID] or "未知模块"
    提示(string.format("%s (ID:%d) → %s (ID:%d)\n共修改 %d 个数据", baseName, baseID, mokuainame, mokuaiid, #savedData))
end

function unifiedModifyDialog()
    local options = {
        "自动选择修改", "指定修改-列表选择", "指定修改-手动输入",
        "查看选择次数统计", "清除选择次数统计", "配置自动选择模块列表"
    }
    local choice = gg.choice(options, nil, "选择修改方式")
    if choice == 1 then
        customGaimokuai()
    elseif choice == 2 then
        modifyBySelection()
    elseif choice == 3 then
        modifyByInput()
    elseif choice == 4 then
        viewSelectionCounts()
        unifiedModifyDialog()
    elseif choice == 5 then
        clearSelectionCounts()
        unifiedModifyDialog()
    elseif choice == 6 then
        configureAutoSelect()
        unifiedModifyDialog()
    else
        提示("已取消操作")
    end
end

function showCurrentStatus()
    if #modifiedHistory == 0 then
        提示("当前状态：没有模块被修改")
        return
    end
    local totalDataCount = 0
    local msg = string.format("=== 当前修改状态 (共 %d 个模块) ===\n\n", #modifiedHistory)
    for i, history in ipairs(modifiedHistory) do
        local sourceName = history.原始名称 or currentBaseModuleNames[history.原始ID] or "未知模块"
        local targetName = history.目标名称 or moduleDB[history.目标ID] or "自定义模块"
        local dataCount = #history.savedData
        totalDataCount = totalDataCount + dataCount
        msg = msg .. string.format("%d. %s (ID:%d) → %s (ID:%d) [%d个数据]\n", i, sourceName, history.原始ID, targetName, history.目标ID, dataCount)
    end
    msg = msg .. string.format("\n总计: %d 个模块，共修改 %d 个数据", #modifiedHistory, totalDataCount)
    gg.alert(msg, "确定")
end

function huifusuoyou()
    if #modifiedHistory == 0 then
        提示("没有需要恢复的模块")
        return
    end
    local recoveryData = {}
    local totalDataCount = 0
    for _, history in ipairs(modifiedHistory) do
        if history.savedData then
            for _, item in ipairs(history.savedData) do table.insert(recoveryData, item) end
            totalDataCount = totalDataCount + #history.savedData
        end
    end
    if #recoveryData == 0 then
        提示("未找到需要恢复的数据")
        return
    end
    gg.clearResults()
    local success, errorMsg = pcall(function() gg.setValues(recoveryData) end)
    if not success then
        提示("恢复数据时发生错误: " .. (errorMsg or "未知错误"))
        return
    end
    local resultMsg = string.format("恢复成功！\n已恢复 %d 个模块，共修改 %d 个数据\n恢复详情：\n", #modifiedHistory, totalDataCount)
    for i, history in ipairs(modifiedHistory) do
        local sourceName = history.原始名称 or currentBaseModuleNames[history.原始ID] or "未知模块"
        local targetName = history.目标名称 or moduleDB[history.目标ID] or "自定义模块"
        resultMsg = resultMsg .. string.format("%d. %s (ID:%d) → %s (ID:%d)\n", i, targetName, history.目标ID, sourceName, history.原始ID)
    end
    提示(resultMsg)
    mokuai = 0
    yixiougaimokuaiid = nil
    mokuaisavedItems = {}
    modifiedHistory = {}
    gg.clearResults()
end

function customGaimokuai()
    local DEFAULT_VALUE = "4020"
    local lastValue = DEFAULT_VALUE
    if scriptCache_custom then
        if tonumber(scriptCache_custom) then lastValue = scriptCache_custom else scriptCache_custom = nil end
    end
    if not scriptCache_custom then
        local saveFile = "/storage/emulated/0/长安/列表改模块/custom_last.txt"
        local f = io.open(saveFile, "r")
        if f then
            local line = f:read()
            f:close()
            if line then
                line = line:match("^%s*(.-)%s*$")
                local s = tonumber(line)
                if s then
                    scriptCache_custom = tostring(s)
                    lastValue = scriptCache_custom
                else
                    os.remove(saveFile)
                end
            else
                os.remove(saveFile)
            end
        end
    end
    local input = gg.prompt({'自定义模块\n大量示例请手动查看'}, {[1] = lastValue})
    if not input then
        提示("已取消操作")
        return
    end
    local gd = tonumber(input[1])
    if not gd then
        提示("输入错误，已取消")
        return
    end
    local targetName = getModuleName(gd)
    if targetName == "自定义模块" then
        local confirm = gg.alert(string.format("目标模块ID %d 不在已知列表中，可能无法正确修改！是否继续？", gd), "继续修改", "取消")
        if confirm ~= 1 then
            提示("已取消修改")
            return
        end
    end
    scriptCache_custom = tostring(gd)
    local saveDir = "/storage/emulated/0/长安/列表改模块"
    local saveFile = saveDir .. "/custom_last.txt"
    os.execute("mkdir -p " .. saveDir)
    local f = io.open(saveFile, "w")
    if f then f:write(gd) f:close() end
    writeMokuaiCache(gd)
    gaimokuai(gd, targetName)
end

function string:split(delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(self, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert(result, string.sub(self, from))
    return result
end

function getAllKnownModules()
    local modules = {}
    for _, id in ipairs(currentBaseModules) do
        local name = currentBaseModuleNames[id] or "未知"
        table.insert(modules, {id = id, name = name, type = "基础模块", count = getSelectionCount(id)})
    end
    for id, name in pairs(moduleDB) do
        local isBase = false
        for _, baseId in ipairs(currentBaseModules) do if baseId == id then isBase = true break end end
        if not isBase then
            table.insert(modules, {id = id, name = name, type = "自定义模块", count = getSelectionCount(id)})
        end
    end
    table.sort(modules, function(a,b)
        if a.count ~= b.count then return a.count > b.count end
        if a.type == "基础模块" and b.type ~= "基础模块" then return true
        elseif a.type ~= "基础模块" and b.type == "基础模块" then return false end
        return a.name < b.name
    end)
    return modules
end

function selectModule(promptTitle)
    local rawModules = getAllKnownModules()
    local allModules = rawModules
    local menuItems = {"🔍 搜索"}
    for _, module in ipairs(allModules) do
        local countText = module.count > 0 and string.format(" [%d次]", module.count) or ""
        table.insert(menuItems, string.format("[%s] %s (ID:%d)%s", module.type, module.name, module.id, countText))
    end
    local history = {menuItems}
    local currentItems = menuItems
    while true do
        local currentCount = #currentItems - 1
        local title = string.format("%s (共%d个模块)", promptTitle, currentCount)
        local choice = gg.choice(currentItems, nil, title)
        if not choice then return nil end
        if #history == 1 then
            if choice == 1 then
                local input = gg.prompt({"请输入关键词"}, {""}, {"text"})
                if input and input[1] ~= "" then
                    local keyword = input[1]:lower():match("^%s*(.-)%s*$")
                    if keyword == "" then
                        gg.alert("请输入有效关键词")
                    else
                        local filtered = {"🔍 搜索"}
                        for i = 2, #currentItems do
                            if currentItems[i]:lower():find(keyword, 1, true) then
                                table.insert(filtered, currentItems[i])
                            end
                        end
                        if #filtered > 1 then
                            table.insert(history, filtered)
                            currentItems = filtered
                        else
                            gg.alert("没有找到匹配的模块")
                        end
                    end
                end
            else
                local selectedDisplay = currentItems[choice]
                local id = selectedDisplay:match("ID:(%d+)")
                if id then
                    id = tonumber(id)
                    local name = selectedDisplay:match("%] (.+) %(ID:%d+") or "未知"
                    return id, name
                else
                    gg.alert("无法解析模块ID，请重试")
                end
            end
        else
            if choice == 1 then
                local adminOptions = {"搜索模块", "返回上一页", "取消选择"}
                local adminChoice = gg.choice(adminOptions, nil, "管理菜单")
                if adminChoice then
                    local selectedAdmin = adminOptions[adminChoice]
                    if selectedAdmin == "搜索模块" then
                        local input = gg.prompt({"请输入关键词"}, {""}, {"text"})
                        if input and input[1] ~= "" then
                            local keyword = input[1]:lower():match("^%s*(.-)%s*$")
                            if keyword == "" then
                                gg.alert("请输入有效关键词")
                            else
                                local filtered = {"🔍 搜索"}
                                for i = 2, #currentItems do
                                    if currentItems[i]:lower():find(keyword, 1, true) then
                                        table.insert(filtered, currentItems[i])
                                    end
                                end
                                if #filtered > 1 then
                                    table.insert(history, filtered)
                                    currentItems = filtered
                                else
                                    gg.alert("没有找到匹配的模块")
                                end
                            end
                        end
                    elseif selectedAdmin == "返回上一页" then
                        table.remove(history)
                        currentItems = history[#history]
                    end
                end
            else
                local selectedDisplay = currentItems[choice]
                local id = selectedDisplay:match("ID:(%d+)")
                if id then
                    id = tonumber(id)
                    local name = selectedDisplay:match("%] (.+) %(ID:%d+") or "未知"
                    return id, name
                else
                    gg.alert("无法解析模块ID，请重试")
                end
            end
        end
    end
end

function modifyBySelection()
    local sourceID, sourceName = selectModule("选择要被修改的模块（源模块）")
    if not sourceID then 提示("已取消操作") return end
    local targetID, targetName = selectModule("选择要修改成的模块（目标模块）")
    if not targetID then 提示("已取消操作") return end
    if sourceID == targetID then
        提示("源模块与目标模块相同，请重新选择")
        return
    end
    incrementSelectionCount(sourceID)
    incrementSelectionCount(targetID)
    local confirmMsg = string.format("确认修改:\n%s (ID:%d) → %s (ID:%d)", sourceName, sourceID, targetName, targetID)
    local confirm = gg.alert(confirmMsg, "确定修改", "取消")
    if confirm ~= 1 then 提示("已取消修改") return end
    executeModuleModification(sourceID, sourceName, targetID, targetName)
end

function modifyByInput()
    local DEFAULT_SOURCE = "4020"
    local DEFAULT_TARGET = "12040"
    local lastSourceValue = DEFAULT_SOURCE
    local lastTargetValue = DEFAULT_TARGET
    if scriptCache_source and scriptCache_target then
        if tonumber(scriptCache_source) and tonumber(scriptCache_target) then
            lastSourceValue = scriptCache_source
            lastTargetValue = scriptCache_target
        else
            scriptCache_source = nil
            scriptCache_target = nil
        end
    end
    if not scriptCache_source then
        local saveFile = "/storage/emulated/0/长安/列表改模块/last_input.txt"
        local f = io.open(saveFile, "r")
        if f then
            local line1 = f:read()
            local line2 = f:read()
            f:close()
            if line1 and line2 then
                line1 = line1:match("^%s*(.-)%s*$")
                line2 = line2:match("^%s*(.-)%s*$")
                local s = tonumber(line1)
                local t = tonumber(line2)
                if s and t then
                    scriptCache_source = tostring(s)
                    scriptCache_target = tostring(t)
                    lastSourceValue = scriptCache_source
                    lastTargetValue = scriptCache_target
                else
                    os.remove(saveFile)
                end
            else
                os.remove(saveFile)
            end
        end
    end
    local modulesInfo = "可用模块示例(共140个模块)：\n基础模块：\n"
    for _, id in ipairs(currentBaseModules) do
        modulesInfo = modulesInfo .. string.format("%s (ID:%d)\n", currentBaseModuleNames[id], id)
    end
    modulesInfo = modulesInfo .. "\n自定义模块：\n请参考提示"
    gg.alert(modulesInfo, "确定")
    local input = gg.prompt({"请输入要被修改的模块ID：", "请输入要修改成的模块ID："}, {lastSourceValue, lastTargetValue}, {"number", "number"})
    if not input then 提示("已取消操作") return end
    local sourceID = tonumber(input[1])
    local targetID = tonumber(input[2])
    if not sourceID or not targetID then 提示("输入错误，已取消") return end
    if sourceID == targetID then
        提示("源模块与目标模块相同，请重新输入")
        return
    end
    local sourceName = getModuleName(sourceID)
    local targetName = getModuleName(targetID)
    if sourceName == "自定义模块" then
        local confirm = gg.alert(string.format("源模块ID %d 不在已知列表中，是否继续？", sourceID), "继续", "取消")
        if confirm ~= 1 then 提示("已取消操作") return end
    end
    if targetName == "自定义模块" then
        local confirm = gg.alert(string.format("目标模块ID %d 不在已知列表中，是否继续？", targetID), "继续", "取消")
        if confirm ~= 1 then 提示("已取消操作") return end
    end
    incrementSelectionCount(sourceID)
    incrementSelectionCount(targetID)
    scriptCache_source = tostring(sourceID)
    scriptCache_target = tostring(targetID)
    local saveDir = "/storage/emulated/0/长安/列表改模块"
    local saveFile = saveDir .. "/last_input.txt"
    os.execute("mkdir -p " .. saveDir)
    local f = io.open(saveFile, "w")
    if f then f:write(sourceID, "\n", targetID) f:close() end
    executeModuleModification(sourceID, sourceName, targetID, targetName)
end

function executeModuleModification(sourceID, sourceName, targetID, targetName)
    if sourceID == targetID then
        提示("源模块与目标模块相同，无法修改")
        return
    end
    gg.clearResults()
    gg.searchNumber(tostring(sourceID), gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0, gg.PROCESS_MEMORY)
    local results = gg.getResults(1000)
    if not results or #results == 0 then
        提示(string.format("未搜索到ID为 %d 的模块", sourceID))
        return
    end
    local savedData = {}
    for i, v in ipairs(results) do
        table.insert(savedData, {address = v.address, flags = gg.TYPE_DWORD, value = v.value})
    end
    for _, item in ipairs(savedData) do table.insert(mokuaisavedItems, item) end
    gg.editAll(targetID, gg.TYPE_DWORD)
    table.insert(modifiedHistory, {
        原始ID = sourceID,
        原始名称 = sourceName,
        目标ID = targetID,
        目标名称 = targetName,
        savedData = savedData
    })
    yixiougaimokuaiid = targetID
    mokuai = 1
    gg.clearResults()
    提示(string.format("%s (ID:%d) → %s (ID:%d)\n共修改 %d 个数据", sourceName, sourceID, targetName, targetID, #savedData))
    writeMokuaiCache(targetID)
end

function showAllKnownModules()
    local rawModules = getAllKnownModules()
    local allModules = rawModules
    local menuItems = {"🔍 搜索"}
    for _, module in ipairs(allModules) do
        local countText = module.count > 0 and string.format(" [%d次]", module.count) or ""
        table.insert(menuItems, string.format("[%s] %s (ID:%d)%s", module.type, module.name, module.id, countText))
    end
    local history = {menuItems}
    local currentItems = menuItems
    while true do
        local currentCount = #currentItems - 1
        local title = string.format("所有已知模块列表 (共%d个模块)", currentCount)
        local choice = gg.choice(currentItems, nil, title)
        if not choice then return end
        if #history == 1 then
            if choice == 1 then
                local input = gg.prompt({"请输入关键词"}, {""}, {"text"})
                if input and input[1] ~= "" then
                    local keyword = input[1]:lower():match("^%s*(.-)%s*$")
                    if keyword == "" then
                        gg.alert("请输入有效关键词")
                    else
                        local filtered = {"🔍 搜索"}
                        for i = 2, #currentItems do
                            if currentItems[i]:lower():find(keyword, 1, true) then
                                table.insert(filtered, currentItems[i])
                            end
                        end
                        if #filtered > 1 then
                            table.insert(history, filtered)
                            currentItems = filtered
                        else
                            gg.alert("没有找到匹配的模块")
                        end
                    end
                else
                    gg.alert("搜索已取消")
                end
            else
                local selectedDisplay = currentItems[choice]
                local id = selectedDisplay:match("ID:(%d+)")
                if id then
                    id = tonumber(id)
                    local name = selectedDisplay:match("%] (.+) %(ID:%d+") or "未知"
                    gg.alert(string.format("模块详情：\n%s\nID: %d", name, id), "确定")
                end
            end
        else
            if choice == 1 then
                local adminOptions = {"搜索模块", "返回上一页", "取消"}
                local adminChoice = gg.choice(adminOptions, nil, "管理菜单")
                if adminChoice then
                    local selectedAdmin = adminOptions[adminChoice]
                    if selectedAdmin == "搜索模块" then
                        local input = gg.prompt({"请输入关键词"}, {""}, {"text"})
                        if input and input[1] ~= "" then
                            local keyword = input[1]:lower():match("^%s*(.-)%s*$")
                            if keyword == "" then
                                gg.alert("请输入有效关键词")
                            else
                                local filtered = {"🔍 搜索"}
                                for i = 2, #currentItems do
                                    if currentItems[i]:lower():find(keyword, 1, true) then
                                        table.insert(filtered, currentItems[i])
                                    end
                                end
                                if #filtered > 1 then
                                    table.insert(history, filtered)
                                    currentItems = filtered
                                else
                                    gg.alert("没有找到匹配的模块")
                                end
                            end
                        end
                    elseif selectedAdmin == "返回上一页" then
                        table.remove(history)
                        currentItems = history[#history]
                    end
                end
            else
                local selectedDisplay = currentItems[choice]
                local id = selectedDisplay:match("ID:(%d+)")
                if id then
                    id = tonumber(id)
                    local name = selectedDisplay:match("%] (.+) %(ID:%d+") or "未知"
                    gg.alert(string.format("模块详情：\n%s\nID: %d", name, id), "确定")
                end
            end
        end
    end
end

function viewSelectionCounts()
    if not next(selectionCounts) then
        提示("暂无选择次数统计")
        return
    end
    local msg = "=== 模块选择次数统计 ===\n\n"
    local sortedModules = {}
    for id, count in pairs(selectionCounts) do
        table.insert(sortedModules, {id = id, count = count, name = getModuleName(id)})
    end
    table.sort(sortedModules, function(a,b)
        if a.count ~= b.count then return a.count > b.count end
        return a.name < b.name
    end)
    for i, module in ipairs(sortedModules) do
        msg = msg .. string.format("%d. %s (ID:%d) - %d次\n", i, module.name, module.id, module.count)
    end
    msg = msg .. string.format("\n总计: %d 个模块有选择记录", #sortedModules)
    gg.alert(msg, "确定")
end

function clearSelectionCounts()
    selectionCounts = {}
    saveSelectionCounts()
    提示("选择次数统计已清空")
end

function showCurrentAutoSelectList()
    if #currentBaseModules == 0 then return "（空列表）" end
    local lines = {}
    for i, id in ipairs(currentBaseModules) do
        local name = currentBaseModuleNames[id] or getModuleName(id) or "未知"
        lines[i] = string.format("%d. %s (ID:%d)", i, name, id)
    end
    return table.concat(lines, "\n")
end

function configureAutoSelect()
    while true do
        local listText = showCurrentAutoSelectList()
        local menu = {}
        table.insert(menu, listText)
        table.insert(menu, "添加模块")
        table.insert(menu, "删除模块")
        table.insert(menu, "调整顺序")
        table.insert(menu, "重置为默认列表")
        table.insert(menu, "保存并返回")
        
        local choice = gg.choice(menu, nil, "自动选择模块配置")
        if not choice then break end
        
        if choice == 1 then
        elseif choice == 2 then
            addModulesToAutoSelect()
        elseif choice == 3 then
            removeModuleFromAutoSelect()
        elseif choice == 4 then
            reorderAutoSelectModules()
        elseif choice == 5 then
            local confirm = gg.alert("确认重置为默认模块列表吗？", "重置", "取消")
            if confirm == 1 then resetAutoSelectConfig() end
        elseif choice == 6 then
            saveAutoSelectConfig()
            提示("配置已保存")
            break
        end
    end
end

local function swap(t, i, j)
    t[i], t[j] = t[j], t[i]
end

local function moveUpSelected(t, selectedIndices)
    if #selectedIndices == 0 then return end
    table.sort(selectedIndices)
    local first = selectedIndices[1]
    if first == 1 then return end

    local values = {}
    for i, idx in ipairs(selectedIndices) do
        values[i] = t[idx]
    end

    for i = #selectedIndices, 1, -1 do
        table.remove(t, selectedIndices[i])
    end

    local insertPos = first - 1
    for i, v in ipairs(values) do
        table.insert(t, insertPos + i - 1, v)
    end
end

local function moveDownSelected(t, selectedIndices)
    if #selectedIndices == 0 then return end
    table.sort(selectedIndices)
    local last = selectedIndices[#selectedIndices]
    local hasAfter = false
    for i = last + 1, #t do
        local isSelected = false
        for _, idx in ipairs(selectedIndices) do
            if idx == i then isSelected = true break end
        end
        if not isSelected then
            hasAfter = true
            break
        end
    end
    if not hasAfter then return end

    local values = {}
    for i, idx in ipairs(selectedIndices) do
        values[i] = t[idx]
    end

    for i = #selectedIndices, 1, -1 do
        table.remove(t, selectedIndices[i])
    end

    local beforeCount = 0
    for _, idx in ipairs(selectedIndices) do
        if idx < last then beforeCount = beforeCount + 1 end
    end
    local insertPos = last - beforeCount + 1
    for i, v in ipairs(values) do
        table.insert(t, insertPos + i - 1, v)
    end
end

local function moveToTopSelected(t, selectedIndices)
    if #selectedIndices == 0 then return end
    table.sort(selectedIndices)
    local values = {}
    for i, idx in ipairs(selectedIndices) do
        values[i] = t[idx]
    end
    for i = #selectedIndices, 1, -1 do
        table.remove(t, selectedIndices[i])
    end
    for i, v in ipairs(values) do
        table.insert(t, i, v)
    end
end

local function moveToBottomSelected(t, selectedIndices)
    if #selectedIndices == 0 then return end
    table.sort(selectedIndices)
    local values = {}
    for i, idx in ipairs(selectedIndices) do
        values[i] = t[idx]
    end
    for i = #selectedIndices, 1, -1 do
        table.remove(t, selectedIndices[i])
    end
    for _, v in ipairs(values) do
        table.insert(t, v)
    end
end

function addModulesToAutoSelect()
    local input = gg.prompt({"搜索关键词（留空则显示全部）"}, {""}, {"text"})
    if not input then
        提示("已取消")
        return
    end
    local keyword = input[1]:lower():match("^%s*(.-)%s*$")

    local allModules = getAllKnownModules()
    local moduleList = {}
    for _, mod in ipairs(allModules) do
        moduleList[#moduleList+1] = {
            id = mod.id,
            display = string.format("%s (ID:%d)", mod.name, mod.id)
        }
    end

    local filtered = {}
    if keyword == "" then
        filtered = moduleList
    else
        for _, item in ipairs(moduleList) do
            if item.display:lower():find(keyword, 1, true) then
                table.insert(filtered, item)
            end
        end
        if #filtered == 0 then
            gg.alert("没有找到匹配的模块")
            return
        end
    end

    local displayItems = {}
    for _, item in ipairs(filtered) do
        table.insert(displayItems, item.display)
    end

    local selected = gg.multiChoice(displayItems, nil, "请选择要添加的模块（可多选）")
    if not selected then
        提示("已取消")
        return
    end

    local selectedIds = {}
    for i = 1, #displayItems do
        if selected[i] then
            table.insert(selectedIds, filtered[i].id)
        end
    end

    if #selectedIds == 0 then
        提示("未选择任何模块")
        return
    end

    local addedCount = 0
    for _, id in ipairs(selectedIds) do
        local exists = false
        for _, existId in ipairs(currentBaseModules) do
            if existId == id then exists = true break end
        end
        if not exists then
            table.insert(currentBaseModules, id)
            currentBaseModuleNames[id] = getModuleName(id)
            addedCount = addedCount + 1
        end
    end

    if addedCount > 0 then
        saveAutoSelectConfig()
        提示(string.format("已添加 %d 个模块到列表末尾", addedCount))
    else
        提示("所选模块均已存在，未添加")
    end
end

function removeModuleFromAutoSelect()
    if #currentBaseModules == 0 then
        提示("列表为空，无法删除")
        return
    end
    local displayItems = {}
    for i, id in ipairs(currentBaseModules) do
        local name = currentBaseModuleNames[id] or getModuleName(id) or "未知"
        displayItems[i] = string.format("%d. %s (ID:%d)", i, name, id)
    end

    local selected = gg.multiChoice(displayItems, nil, "请选择要删除的模块（多选）")
    if not selected then
        提示("已取消")
        return
    end

    local toDelete = {}
    for i = 1, #displayItems do
        if selected[i] then
            table.insert(toDelete, i)
        end
    end

    if #toDelete == 0 then
        提示("未选择任何模块")
        return
    end

    table.sort(toDelete, function(a,b) return a > b end)

    local deletedNames = {}
    for _, idx in ipairs(toDelete) do
        local id = currentBaseModules[idx]
        local name = currentBaseModuleNames[id] or getModuleName(id) or "未知"
        table.insert(deletedNames, string.format("%s (ID:%d)", name, id))
        table.remove(currentBaseModules, idx)
        currentBaseModuleNames[id] = nil
    end

    if #deletedNames > 0 then
        saveAutoSelectConfig()
        提示("已删除以下模块：\n" .. table.concat(deletedNames, "\n"))
    else
        提示("未删除任何模块")
    end
end

function reorderAutoSelectModules()
    if #currentBaseModules < 2 then
        提示("至少需要两个模块才能调整顺序")
        return
    end

    local function buildDisplayList()
        local lines = {}
        for i, id in ipairs(currentBaseModules) do
            local name = currentBaseModuleNames[id] or getModuleName(id) or "未知"
            lines[i] = string.format("%d. %s (ID:%d)", i, name, id)
        end
        return lines
    end

    local modeChoice = gg.choice({"单个移动", "批量移动"}, nil, "请选择操作模式")
    if not modeChoice then return end

    if modeChoice == 1 then
        local options = {"取消"}
        for i, id in ipairs(currentBaseModules) do
            local name = currentBaseModuleNames[id] or getModuleName(id) or "未知"
            table.insert(options, string.format("%d. %s (ID:%d)", i, name, id))
        end
        local choice = gg.choice(options, nil, "选择要移动的模块")
        if not choice or choice == 1 then return end
        local idx = choice - 1
        local moveOptions = {"上移", "下移", "顶置", "置底", "取消"}
        local move = gg.choice(moveOptions, nil, string.format("移动第 %d 个模块", idx))
        if not move or move == 5 then return end

        if move == 1 then
            if idx > 1 then
                swap(currentBaseModules, idx, idx - 1)
                提示("已上移")
                saveAutoSelectConfig()
            else
                提示("已在最顶部，无法上移")
            end
        elseif move == 2 then
            if idx < #currentBaseModules then
                swap(currentBaseModules, idx, idx + 1)
                提示("已下移")
                saveAutoSelectConfig()
            else
                提示("已在最底部，无法下移")
            end
        elseif move == 3 then
            if idx > 1 then
                local item = currentBaseModules[idx]
                table.remove(currentBaseModules, idx)
                table.insert(currentBaseModules, 1, item)
                提示("已顶置")
                saveAutoSelectConfig()
            else
                提示("已在最顶部，无需顶置")
            end
        elseif move == 4 then
            if idx < #currentBaseModules then
                local item = currentBaseModules[idx]
                table.remove(currentBaseModules, idx)
                table.insert(currentBaseModules, item)
                提示("已置底")
                saveAutoSelectConfig()
            else
                提示("已在最底部，无需置底")
            end
        end
    else
        local display = buildDisplayList()
        local selected = gg.multiChoice(display, nil, "请选择要移动的模块（可多选）")
        if not selected then
            提示("未选择任何模块")
            return
        end

        local selectedIndices = {}
        for i = 1, #display do
            if selected[i] then
                table.insert(selectedIndices, i)
            end
        end

        if #selectedIndices == 0 then
            提示("未选择任何模块")
            return
        end

        local batchOptions = {"上移", "下移", "顶置", "置底", "取消"}
        local batchMove = gg.choice(batchOptions, nil, "选择批量操作")
        if not batchMove or batchMove == 5 then return end

        table.sort(selectedIndices)

        if batchMove == 1 then
            moveUpSelected(currentBaseModules, selectedIndices)
            提示("批量上移完成")
            saveAutoSelectConfig()
        elseif batchMove == 2 then
            moveDownSelected(currentBaseModules, selectedIndices)
            提示("批量下移完成")
            saveAutoSelectConfig()
        elseif batchMove == 3 then
            moveToTopSelected(currentBaseModules, selectedIndices)
            提示("批量顶置完成")
            saveAutoSelectConfig()
        elseif batchMove == 4 then
            moveToBottomSelected(currentBaseModules, selectedIndices)
            提示("批量置底完成")
            saveAutoSelectConfig()
        end
    end
end

loadAutoSelectConfig()
















function 游戏闪退()
    gg.clearResults()
    gg.searchNumber(1, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, nil)
    local t = {}
    for i, v in ipairs(gg.getResults(50000)) do
        t[#t + 1] = {address = v.address, flags = gg.TYPE_DWORD, value = 999}
        if #t >= 1000 then
            gg.setValues(t)
            t = {}
        end
    end
    gg.clearResults()
    if #t > 0 then gg.setProcessX() end
end




local FOLDER_PATH = "/storage/emulated/0/长安/改核心"
local FILE_PATH = FOLDER_PATH .. "/核心.txt"
local RECORD_FILE = FOLDER_PATH .. "/列表选择记录.txt"
local SCRIPT_CACHE = nil

local coreDB = {
    [1130] = "序列",[1120] = "赋能",[1110] = "铁驭",[1101] = "火萤",
    [1091] = "铠鼠",[1071] = "幻灵",[1051] = "风声",[1031] = "大家伙",
    [1021] = "网虫",[1011] = "夜莺",[1041] = "火力小车",[1042] = "玩具小车",
    [6001001] = "逻辑-死亡节点(无敌)",[6001002] = "逻辑-与门节点(无敌)",[6001003] = "逻辑-开关节点(无敌)",
    [1043] = "军事小车",[1044] = "圣诞小车",[1045] = "铁皮小车",
    [1061] = "一级炮台",[1062] = "二级炮台",[1065] = "三级炮台",
    [1063] = "炮台-蒸汽",[1064] = "炮台-玩具",[1066] = "炮台-白色",
    [1067] = "炮台-量子特攻",[1068] = "炮台-建造",[1069] = "炮台-圣诞",
    [1070] = "炮台-小飞龙白色",[1072] = "炮台-小飞龙紫色",[1073] = "炮台-小飞龙红色",
    [1081] = "冰墙核心",[1082] = "冰墙-冰河世纪",[3612041] = "航拍无人机"
}

local clickRecords, recordsLoaded, initialized = {}, false, false

function createFolder()
    if not file.exists(FOLDER_PATH) then file.mkdir(FOLDER_PATH) end
end

function loadClickRecords()
    if recordsLoaded then return end
    createFolder()
    for id, _ in pairs(coreDB) do clickRecords[id] = 0 end
    local f = io.open(RECORD_FILE, "r")
    if f then
        for line in f:lines() do
            local id, count = line:match("^(%d+)%s*=%s*(%d+)$")
            if id and count and coreDB[tonumber(id)] then
                clickRecords[tonumber(id)] = tonumber(count)
            end
        end
        f:close()
    end
    recordsLoaded = true
end

function saveClickRecords()
    createFolder()
    local tempPath = RECORD_FILE .. ".tmp"
    local f = io.open(tempPath, "w")
    if f then
        for id, count in pairs(clickRecords) do
            if count > 0 then f:write(string.format("%d=%d\n", id, count)) end
        end
        f:flush(); f:close()
        os.remove(RECORD_FILE); os.rename(tempPath, RECORD_FILE)
    elseif file.exists(tempPath) then os.remove(tempPath) end
end

function recordClick(id)
    if not coreDB[id] then return end
    if not recordsLoaded then loadClickRecords() end
    clickRecords[id] = (clickRecords[id] or 0) + 1
    saveClickRecords()
end

function getCoreName(id)
    return coreDB[tonumber(id) or 0] or "自定义核心"
end

function getAllCoreModules()
    if not recordsLoaded then loadClickRecords() end
    local modules = {}
    for id, name in pairs(coreDB) do
        table.insert(modules, {id = id, name = name, clickCount = clickRecords[id] or 0})
    end

    table.sort(modules, function(a, b)
        if a.clickCount > 0 and b.clickCount > 0 then
            if a.clickCount ~= b.clickCount then
                return a.clickCount > b.clickCount
            else
                return a.name < b.name
            end
        elseif a.clickCount > 0 and b.clickCount == 0 then
            return true
        elseif a.clickCount == 0 and b.clickCount > 0 then
            return false
        else
            return a.name < b.name
        end
    end)
    
    return modules
end

function selectCoreByList()
    local allModules = getAllCoreModules()
    if #allModules == 0 then 提示("未找到可用核心模块"); return end
    
    local options = {}
    for i, m in ipairs(allModules) do
        if m.clickCount > 0 then
            options[i] = string.format("★%d %s (ID:%d)", m.clickCount, m.name, m.id)
        else
            options[i] = string.format("%s (ID:%d)", m.name, m.id)
        end
    end
    
    local choice = gg.choice(options, nil, "选择核心（按使用频率排序）")
    if not choice or choice == 0 then 提示("已取消选择"); return end
    
    local selected = allModules[choice]
    recordClick(selected.id)
    return selected.id, selected.name
end

function saveCoreBySelection()
    local targetId, targetName = selectCoreByList()
    if not targetId then return end
    
    if gg.alert(string.format("确认选择核心：\n\n萌新 (1001) → %s (%d)", targetName, targetId), "确定选择", "取消") ~= 1 then
        提示("已取消选择"); return
    end
    
    writeScriptCache(tostring(targetId), targetName)
    提示(string.format("已选择核心：%s (%d)", targetName, targetId))
end

function showClickStatistics()
    if not recordsLoaded then loadClickRecords() end
    local allModules = getAllCoreModules()
    if #allModules == 0 then 提示("暂无使用记录"); return end
    
    local msg, totalClicks = "=== 核心使用频率统计 ===\n\n", 0

    local usedCount = 0
    for _, m in ipairs(allModules) do
        if m.clickCount > 0 then
            msg = msg .. string.format("★%d %s (ID:%d)\n", m.clickCount, m.name, m.id)
            totalClicks = totalClicks + m.clickCount
            usedCount = usedCount + 1
        end
    end

    if usedCount < #allModules then
        msg = msg .. "\n=== 未使用过的核心 ===\n\n"
        for _, m in ipairs(allModules) do
            if m.clickCount == 0 then
                msg = msg .. string.format("%s (ID:%d)\n", m.name, m.id)
            end
        end
    end
    
    if totalClicks > 0 then
        msg = msg .. string.format("\n总计选择: %d 次", totalClicks)
        msg = msg .. string.format("\n已使用核心: %d 个", usedCount)
        msg = msg .. string.format("\n未使用核心: %d 个", #allModules - usedCount)
        local mostUsed = allModules[1]
        if mostUsed.clickCount > 0 then
            msg = msg .. string.format("\n最常用: ★%d %s (ID:%d)", mostUsed.clickCount, mostUsed.name, mostUsed.id)
        end
    else
        msg = msg .. "暂无使用记录"
    end
    
    gg.alert(msg, "确定")
end

function clearClickRecords()
    if gg.alert("确定要清空所有使用记录吗？", "确定清空", "取消") ~= 1 then
        提示("已取消"); return
    end
    for id, _ in pairs(coreDB) do clickRecords[id] = 0 end
    saveClickRecords()
    提示("使用记录已清空")
end

function gaiheModification()
    local coreId, coreName = readScriptCache()
    if not coreId or not coreName then 提示("请先选择要修改的核心"); return end
    coreId = tonumber(coreId)
    if not coreId then 提示("缓存中的核心ID无效"); return end
    local localId, localName = readCoreData()
    if localId then
        local choice = gg.alert("检测到有未恢复的修改数据！\n请选择：", "去恢复", "继续修改")
        if choice == 1 then restoreCore(); return
        elseif choice ~= 2 then return end
    end
    if coreDB[coreId] then recordClick(coreId) end
    gg.clearResults()
    local savedItems = gg.getListItems()
    if savedItems ~= nil and #savedItems > 0 then gg.removeListItems(savedItems) end
    gg.searchNumber("1001", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0, 0)
    local results = gg.getResults(10000)
    if not results or #results == 0 then
        gg.clearResults()
        提示("未找到可修改的目标地址 (1001)")
        return
    end
    local modifyCount = #results
    gg.editAll(coreId, gg.TYPE_DWORD)
    gg.clearResults()
    savedItems = gg.getListItems()
    if savedItems ~= nil and #savedItems > 0 then gg.removeListItems(savedItems) end
    writeCoreData(tostring(coreId), coreName)
    提示(string.format("修改成功：\n萌新 (1001) → %s (%d)\n共修改 %d 个数据", coreName, coreId, modifyCount))
    gg.sleep(1000)
end

function restoreCore()
    local restoreId, restoreName
    if file.exists(FILE_PATH) then
        restoreId, restoreName = readCoreData()
        if restoreId and restoreName then
            提示("从本地文件读取: " .. restoreName .. " (" .. restoreId .. ")")
        else
            提示("本地文件存在但数据格式错误")
            return
        end
    else
        local cacheId, cacheName = readScriptCache()
        if cacheId and cacheName then
            restoreId, restoreName = cacheId, cacheName
            提示("从脚本缓存读取: " .. cacheName .. " (" .. cacheId .. ")")
        else
            提示("本地文件和脚本缓存均无未恢复数据")
            return
        end
    end
    if not restoreId or not restoreName then
        提示("读取恢复数据失败")
        return
    end
    restoreId = tonumber(restoreId)
    if not restoreId then 
        提示("恢复ID无效: " .. tostring(restoreId))
        return 
    end
    gg.clearResults()
    local savedItems = gg.getListItems()
    if savedItems ~= nil and #savedItems > 0 then gg.removeListItems(savedItems) end
    gg.searchNumber(restoreId, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0, 0)
    local results = gg.getResults(10000)
    if not results or #results == 0 then
        gg.clearResults()
        提示(string.format("未找到需要恢复的目标地址: %d", restoreId))
        return
    end
    local restoreCount = #results
    gg.editAll("1001", gg.TYPE_DWORD)
    gg.clearResults()
    savedItems = gg.getListItems()
    if savedItems ~= nil and #savedItems > 0 then gg.removeListItems(savedItems) end
    clearScriptCache()
    deleteCoreFile()
    提示(string.format("恢复成功：\n%s (%d) → 萌新 (1001)\n共恢复 %d 个数据", restoreName, restoreId, restoreCount))
    gg.sleep(1000)
end

function writeScriptCache(id, name) 
    SCRIPT_CACHE = id .. "|" .. name 
end

function readScriptCache()
    if not SCRIPT_CACHE or SCRIPT_CACHE == "" then return nil, nil end
    local id, name = SCRIPT_CACHE:match("(%d+)|(.+)")
    return id, name
end

function readCoreData()
    createFolder()
    if not file.exists(FILE_PATH) then return nil, nil end
    local f = io.open(FILE_PATH, "r")
    if not f then return nil, nil end
    local data = f:read("*a")
    f:close()
    if data and data ~= "" then
        local id, name = data:match("(%d+)|(.+)")
        return id, name
    end
    return nil, nil
end

function writeCoreData(id, name)
    createFolder()
    local tempPath = FILE_PATH .. ".tmp"
    local f = io.open(tempPath, "w+")
    if f then
        f:write(id .. "|" .. name)
        f:flush()
        f:close()
        if file.exists(FILE_PATH) then os.remove(FILE_PATH) end
        os.rename(tempPath, FILE_PATH)
        return true
    else
        if file.exists(tempPath) then os.remove(tempPath) end
        return false
    end
end

function deleteCoreFile()
    if file.exists(FILE_PATH) then os.remove(FILE_PATH) end
end

function clearScriptCache() 
    SCRIPT_CACHE = nil 
end


function guaihexinModifyDialog()
    if not initialized then initializeCoreSystem() end
    
    local choice = gg.choice({
        "手动输入修改", "列表选择修改", "查看使用统计", "清空使用记录"
    }, nil, "选择操作方式")
    
    if choice == 1 then saveCoreFromInput()
    elseif choice == 2 then saveCoreBySelection()
    elseif choice == 3 then showClickStatistics()
    elseif choice == 4 then clearClickRecords()
    else 提示("已取消操作") end
end

function saveCoreFromInput()
    local lastId, lastName = "1110", "铁驭"
    local cacheId, cacheName = readScriptCache()
    if cacheId then lastId, lastName = cacheId, cacheName end
    
    local input = gg.prompt({
        '自定义改核心\n' ..
        '上次选择: ' .. lastName .. '(' .. lastId .. ')\n' ..
        '[序列]=1130 [赋能]=1120 [铁驭]=1110 [火萤]=1101 [铠鼠]=1091\n[幻灵]=1071 [风声]=1051 [大家伙]=1031 [网虫]=1021 [夜莺]=1011\n[火力小车]=1041 [玩具小车]=1042 [军事小车]=1043 [圣诞小车]=1044\n[铁皮小车]=1045 [一级炮台]=1061 [二级炮台]=1062 [三级炮台]=1065\n[炮台-蒸汽]=1063 [炮台-玩具]=1064 [炮台-白色]=1066\n[炮台-量子特攻]=1067 [炮台-建造]=1068 [炮台-圣诞]=1069\n[炮台-小飞龙白色]=1070 [炮台-小飞龙紫色]=1072\n[炮台-小飞龙红色]=1073 [冰墙核心]=1081 [冰墙-冰河世纪]=1082\n[航拍无人机]=3612041\n[逻辑-死亡节点(无敌)]=6001001,\n[逻辑-与门节点(无敌)]=6001002,\n[逻辑-开关节点(无敌)]=6001003'
    }, {[1] = lastId})
    
    if not input then 提示("已取消输入"); return end
    
    local coreId = tonumber(input[1]) or 1110
    local coreName = getCoreName(coreId)

    if coreName == "自定义核心" then
        if gg.alert(string.format("注意：ID %d 是自定义核心\n可能无法正常修改，是否继续？", coreId), "继续选择", "重新输入") ~= 1 then
            return
        end
    end
    
    if gg.alert(string.format("确认选择核心：\n\n萌新 (1001) → %s (%d)", coreName, coreId), "确定选择", "取消") ~= 1 then
        提示("已取消选择"); return
    end
    
    writeScriptCache(tostring(coreId), coreName)
    提示(string.format("已选择核心：%s (%d)", coreName, coreId))
end

function initializeCoreSystem()
    if not initialized then
        createFolder()
        loadClickRecords()
        initialized = true
    end
end

function isInitialized() return initialized end

function showCurrentSelection()
    local fileId, fileName = readCoreData()
    if fileId and fileName then
        local msg = string.format("当前本地保存的选择：\n\n萌新 (1001) → %s (%s)", fileName, fileId)
        gg.alert(msg, "确定")
        return
    end

    local cacheId, cacheName = readScriptCache()
    if cacheId and cacheName then
        local msg = string.format("当前脚本缓存的选择：\n\n萌新 (1001) → %s (%s)", cacheName, cacheId)
        gg.alert(msg, "确定")
    else
        提示("当前没有选择任何核心")
    end
end

function showAllCoreModules()

    if not recordsLoaded then
        loadClickRecords()
    end
    
    local allModules = getAllCoreModules()

    table.sort(allModules, function(a, b)
        return a.name < b.name
    end)
    
    local msg = "=== 所有核心模块 ===\n\n"
    
    for i, module in ipairs(allModules) do
        if module.clickCount > 0 then
            msg = msg .. string.format("%d. ★%d %s (ID:%d)\n", 
                i, module.clickCount, module.name, module.id)
        else
            msg = msg .. string.format("%d. %s (ID:%d)\n", 
                i, module.name, module.id)
        end
    end
    
    msg = msg .. string.format("\n总计: %d 个核心模块", #allModules)
    
    gg.alert(msg, "确定")
end


function yongjiougaihexinxunzhe()
--永久改核心选择目标函数
local DstCoreConfig = {["序列"] = "1130",["赋能"] = "1120",["铁驭"] = "1110",["火萤"] = "1101",["铠鼠"] = "1091",["幻灵"] = "1071",["风声"] = "1051",["大家伙"] = "1031",["网虫"] = "1021",["夜莺"] = "1011",["火力小车"] = "1041",["玩具小车"] = "1042",["军事小车"] = "1043",["圣诞小车"] = "1044",["铁皮小车"] = "1045",["一级炮台"] = "1061",["二级炮台"] = "1062",["三级炮台"] = "1065",["炮台-蒸汽"] = "1063",["炮台-玩具"] = "1064",["炮台-白色"] = "1066",["炮台-量子特攻"] = "1067",["炮台-建造"] = "1068",["炮台-圣诞"] = "1069",["炮台-小飞龙白色"] = "1070",["炮台-小飞龙紫色"] = "1072",["炮台-小飞龙红色"] = "1073",["冰墙核心"] = "1081",["冰墙-冰河世纪"] = "1082",["航拍无人机"] = "3612041",["逻辑-死亡节点(无敌)"] = "6001001",["逻辑-与门节点(无敌)"] = "6001002",["逻辑-开关节点(无敌)"] = "6001003"}
local dstMenu = {"返回"}
local dstList = {}
--将DstCoreConfig中的所有键（核心名称）添加到菜单和列表中
for name in pairs(DstCoreConfig) do
table.insert(dstMenu, name)
table.insert(dstList, name)
end
local dstIdx = gg.choice(dstMenu, "选择目标核心")
if dstIdx and dstIdx ~= 1 then
local selectedCoreName = dstList[dstIdx-1]
local selectedCoreId = DstCoreConfig[selectedCoreName]
yongjiougaihecoreName = selectedCoreName
yongjiougaihecoreId = selectedCoreId
yongjiougaihexinint = 1
提示('你选择了：'..yongjiougaihecoreName)
else
提示('已取消')
end
end


function yongjiougaihexin(yongmoshixuanze)
--永久改核心函数
if yongjiougaihexinint == 1 then
if yongmoshixuanze == 1 then
--改核心
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
gg.searchNumber("1001", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(10000)
gg.editAll(yongjiougaihecoreId, gg.TYPE_DWORD)
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
提示("已永久改核心")
elseif yongmoshixuanze == 0 then
--恢复改核心
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
gg.searchNumber(yongjiougaihecoreId, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(10000)
gg.editAll("1001", gg.TYPE_DWORD)
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
提示("已恢复永久改核心")
end
else
提示('请先选择目标核心')
end
end


--改核心2.0
local coreConfig = {
    ["序列"] = "1130",
    ["赋能"] = "1120",
    ["铁驭"] = "1110",
    ["火萤"] = "1101",
    ["铠鼠"] = "1091",
    ["幻灵"] = "1071",
    ["风声"] = "1051",
    ["大家伙"] = "1031",
    ["网虫"] = "1021",
    ["夜莺"] = "1011",
    ["逻辑-死亡节点(无敌)"] = "6001001",
    ["逻辑-与门节点(无敌)"] = "6001002",
    ["逻辑-开关节点(无敌)"] = "6001003",
    ["火力小车"] = "1041",
    ["玩具小车"] = "1042",
    ["军事小车"] = "1043",
    ["圣诞小车"] = "1044",
    ["铁皮小车"] = "1045",
    ["一级炮台"] = "1061",
    ["二级炮台"] = "1062",
    ["三级炮台"] = "1065",
    ["炮台-蒸汽"] = "1063",
    ["炮台-玩具"] = "1064",
    ["炮台-白色"] = "1066",
    ["炮台-量子特攻"] = "1067",
    ["炮台-建造"] = "1068",
    ["炮台-圣诞"] = "1069",
    ["炮台-小飞龙白色"] = "1070",
    ["炮台-小飞龙紫色"] = "1072",
    ["炮台-小飞龙红色"] = "1073",
    ["冰墙核心"] = "1081",
    ["冰墙-冰河世纪"] = "1082",
    ["航拍无人机"] = "3612041",
    ["秒表"] = "1000001",
    ["小底座"] = "1000102",
    ["中底座"] = "1000103",
    ["大底座"] = "1000104",
    ["8底座"] = "1000105",
    ["驾驶舱"] = "5001001",
    ["小怪核心"] = "5001101",
    ["精英怪核心"] = "5001102",
    ["悬浮怪核心"] = "5001103"
}

local DEFAULT_CORE_NAME = "萌新"
local DEFAULT_CORE_ID = "1001"

local isModified = 0
local mainAddrs = nil
local selectedName = ""
local selectedId = ""

local function setMemory(addr, value, type, freeze)
    if freeze == true then
        gg.addListItems({{address = addr, flags = type, value = value, freeze = true}})
    else
        gg.setValues({{address = addr, flags = type, value = value}})
    end
end

local function clearAll()
    gg.clearResults()
    gg.sleep(100)
    gg.removeListItems(gg.getListItems())
end

local function ensureCoreAddress()
    local info = gg.getTargetInfo()
    if not info.x64 then return true end
    
    提示("初始化时间较长")
    clearAll()
    gg.sleep(50)
    
    local function trySearch(searchPattern, refineValue)
        gg.searchNumber(searchPattern, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        gg.refineNumber(refineValue, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        local results = gg.getResults(1000)
        return results
    end
    
    local mainResults = trySearch("36058;1001;300", "1001")
    
    if not mainResults or #mainResults == 0 then
        提示("方案 1 失败，尝试备用方案")
        mainResults = trySearch("1001;300", "1001")
    end
    
    if not mainResults or #mainResults == 0 then
        提示("未找到主修改地址，初始化失败")
        return false
    end
    
    mainAddrs = {}
    for _, v in ipairs(mainResults) do
        table.insert(mainAddrs, v.address)
    end
    
    gg.sleep(50)
    clearAll()
    return true
end

local function applyCore(targetId)
    local info = gg.getTargetInfo()
    clearAll()
    local modifiedCount = 0
    if info.x64 then
        if not mainAddrs then return false, 0 end

        for _, addr in ipairs(mainAddrs) do
            setMemory(addr, targetId, gg.TYPE_DWORD, false)
            modifiedCount = modifiedCount + 1
        end

        search(10000000, 4, neicun)
        local count1 = gg.getResultsCount()
        py1(2717, 4, -48)
        xg1(targetId, 4, -120, false)
        modifiedCount = modifiedCount + count1
    else
        search(35774, 4, neicun)
        local count1 = gg.getResultsCount()
        py1(36058, 4, -84)
        xg1(targetId, 4, -72, false)
        modifiedCount = modifiedCount + count1
        
        search(10000000, 4, neicun)
        local count2 = gg.getResultsCount()
        py1(2721, 4, -48)
        xg1(targetId, 4, -60, false)
        modifiedCount = modifiedCount + count2
    end
    clearAll()
    return true, modifiedCount
end

local function revertCore()
    local info = gg.getTargetInfo()
    clearAll()
    local modifiedCount = 0
    if info.x64 then
        if not mainAddrs then return false, 0 end

        for _, addr in ipairs(mainAddrs) do
            setMemory(addr, DEFAULT_CORE_ID, gg.TYPE_DWORD, false)
            modifiedCount = modifiedCount + 1
        end

        search(10000000, 4, neicun)
        local count1 = gg.getResultsCount()
        py1(2717, 4, -48)
        xg1(DEFAULT_CORE_ID, 4, -120, false)
        modifiedCount = modifiedCount + count1
    else
        search(35774, 4, neicun)
        local count1 = gg.getResultsCount()
        py1(36058, 4, -84)
        xg1(DEFAULT_CORE_ID, 4, -72, false)
        modifiedCount = modifiedCount + count1
        
        search(10000000, 4, neicun)
        local count2 = gg.getResultsCount()
        py1(2721, 4, -48)
        xg1(DEFAULT_CORE_ID, 4, -60, false)
        modifiedCount = modifiedCount + count2
    end
    clearAll()
    return true, modifiedCount
end

function setcoreint()
    local info = gg.getTargetInfo()
    if info.x64 then
        if isModified == 1 then
            提示("请先恢复核心后再初始化")
            return
        end
        mainAddrs = nil
        if ensureCoreAddress() then
            提示('初始化核心地址完成')
        else
            mainAddrs = nil
            提示('初始化失败')
        end
    else
        提示("32位设备无需初始化")
    end
end

function setcore()
    if isModified == 1 then
        提示('核心已修改,请先恢复')
        return
    end
    local menu = {"返回"}
    local nameList = {}
    for name in pairs(coreConfig) do
        table.insert(menu, name)
        table.insert(nameList, name)
    end
    local idx = gg.choice(menu, nil, "选择目标核心")
    if not idx or idx == 1 then
        提示('已取消')
        return
    end
    selectedName = nameList[idx - 1]
    selectedId = coreConfig[selectedName]
    提示('你选择了：' .. selectedName)
end

function uestocore()
    if not selectedId or selectedId == "" then
        提示('请先选择核心')
        return
    end
    if isModified == 1 then
        提示('核心已修改,请先恢复')
        return
    end
    local info = gg.getTargetInfo()
    if info.x64 and not mainAddrs then
        提示('请先初始化核心地址')
        return
    end
    local success, count = applyCore(selectedId)
    if success then
        isModified = 1
        提示(string.format('%s(%s) → %s(%s)\n共修改%d个数据', DEFAULT_CORE_NAME, DEFAULT_CORE_ID, selectedName, selectedId, count))
    else
        提示('修改失败')
    end
end

function rescore()
    if isModified ~= 1 then
        提示("请先改核心")
        return
    end
    local success, count = revertCore()
    if success then
        isModified = 0
        提示(string.format('%s(%s) → %s(%s)\n共修改%d个数据', selectedName, selectedId, DEFAULT_CORE_NAME, DEFAULT_CORE_ID, count))
    else
        提示('恢复失败')
    end
end






function paijipaofabao(isEnable)
    local savedItems = gg.getListItems()
    gg.removeListItems(savedItems)
    gg.clearResults()

    local regions = gg.getRangesList("libclient.so")
    if not regions or not regions[1] then
        提示("未找到libclient.so")
        return
    end

    local baseAddr = regions[1].start
    local targetAddr = baseAddr + 0x1F3B190
    gg.addListItems({{flags = 4, address = targetAddr}})
    
    savedItems = gg.getListItems()
    gg.loadResults(savedItems)
    local get = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)

    if isEnable then
        local input = gg.prompt({'自定义延迟超时'}, {'99999'}, {'text'})
        if not input then
            提示("已取消操作")
            return
        end
        local gd = tonumber(input[1]) or 99999
        if not gd then
            提示("输入无效，使用默认值99999")
            gd = 99999
        end
        gg.editAll(gd, gg.TYPE_DWORD)
        提示("已开启迫击炮发包")
    else
        gg.editAll(98, gg.TYPE_DWORD)
        提示("已关闭迫击炮发包,请刷新画质")
    end
end





function dituxiougaixuan()
    DstdiConfig = {
        ["多人创造-试验场"] = "scene/game_training_02/game_training_02.scn",
        ["单点占领-远征中转站"] = "scene/game_3v3control/game_3v3control.scn",
        ["派对模式-缤纷派对"] = "scene/game_playground/game_playground.scn",
        ["派对模式-空中激斗"] = "scene/game_airplay_1/game_airplay_1.scn",
        ["多点占领-暗黑星云"] = "scene/airship_black/airship_black.scn",
        ["建造者模式-星弈台"] = "scene/game_build/game_build.scn",
        ["单挑模式-青岚山居"] = "scene/play_solo_2/play_solo_2.scn",
        ["单挑模式-天穹圣殿"] = "scene/play_solo_3/play_solo_3.scn",
        ["单挑模式-缤纷球场"] = "scene/play_solo_1/play_solo_1.scn",
        ["超级风暴-来兮城"] = "scene/game_io_03/game_io_03.scn",
        ["新手教程-跃腾"] = "scene/challenge_leap/challenge_leap.scn",
        ["新手教程-鹰驰(地雷共用此地图)"] = "scene/challenge_cliff/challenge_cliff.scn",
        ["新手教程-狙击枪"] = "scene/challenge_double/challenge_double.scn",
        ["单人风暴-落尘之地"] = "scene/game_io_02/game_io_02.scn"
    }
    local dstdiMenu = {"返回"}
    local dstdiList = {}
    for name in pairs(DstdiConfig) do
        table.insert(dstdiMenu, name)
        table.insert(dstdiList, name)
    end
    local dstdiIdx = gg.choice(dstdiMenu, "选择原地图")
    if dstdiIdx and dstdiIdx ~= 1 then
        local selecteddiName = dstdiList[dstdiIdx-1]
        local selecteddiId = DstdiConfig[selecteddiName]
        yuandituName = selecteddiName
        yuandituId = selecteddiId
        selecteddiName = nil
        selecteddiId = nil
        提示("原地图设置成功")
        local dstdiIdx = gg.choice(dstdiMenu, "选择目标地图")
        if dstdiIdx and dstdiIdx ~= 1 then
            local selecteddiName = dstdiList[dstdiIdx-1]
            local selecteddiId = DstdiConfig[selecteddiName]
            mubiaodituName = selecteddiName
            mubiaodituId = selecteddiId
            提示('你选择了：将 '..yuandituName..' 改为 '..mubiaodituName)
        else
            提示('已取消')
        end
    else
        提示('已取消')
    end
end

function zhuyexiougaixuan()
    DstziConfig = {
        ["休赛期主页"] = "scene/lobby_factory_019/lobby_factory_019.scn",
        ["库亚工业主页"] = "scene/lobby_factory_020/lobby_factory_020.scn",
        ["天启降临主页"] = "scene/lobby_factory_021/lobby_factory_021.scn",
        ["电幻夜幕主页"] = "scene/lobby_factory_022/lobby_factory_022.scn",
        ["荒古狩猎主页"] = "scene/lobby_factory_023/lobby_factory_023.scn",
        ["星界宇航主页"] = "scene/lobby_factory_024/lobby_factory_024.scn"
    }
    local dstziMenu = {"返回"}
    local dstziList = {}
    for name in pairs(DstziConfig) do
        table.insert(dstziMenu, name)
        table.insert(dstziList, name)
    end
    local dstziIdx = gg.choice(dstziMenu, "选择原主页")
    if dstziIdx and dstziIdx ~= 1 then
        local selectedziName = dstziList[dstziIdx-1]
        local selectedziId = DstziConfig[selectedziName]
        yuanzituName = selectedziName
        yuanzituId = selectedziId
        selectedziName = nil
        selectedziId = nil
        提示("原主页设置成功")
        local dstziIdx = gg.choice(dstziMenu, "选择目标主页")
        if dstziIdx and dstziIdx ~= 1 then
            local selectedziName = dstziList[dstziIdx-1]
            local selectedziId = DstziConfig[selectedziName]
            mubiaozituName = selectedziName
            mubiaozituId = selectedziId
            提示('你选择了：将 '..yuanzituName..' 改为 '..mubiaozituName)
        else
            提示('已取消')
        end
    else
        提示('已取消')
    end
end

function dituxiougai(dimode)
    if dimode == 1 then
        gg.clearResults()
        gg.searchNumber(":"..yuandituId, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        local count = gg.getResultsCount()
        if count == 0 then
            提示("未找到原地图ID，修改失败")
            return
        end
        ditusave = gg.getResults(10000)
        gg.editAll(":"..mubiaodituId, gg.TYPE_BYTE)
        gg.clearResults()
        提示('已将 '..yuandituName..' 改为 '..mubiaodituName.. '\n切换画质或重新进入对局生效')
    else
        if not ditusave or #ditusave == 0 then
            提示("没有可还原的数据，请先执行修改")
            return
        end
        gg.clearResults()
        gg.loadResults(ditusave)
        gg.editAll(":"..yuandituId, gg.TYPE_BYTE)
        gg.clearResults()
        提示('已将 '..mubiaodituName..' 复原为 '..yuandituName.. '\n切换画质或重新进入对局生效')
    end
end

function zhuyexiougai(zimode)
    if zimode == 1 then
        gg.clearResults()
        gg.searchNumber(":"..yuanzituId, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        local count = gg.getResultsCount()
        if count == 0 then
            提示("未找到原主页ID，修改失败")
            return
        end
        zitusave = gg.getResults(10000)
        gg.editAll(":"..mubiaozituId, gg.TYPE_BYTE)
        gg.clearResults()
        提示('已将 '..yuanzituName..' 改为 '..mubiaozituName.. '\n切换画质或重新进入对局生效')
    else
        if not zitusave or #zitusave == 0 then
            提示("没有可还原的数据，请先执行修改")
            return
        end
        gg.clearResults()
        gg.loadResults(zitusave)
        gg.editAll(":"..yuanzituId, gg.TYPE_BYTE)
        gg.clearResults()
        提示('已将 '..mubiaozituName..' 复原为 '..yuanzituName.. '\n切换画质或重新进入对局生效')
    end
end


function xuanzhemoxing()
intgaimoxing = 0
DstmoConfig = {["纯色魔方"] = "101000",["足球"] = "243",["救援无人机"] = "2003",["矿场卡车"] = "6067",["屏障无人机"] = "10404",["植物炮台"] = "242002",["冰墙"] = "10414",["站点模式修理箱"] = "2006",["屏障"] = "3001",["超级风暴复活点"] = "3100",["赛车模式起点"] = "3201",["赛车模式终点"] = "3202",["派对可破坏方块"] = "3363",["派对升降方块"] = "3377",["滚木"] = "3372",["擂台模式集装箱"] = "6019",["太空探险车"] = "6065",["毒圈"] = "100002",["终场谢幕飞机模型"] = "4004",["建造者方块"] = "3015",["建造者上坡"] = "3016"}
local dstmoMenu = {"返回"}
local dstmoList = {}
--将DstmoConfig中的所有模型ID添加到菜单和列表中
for name in pairs(DstmoConfig) do
table.insert(dstmoMenu, name)
table.insert(dstmoList, name)
end
local dstmoIdx = gg.choice(dstmoMenu, "选择原模型")
if dstmoIdx and dstmoIdx ~= 1 then
local selectedmoName = dstmoList[dstmoIdx-1]
local selectedmoId = DstmoConfig[selectedmoName]
yuanmoName = selectedmoName
yuanmoId = selectedmoId
selectedmoName = nil
selectedmoId = nil
提示('请选择目标模型')
local dstmoIdx = gg.choice(dstmoMenu, "选择目标模型")
if dstmoIdx and dstmoIdx ~= 1 then
local selectedmoName = dstmoList[dstmoIdx-1]
local selectedmoId = DstmoConfig[selectedmoName]
mubiaomoName = selectedmoName
mubiaomoId = selectedmoId
intgaimoxing = 1
提示('你选择了：将 '..yuanmoName..' 改为 '..mubiaomoName)
else
intgaimoxing = 0
end
else
intgaimoxing = 0
end
end

function moxing(momode)
if momode == 1 then
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
gg.searchNumber(yuanmoId, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(10000)
gg.editAll(mubiaomoId, gg.TYPE_DWORD)
mosavedItems = gg.getResults(1000)
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
提示('已将 '..yuanmoName..' 改为 '..mubiaomoName)
else
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
gg.loadResults(mosavedItems)
gg.addListItems(mosavedItems)
gg.refineNumber(mubiaomoId, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll(yuanmoId, gg.TYPE_DWORD)
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
提示('已将 '..mubiaomoName..' 复原为 '..yuanmoName)
end
end






function dashentexiao(texiaoseton)
    if texiaoseton == 1 then
        gg.clearResults()
        gg.removeListItems(gg.getListItems())
        
        gg.searchNumber("1001001", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
        local results = gg.getResults(1000)
        
        if #results > 0 then
            dashenzhilutexiaosave = {}
            for i, v in ipairs(results) do
                dashenzhilutexiaosave[i] = {
                    address = v.address,
                    flags = gg.TYPE_DWORD,
                    value = 1001001
                }
            end
            
            gg.editAll("100100110", gg.TYPE_DWORD)
            提示("已开启大神之路特效\n修改数量: "..#results)
        else
            提示("未找到数据")
        end
        
        gg.clearResults()
        gg.removeListItems(gg.getListItems())
        
    else
        if not dashenzhilutexiaosave or #dashenzhilutexiaosave == 0 then
            提示("请先开启特效")
            return
        end
        
        gg.setValues(dashenzhilutexiaosave)
        提示("已关闭大神之路特效\n恢复数量: "..#dashenzhilutexiaosave)
        
        dashenzhilutexiaosave = nil
        gg.clearResults()
        gg.removeListItems(gg.getListItems())
    end
end



function pengzhuang(x,xg,y,yg,z,zg,zhuangtaiuse)
local function modify(searchVal,newVal)
gg.clearResults()
gg.searchNumber(searchVal,gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1,0)
local count=gg.getResultsCount()
if count>0 then
gg.editAll(newVal,gg.TYPE_FLOAT)
local results=gg.getResults(count)
for _,v in ipairs(results) do
gg.setValues({{address=v.address+4,flags=gg.TYPE_FLOAT,value=newVal}})
end
end
gg.clearResults()
end
if zhuangtaiuse==1 then
modify(x,xg)
modify(y,yg)
modify(z,zg)
提示("缴械开启成功")
else
modify(xg,x)
modify(yg,y)
modify(zg,z)
提示("缴械关闭成功")
end
end







local skinData = {
    [4040] = {
        ["午夜派对-SI"] = "100404020",
        ["涅瑞斯之怒"] = "100404001",
        ["鞭炮加特林"] = "100404002",
        ["宿命"] = "100404003",
        ["贪噬"] = "100404004",
        ["赴险伙伴"] = "100404005",
        ["落日"] = "100404006",
        ["多管艺术"] = "100404007",
        ["恶魔夫人"] = "100404008",
        ["摩尔斯的啄木鸟"] = "100404009",
        ["圣者遗言"] = "100404010",
        ["断罪荣光"] = "100404011",
        ["狂躁症"] = "100404012",
        ["灼骨"] = "100404013",
        ["恶魔夫人(TDC)"] = "100404014",
        ["库灵臂"] = "100404015",
        ["蚩龙巡世"] = "100404016",
        ["蚩龙巡世-敖烈"] = "100404017",
        ["蚩龙巡世-烈缺"] = "100404018",
        ["涅瑞斯之怒-Ltd"] = "100404021"
    },
    [7020] = {
        ["战魂盾"] = "100702010",
        ["冥王盾"] = "100702001",
        ["4399盾"] = "100702002",
        ["华为盾"] = "100702003",
        ["oppo盾"] = "100702004",
        ["taptap盾"] = "100702005",
        ["小米盾"] = "100702006",
        ["好游快爆盾"] = "100702007",
        ["九游盾"] = "100702008",
        ["vivo盾"] = "100702009",
        ["应用宝盾"] = "100702011",
        ["CC直播盾"] = "100702012",
        ["斗鱼直播盾"] = "100702013",
        ["虎牙直播盾"] = "100702014",
        ["西瓜视频盾"] = "100702015",
        ["触手直播盾"] = "100702016",
        ["乘风破浪"] = "100702017",
        ["玄武"] = "100702018",
        ["珞翅"] = "100702019",
        ["海王盾-SI"] = "100702020",
        ["霓虹灯牌"] = "100702021",
        ["近卫军"] = "100702022",
        ["熊熊大作战"] = "100702023",
        ["Nimo TV盾"] = "100702024",
        ["谦卑"] = "100702025",
        ["寒御"] = "100702026",
        ["亚能屏障"] = "100702027",
        ["伴月流光"] = "100702028",
        ["光谱护幕"] = "100702029"
    },
    [10010] = {
        ["酒桶"] = "101001001",
        ["起源动力"] = "101001002",
        ["聚变暗星"] = "101001003",
        ["远征敕令"] = "101001004",
        ["蒸汽时代"] = "101001005",
        ["快乐喷涌"] = "101001006",
        ["快乐喷涌-Ltd"] = "101001007",
        ["冰气风轮"] = "101001008",
        ["飓风"] = "101001009",
        ["驭龙人"] = "101001010",
        ["大神之路"] = "101001011",
        ["光年"] = "101001012",
        ["大嘴龙"] = "101001013",
        ["星火"] = "101001014",
        ["急冻咆哮"] = "101001015",
        ["飓风(TDC)"] = "101001016",
        ["库亚浪潮"] = "101001017",
        ["幻焰魔光"] = "101001018",
        ["新航路"] = "101001019",
        ["大力神-SI"] = "101001020"
    },
    [3104010] = {
        ["铁拳COVE-A"] = "102062001",
        ["弥赛亚"] = "102062002",
        ["毁灭者"] = "102062003",
        ["双管杠杆炮"] = "102062004",
        ["章鱼恶霸"] = "102062005",
        ["多维破碎"] = "102062006",
        ["丧钟"] = "102062007",
        ["十字风暴"] = "102062008",
        ["刃冰"] = "102062009",
        ["铁拳COVE-A(TDC)"] = "102062010",
        ["幻影冲击"] = "102062011"
    },
    [11020] = {
        ["盖达尔记忆"] = "101102001",
        ["仙人掌盆栽"] = "101102002",
        ["理想国"] = "101102003",
        ["叮当圣诞"] = "101102004",
        ["炮台搭建器-火力二"] = "101102005",
        ["机仆101"] = "101102006",
        ["多功能手臂"] = "101102007",
        ["逐星雏龙"] = "101102008",
        ["逐星雏龙-脉冲"] = "101102009",
        ["逐星雏龙-日冕"] = "101102010",
        ["捍卫者-SI"] = "101102020"
    },
    [5020] = {
        ["破碎撕裂"] = "100502001",
        ["精准工艺"] = "100502002",
        ["锯齿鳄"] = "100502003",
        ["伐木小子"] = "100502004",
        ["华炼奥义"] = "100502005",
        ["冰棒恶作剧"] = "100502006",
        ["冰棒恶作剧-Ltd"] = "100502007",
        ["奥密克戎之刃"] = "100502008",
        ["征服之刃"] = "100502009",
        ["割草机"] = "100502010",
        ["血刃"] = "100502011",
        ["狱影"] = "100502012",
        ["特斯拉的巨剑-SI"] = "100502020"
    },
    [4140] = {
        ["高压水枪"] = "100414001",
        ["贪婪效忠"] = "100414002",
        ["电玩行家"] = "100414003",
        ["赎罪棱镜"] = "100414004",
        ["典狱长之链"] = "100414005",
        ["厄运聚光"] = "100414006",
        ["原能虫颚"] = "100414007",
        ["瓦解眼束"] = "100414008",
        ["能量潮汐"] = "100414009",
        ["能量潮汐-暗星"] = "100414010",
        ["碧蓝使者-SI"] = "100414020"
    },
    [4050] = {
        ["猎首行动"] = "100405001",
        ["霸权口径"] = "100405002",
        ["英白拉多"] = "100405003",
        ["高斯原理"] = "100405004",
        ["猎虎COVE-B"] = "100405005",
        ["野兽狙击炮(废稿)"] = "100405006",
        ["启示录"] = "100405007",
        ["审判号角"] = "100405008",
        ["龙息"] = "100405009",
        ["鲨吻"] = "100405010",
        ["喳喳太空船"] = "100405011",
        ["猎虎COVE-B(TDC)"] = "100405012",
        ["荣耀猎杀"] = "100405013",
        ["穹弩-SI"] = "100405020",
        ["霸权口径-Ltd"] = "100405021"
    },
    [4100] = {
        ["菜鸟之家"] = "100410001",
        ["舞狮"] = "100410002",
        ["木星公爵"] = "100410003",
        ["小丑"] = "100410004",
        ["军事炸弹(废稿)"] = "100410005",
        ["糖果盛宴"] = "100410006",
        ["糖果盛宴-Ltd"] = "100410007",
        ["绽放幽兰"] = "100410008",
        ["盖亚之泪"] = "100410009",
        ["暴君"] = "100410010",
        ["小坏蛋"] = "100410011",
        ["牛仔"] = "100410012",
        ["地狱犬"] = "100410013",
        ["执法者"] = "100410014",
        ["沙漠玫瑰2S18(TDC)"] = "100410015",
        ["爆破蛟肌"] = "100410016",
        ["老派左轮-SI"] = "100410020",
        ["木星公爵-Ltd"] = "100410021",
        ["死星"] = "100410022"
    },
    [4110] = {
        ["静默秩序"] = "100411001",
        ["萨克森干扰装置"] = "100411002",
        ["云起时分"] = "100411003",
        ["微醺玫瑰"] = "100411004",
        ["狂欢迪斯科"] = "100411005",
        ["奥古斯都"] = "100411006",
        ["提诺兰电肌"] = "100411007",
        ["极星镇阙"] = "100411008",
        ["极星镇阙-玄坛"] = "100411009",
        ["极星镇阙-里海"] = "100411010",
        ["霓虹战影"] = "100411011",
        ["寂静之声-SI"] = "100411020"
    },
    [3111010] = {
        ["砰砰雪球"] = "102063001",
        ["鲜橙爆弹"] = "102063002",
        ["烈日弹丸"] = "102063003"
    },
    [5010] = {
        ["叫嚣拳手"] = "100501001",
        ["纵欲恶灵"] = "100501002",
        ["小螺丝"] = "100501003",
        ["果味甜心"] = "100501004",
        ["蝮蛇"] = "100501005",
        ["以赛之剑"] = "100501006",
        ["剔骨刀"] = "100501007",
        ["真空管钻头"] = "100501008",
        ["小指头-SI"] = "100501020"
    },
    [3090] = {
        ["人字拖"] = "100309001",
        ["义肢"] = "100309002",
        ["裂地重踏"] = "100309003",
        ["青年军"] = "100309004",
        ["哈迪的假肢"] = "100309005",
        ["黑爪"] = "100309006",
        ["蜥蜴"] = "100309007",
        ["发条跳蚤"] = "100309008",
        ["蛙跳冠军"] = "100309009",
        ["安琪儿茶点"] = "100309010",
        ["初号"] = "100309011",
        ["跃腾-SI"] = "100309020",
        ["黄金骨骼"] = "100309021"
    }
}

local skinTypes = {
    { name = "机枪", module = 4040, key = "jiqiang", display = "机枪皮肤" },
    { name = "海王盾", module = 7020, key = "haiwangdun", display = "海王盾皮肤" },
    { name = "大力神", module = 10010, key = "dalishen", display = "大力神皮肤" },
    { name = "穿云", module = 3104010, key = "chuanyun", display = "穿云皮肤" },
    { name = "炮台", module = 11020, key = "paotai", display = "炮台皮肤" },
    { name = "哥斯拉巨剑", module = 5020, key = "dao", display = "哥斯拉巨剑皮肤" },
    { name = "激光", module = 4140, key = "jiguang", display = "激光皮肤" },
    { name = "狙击枪", module = 4050, key = "juji", display = "狙击枪皮肤" },
    { name = "榴弹", module = 4100, key = "lioudan", display = "榴弹皮肤" },
    { name = "斥星", module = 3111010, key = "chixing", display = "斥星皮肤" },
    { name = "磁暴", module = 4110, key = "cibao", display = "磁暴皮肤" },
    { name = "小钻头", module = 5010, key = "zuantou", display = "小钻头皮肤" },
    { name = "跃腾", module = 3090, key = "yueteng", display = "跃腾皮肤" }
}

local skinState = {}
for _, st in ipairs(skinTypes) do
    skinState[st.key] = {
        active = 0,
        yuanId = nil, yuanName = nil,
        mubiaoId = nil, mubiaoName = nil,
        savedResults = nil
    }
end

local function selectSkin(moduleId, prompt)
    local config = skinData[moduleId]
    if not config then
        提示("未知模块")
        return nil
    end
    local menu = {"返回"}
    local nameList = {}
    for name in pairs(config) do
        table.insert(menu, name)
        table.insert(nameList, name)
    end
    提示(prompt)
    local idx = gg.choice(menu, prompt)
    if idx and idx > 1 then
        local name = nameList[idx-1]
        return name, config[name]
    end
    return nil
end

local function selectSkinPair(moduleId)
    local yuanName, yuanId = selectSkin(moduleId, "请选择原皮肤")
    if not yuanName then
        提示("已取消")
        return nil
    end
    local mubiaoName, mubiaoId = selectSkin(moduleId, "请选择目标皮肤")
    if not mubiaoName then
        提示("已取消")
        return nil
    end
    return yuanName, yuanId, mubiaoName, mubiaoId
end

local function huanfu(yuanId, yuanName, mubiaoId, mubiaoName, mode)
    if mode == 1 then
        gg.clearResults()
        gg.removeListItems(gg.getListItems())
        gg.sleep(100)
        gg.searchNumber(yuanId, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        local count = gg.getResultsCount()
        if count == 0 then
            提示("未找到原皮肤 " .. yuanName)
            return nil
        end
        local results = gg.getResults(count)
        gg.sleep(100)
        gg.editAll(mubiaoId, gg.TYPE_DWORD)
        lingshipisavedItems = results
        gg.sleep(100)
        gg.clearResults()
        gg.removeListItems(gg.getListItems())
        提示("已将 " .. yuanName .. " 改为 " .. mubiaoName)
        return results
    else
        if not lingshipisavedItems or #lingshipisavedItems == 0 then
            提示("无保存数据，无法还原")
            return
        end
        gg.clearResults()
        gg.loadResults(lingshipisavedItems)
        gg.sleep(100)
        gg.refineNumber(mubiaoId, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        local count = gg.getResultsCount()
        if count == 0 then
            提示("未找到目标皮肤 " .. mubiaoName .. "，可能已改变")
            return
        end
        gg.getResults(count)
        gg.sleep(100)
        gg.editAll(yuanId, gg.TYPE_DWORD)
        gg.clearResults()
        提示("已将 " .. mubiaoName .. " 还原为 " .. yuanName)
    end
end

local function applySkinChange(key, mode)
    local state = skinState[key]
    if not state then return end

    if mode == 1 then
        if state.active == 1 then
            提示("该皮肤换肤已换肤，请勿重复开启")
            return
        end
        if not state.yuanId or not state.mubiaoId then
            提示("请先在'选择模块'中设置原皮肤和目标皮肤")
            return
        end
        state.active = 1
        local results = huanfu(state.yuanId, state.yuanName, state.mubiaoId, state.mubiaoName, 1)
        if results then
            state.savedResults = results
        else
            state.active = 0
        end
    else
        if state.active == 0 then
            提示("该皮肤换肤未换肤")
            return
        end
        lingshipisavedItems = state.savedResults
        huanfu(state.yuanId, state.yuanName, state.mubiaoId, state.mubiaoName, 0)
        state.active = 0
        state.savedResults = nil
    end
end

function xuanzhemokuaipifu()
    local options = {}
    for _, st in ipairs(skinTypes) do
        table.insert(options, "选择" .. st.display)
    end

    local choice = gg.choice(options, nil, "选择要修改的皮肤")
    if choice then
        local st = skinTypes[choice]
        if skinState[st.key].active == 1 then
            提示("错误")
            gg.alert('请先关闭' .. st.display .. '换肤')
            return
        end
        local yuanName, yuanId, mubiaoName, mubiaoId = selectSkinPair(st.module)
        if yuanName then
            local state = skinState[st.key]
            state.yuanName = yuanName
            state.yuanId = yuanId
            state.mubiaoName = mubiaoName
            state.mubiaoId = mubiaoId
            提示("你选择了：将 " .. yuanName .. " 改为 " .. mubiaoName)
        else
            提示("已取消操作")
        end
    else
        提示("已取消操作")
    end
end



function xuanzepifujiesuo()
if suojiiesuohuanfu == 1 then
提示("错误")
gg.alert('请先关闭原皮换肤')
elseif suojiiesuohuanfu == 0 then
DstpiConfig = {["磁暴-微醺玫瑰"] = "100411004",["榴弹-牛仔"] = "100410012",["榴弹-小丑"] = "100410004",["大力神-远征敕令"] = "101001004",["大力神-光年"] = "101001012",["穿云-双管杠杆炮"] = "102062004",["激光-赎罪棱镜"] = "100414004",["哥斯拉巨剑-伐木小子"] = "100502004",["哥斯拉巨剑-狱影"] = "100502012",["狙击枪-高斯原理"] = "100405004",["狙击枪-猎虎COVE-B(TDC)"] = "100405012",["天罚-远誉巡行"] = "100406004",["隐身-凶影"] = "101101004",["迫击炮-托卢卡莲华"] = "100407004",["自瞄炮-哨兵"] = "100402004",["小飞侠-蝎弩"] = "100409004",["布雷器-禁行区域"] = "100601004",["炮台-叮当圣诞"] = "101102004",["跃腾-青年军"] = "100309004",["雷达-觅迹蝇"] = "100901004",["小钻头-果味甜心"] = "100501004",["烟雾-敲锣礼兵"] = "101103004"}
local dstpiMenu = {"返回"}
local dstpiList = {}
--将DstpiConfig中的所有皮肤ID添加到菜单和列表中
for name in pairs(DstpiConfig) do
table.insert(dstpiMenu, name)
table.insert(dstpiList, name)
end
提示('请选择目标皮肤')
local dstpiIdx = gg.choice(dstpiMenu, "选择目标皮肤")
if dstpiIdx and dstpiIdx ~= 1 then
local selectedpiName = dstpiList[dstpiIdx-1]
local selectedpiId = DstpiConfig[selectedpiName]
jiesuomubiaoName = selectedpiName
jiesuomubiaopiId = selectedpiId
selectedpiName = nil
selectedpiId = nil
提示("目标设置成功")
intgaipifu = 1
提示('你选择了：'..jiesuomubiaoName)
else
提示('已取消')
end
end
end

function pifujiesuo(setmoshi)
    if setmoshi == 1 then
        gg.clearResults()
        gg.removeListItems(gg.getListItems())
        gg.searchNumber("100404020", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        local count = gg.getResultsCount()
        if count == 0 then
            提示("未找到原皮肤数据")
            return
        end
        local originalResults = gg.getResults(count)
        jiesuoSave = originalResults
        gg.sleep(100)
        gg.editAll(jiesuomubiaopiId, gg.TYPE_DWORD)
        gg.clearResults()
        gg.removeListItems(gg.getListItems())
        suojiiesuohuanfu = 1
        提示('已解锁： ' .. jiesuomubiaoName)
    elseif setmoshi == 0 then
        if not jiesuoSave or #jiesuoSave == 0 then
            提示("无保存数据，无法还原")
            return
        end
        gg.clearResults()
        gg.loadResults(jiesuoSave)
        gg.sleep(100)
        gg.editAll("100404020", gg.TYPE_DWORD)
        gg.clearResults()
        gg.removeListItems(gg.getListItems())
        suojiiesuohuanfu = 0
        提示('已复原： ' .. jiesuomubiaoName)
    end
end



function xuanzehaunfure(setmokuaire)
    intgaipifure = 0
    local DstpiConfig = {}
    
    if setmokuaire == 4040 then
        DstpiConfig = {["午夜派对-SI"] = "115020", ["涅瑞斯之怒"] = "115001", ["鞭炮加特林"] = "115002", 
                       ["宿命"] = "115003", ["贪噬"] = "115004", ["赴险伙伴"] = "115005", ["落日"] = "115006", 
                       ["多管艺术"] = "115007", ["恶魔夫人"] = "115008", ["摩尔斯的啄木鸟"] = "115009", 
                       ["圣者遗言"] = "115010", ["断罪荣光"] = "115011", ["狂躁症"] = "115012", ["灼骨"] = "115013", 
                       ["恶魔夫人(TDC)"] = "115014", ["库灵臂"] = "115015", ["蚩龙巡世"] = "115016", 
                       ["蚩龙巡世-敖烈"] = "115017", ["蚩龙巡世-烈缺"] = "115018", ["涅瑞斯之怒-Ltd"] = "115021"}
    elseif setmokuaire == 3104010 then
        DstpiConfig = {["穿云原皮"] = "10201", ["弥赛亚"] = "1020101", ["铁拳COVE-A"] = "1022001", 
                       ["毁灭者"] = "1022002", ["双管杠杆炮"] = "1022003", ["章鱼恶霸"] = "1022004", 
                       ["多维破碎"] = "1022005", ["丧钟"] = "1022006", ["十字风暴"] = "1022007", 
                       ["刃冰"] = "1022008", ["铁拳COVE-A(TDC)"] = "1022009", ["幻影冲击"] = "1022010"}
    elseif setmokuaire == 10010 then
        DstpiConfig = {["酒桶"] = "129001", ["起源动力"] = "129002", ["聚变暗星"] = "129003", 
                       ["远征敕令"] = "129004", ["蒸汽时代"] = "129005", ["快乐喷涌"] = "129006", 
                       ["快乐喷涌-Ltd"] = "129007", ["冰气风轮"] = "129008", ["飓风"] = "129009", 
                       ["驭龙人"] = "129010", ["大神之路"] = "129011", ["光年"] = "129012", 
                       ["大嘴龙"] = "129013", ["星火"] = "129014", ["急冻咆哮"] = "129015", 
                       ["飓风(TDC)"] = "129016", ["库亚浪潮"] = "129017", ["幻焰魔光"] = "129018", 
                       ["新航路"] = "129019", ["大力神-SI"] = "129020"}
    elseif setmokuaire == 3704020 then
        DstpiConfig = {["防空炮原皮"] = "10901", ["瑞兔兆空"] = "1090101", ["皓空铸御"] = "1090102"}
    else
        提示("未知模块ID")
        return
    end
    
    local dstpiMenu = {"返回"}
    local dstpiList = {}
    for name in pairs(DstpiConfig) do
        table.insert(dstpiMenu, name)
        table.insert(dstpiList, name)
    end
    
    提示('请选择原皮肤')
    local dstpiIdx = gg.choice(dstpiMenu, "选择原皮肤")
    if dstpiIdx and dstpiIdx ~= 1 then
        local selectedpiName = dstpiList[dstpiIdx-1]
        local selectedpiId = DstpiConfig[selectedpiName]
        yuanpiName = selectedpiName
        yuanpiId = selectedpiId
        提示("原皮设置成功")
        
        提示('请选择目标皮肤')
        local dstpiIdx2 = gg.choice(dstpiMenu, "选择目标皮肤")
        if dstpiIdx2 and dstpiIdx2 ~= 1 then
            local selectedpiName = dstpiList[dstpiIdx2-1]
            local selectedpiId = DstpiConfig[selectedpiName]
            mubiaopiName = selectedpiName
            mubiaopiId = selectedpiId
            intgaipifure = 1
            提示('你选择了：将 '..yuanpiName..' 改为 '..mubiaopiName)
        else
            intgaipifure = 0
        end
    else
        intgaipifure = 0
    end
end

function quanhuanfutexiao(yuanid, mubiaoId, pimode)
    local texiaoison = 0
    local texiaoyuan, texiaomubiao
    
    if yuanid == 115020 then
        texiaoyuan = 404001
        texiaoison = 1
    end
    
    if texiaoison == 0 then
        return
    end
    
    if mubiaoId == 115004 or mubiaoId == 115013 then
        texiaomubiao = 404015
    elseif mubiaoId == 115002 then
        texiaomubiao = 404002
    elseif mubiaoId == 115011 or mubiaoId == 115015 or mubiaoId == 115016 or mubiaoId == 115017 or mubiaoId == 115018 then
        texiaomubiao = 404014
    else
        return
    end
    
    gg.clearResults()
    local savedItems = gg.getListItems()
    gg.removeListItems(savedItems)
    
    if pimode == 1 then
        gg.searchNumber(texiaoyuan, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        local results = gg.getResults(10000)
        gg.editAll(texiaomubiao, gg.TYPE_DWORD)
        savedTexiaoResults = results
        gg.clearResults()
    else
        if savedTexiaoResults then
            gg.loadResults(savedTexiaoResults)
            gg.refineNumber(texiaomubiao, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
            gg.getResults(1000)
            gg.editAll(texiaoyuan, gg.TYPE_DWORD)
            gg.clearResults()
            savedTexiaoResults = nil
        else
            提示("没有已保存的特效记录，无法还原")
        end
    end
end

local weapons = {
    machinegun = {
        name = "机枪",
        moduleId = 4040,
        hasTexiao = true,
        switchVar = "suojiqianghuanfure",
        yuanNameVar = "jiqiangyuannamere",
        yuanIdVar = "jiqiangyuanidre",
        mubiaoNameVar = "jiqiangmubiaoNamere",
        mubiaoIdVar = "jiqiangmubiaoIdre",
        savedItemsVar = "jiqiangsavere",
        savedTexiaoVar = "jiqiangsavetexiao"
    },
    chuanyun = {
        name = "穿云",
        moduleId = 3104010,
        hasTexiao = false,
        switchVar = "suochuanyunhuanfure",
        yuanNameVar = "chuanyunyuannamere",
        yuanIdVar = "chuanyunyuanidre",
        mubiaoNameVar = "chuanyunmubiaoNamere",
        mubiaoIdVar = "chuanyunmubiaoIdre",
        savedItemsVar = "chuanyunsavere",
        savedTexiaoVar = nil
    },
    dalishen = {
        name = "大力神",
        moduleId = 10010,
        hasTexiao = false,
        switchVar = "suodalishenhuanfure",
        yuanNameVar = "dalishenyuannamere",
        yuanIdVar = "dalishenyuanidre",
        mubiaoNameVar = "dalishenmubiaoNamere",
        mubiaoIdVar = "dalishenmubiaoidre",
        savedItemsVar = "dalishensavere",
        savedTexiaoVar = nil
    },
    fangkongpao = {
        name = "防空炮",
        moduleId = 3704020,
        hasTexiao = false,
        switchVar = "suofangkongpaohuanfure",
        yuanNameVar = "fangkongpaoyuanNamere",
        yuanIdVar = "fangkongpaoyuanidre",
        mubiaoNameVar = "fangkongpaomubiaoNamere",
        mubiaoIdVar = "fangkongpaomubiaoidre",
        savedItemsVar = "fangkongpaosavere",
        savedTexiaoVar = nil
    }
}

function chooseSkinForWeapon(weapon)
    if _G[weapon.switchVar] == 1 then
        提示("错误")
        gg.alert('请先关闭' .. weapon.name .. '换肤')
        return false
    end
    xuanzehaunfure(weapon.moduleId)
    if intgaipifure == 1 then
        _G[weapon.yuanNameVar] = yuanpiName
        _G[weapon.yuanIdVar] = yuanpiId
        _G[weapon.mubiaoNameVar] = mubiaopiName
        _G[weapon.mubiaoIdVar] = mubiaopiId
        提示(yuanpiName .. ' → ' .. mubiaopiName)
        return true
    else
        提示('已取消')
        return false
    end
end

function huanfu2(yuanId, yuanName, mubiaoId, mubiaoName, mode)
    gg.clearResults()
    local searchId = (mode == 1) and yuanId or mubiaoId
    gg.searchNumber(searchId, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    local results = gg.getResults(10000)
    if not results or #results == 0 then return end
    local targetId = (mode == 1) and mubiaoId or yuanId
    for i, v in ipairs(results) do
        v.value = targetId
        v.freeze = false
    end
    gg.setValues(results)
    lingshipisavedItems = results
    gg.clearResults()
end

function switch2On(weapon)
    _G[weapon.switchVar] = 1
    
    if weapon.hasTexiao then
        quanhuanfutexiao(_G[weapon.yuanIdVar], _G[weapon.mubiaoIdVar], 1)
        if weapon.savedTexiaoVar then
            _G[weapon.savedTexiaoVar] = savedTexiaoResults
        end
    end
    
    huanfu2(_G[weapon.yuanIdVar], _G[weapon.yuanNameVar], _G[weapon.mubiaoIdVar], _G[weapon.mubiaoNameVar], 1)
    _G[weapon.savedItemsVar] = lingshipisavedItems
    local count = 0
    if lingshipisavedItems then
        count = #lingshipisavedItems
    end
    
    提示(_G[weapon.yuanNameVar] .. ' → ' .. _G[weapon.mubiaoNameVar] .. '\n共修改' .. count .. '个数据')
end

function switch2Off(weapon)
    lingshipisavedItems = _G[weapon.savedItemsVar]
    gg.sleep(100)
    huanfu2(_G[weapon.yuanIdVar], _G[weapon.yuanNameVar], _G[weapon.mubiaoIdVar], _G[weapon.mubiaoNameVar], 0)
    
    local count = 0
    if lingshipisavedItems then
        count = #lingshipisavedItems
    end
    if weapon.hasTexiao and weapon.savedTexiaoVar then
        savedTexiaoResults = _G[weapon.savedTexiaoVar]
        gg.sleep(100)
        quanhuanfutexiao(_G[weapon.yuanIdVar], _G[weapon.mubiaoIdVar], 0)
    end
    _G[weapon.switchVar] = 0
    提示(_G[weapon.mubiaoNameVar] .. ' → ' .. _G[weapon.yuanNameVar] .. '\n共修改' .. count .. '个数据')
end

function selectSkin2()
    local menuItems = {}
    local weaponList = {}
    
    for _, weapon in pairs(weapons) do
        table.insert(menuItems, weapon.name)
        table.insert(weaponList, weapon)
    end
    table.insert(menuItems, "返回")
    
    local idx = gg.choice(menuItems, nil, "请选择要设置皮肤的武器")
    if idx and idx <= #weaponList then
        local selectedWeapon = weaponList[idx]
        chooseSkinForWeapon(selectedWeapon)
    end
end










-- 安全批量写入（用于恢复数据时避免卡顿）
function safeEdit(values)
    if not values or #values == 0 then return 0 end
    local batchSize = 50
    local successCount = 0
    for i = 1, #values, batchSize do
        local batch = {}
        local batchEnd = math.min(i + batchSize - 1, #values)
        for j = i, batchEnd do
            if values[j] and values[j].address and values[j].value then
                table.insert(batch, {
                    address = values[j].address,
                    flags = values[j].flags or gg.TYPE_DWORD,
                    value = values[j].value
                })
            end
        end
        if #batch > 0 then
            local success = pcall(gg.setValues, batch)
            if success then successCount = successCount + #batch end
        end
        if batchEnd < #values then gg.sleep(10) end
    end
    return successCount
end

-- 字符串版增伤/破盾修改（推荐使用）
function zengshang(setmokuaiid, setmoshi)
    local weaponKey = tostring(setmokuaiid)
    gg.clearResults()
    if setmoshi == 1 then
        if weaponOriginalData[weaponKey] then
            提示("该武器已开启修改")
            return
        end
        local damagePattern = ":damage_"..setmokuaiid
        local damageTarget = ":damage_"..(currentDamageLevel == 1 and "4060" or "4061")
        gg.searchNumber(damagePattern, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
        local damageResults = gg.getResults(1000)
        local damageCount = #damageResults
        local damageSuccess, originalDamage = false, {}
        if damageCount > 0 then
            for i, v in ipairs(damageResults) do
                table.insert(originalDamage, {address = v.address, flags = gg.TYPE_BYTE, value = v.value})
            end
            gg.editAll(damageTarget, gg.TYPE_BYTE)
            damageSuccess = true
        end
        local shieldPattern = ":attr_subshield_"..setmokuaiid
        local shieldTarget = ":attr_subshield_4141"
        gg.clearResults()
        gg.searchNumber(shieldPattern, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
        local shieldResults = gg.getResults(1000)
        local shieldCount = #shieldResults
        local shieldSuccess, originalShield = false, {}
        if shieldCount > 0 then
            for i, v in ipairs(shieldResults) do
                table.insert(originalShield, {address = v.address, flags = gg.TYPE_BYTE, value = v.value})
            end
            gg.editAll(shieldTarget, gg.TYPE_BYTE)
            shieldSuccess = true
        end
        if damageSuccess or shieldSuccess then
            weaponOriginalData[weaponKey] = {
                type = "both",
                damage = damageSuccess and originalDamage or nil,
                shield = shieldSuccess and originalShield or nil,
                damagePattern = damagePattern,
                damageTarget = damageTarget,
                shieldPattern = shieldPattern,
                shieldTarget = shieldTarget,
                damageLevel = currentDamageLevel
            }
            local msg = "武器 "..setmokuaiid.." 修改成功"
            if damageSuccess then msg = msg.."\n增伤: 共修改"..damageCount.."个数据" end
            if shieldSuccess then msg = msg.."\n破盾: 共修改"..shieldCount.."个数据" end
            提示(msg)
        else
            提示("未找到任何可修改的数据")
        end
    else
        local data = weaponOriginalData[weaponKey]
        if not data then
            提示("该武器未开启修改")
            return
        end
        gg.sleep(100)
        local damageRestored, shieldRestored = 0, 0
        if data.damage and #data.damage > 0 then
            local restoreDamage = {}
            for i, orig in ipairs(data.damage) do
                table.insert(restoreDamage, {address = orig.address, flags = gg.TYPE_BYTE, value = orig.value})
            end
            damageRestored = safeEdit(restoreDamage)
        end
        if data.shield and #data.shield > 0 then
            local restoreShield = {}
            for i, orig in ipairs(data.shield) do
                table.insert(restoreShield, {address = orig.address, flags = gg.TYPE_BYTE, value = orig.value})
            end
            shieldRestored = safeEdit(restoreShield)
        end
        weaponOriginalData[weaponKey] = nil
        local msg = "武器 "..setmokuaiid.." 关闭成功"
        if damageRestored > 0 then msg = msg.."\n增伤恢复: 共修改"..damageRestored.."个数据" end
        if shieldRestored > 0 then msg = msg.."\n破盾恢复: 共修改"..shieldRestored.."个数据" end
        if damageRestored == 0 and shieldRestored == 0 then msg = msg.."\n未恢复任何数据（可能地址已失效）" end
        提示(msg)
    end
    gg.clearResults()
end

-- 设置增伤等级（1级/2级）
function setDamageLevel(level)
    if level == 1 or level == 2 then
        currentDamageLevel = level
        local target = (level == 1 and "4060" or "4061")
        提示("已切换到"..level.."级增伤模式 (使用 "..target..")")
    else
        提示("增伤等级只能是1或2")
    end
end

-- 特效修改（独立功能）
function gaitexiao(texiaomokuaiid)
    local key = tostring(texiaomokuaiid)
    
    gg.clearResults()
    gg.removeListItems(gg.getListItems())
    
    gg.searchNumber(texiaomokuaiid.."01", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    local results = gg.getResults(1000)
    
    if #results > 0 then
        texiaoData[key] = {}
        for i, v in ipairs(results) do
            texiaoData[key][i] = {
                address = v.address,
                flags = gg.TYPE_DWORD,
                value = v.value
            }
        end
        
        gg.editAll("110200407", gg.TYPE_DWORD)
        提示("模块 "..texiaomokuaiid.." 特效开启成功\n修改数量: "..#results)
    else
        提示("未找到模块 "..texiaomokuaiid.." 的特效数据")
    end
    
    gg.clearResults()
    gg.removeListItems(gg.getListItems())
end

function gaitexiaooff(texiaomokuaiid)
    local key = tostring(texiaomokuaiid)
    
    if not texiaoData[key] or #texiaoData[key] == 0 then
        提示("模块 "..texiaomokuaiid.." 未开启特效")
        return
    end
    
    gg.clearResults()
    gg.removeListItems(gg.getListItems())
    
    gg.setValues(texiaoData[key])
    提示("模块 "..texiaomokuaiid.." 特效关闭成功\n恢复数量: "..#texiaoData[key])
    
    texiaoData[key] = nil
    
    gg.clearResults()
    gg.removeListItems(gg.getListItems())
end












local BASE_DIR = "/storage/emulated/0/长安/配置文件/"
local CONFIG_FILENAME = "改名字"
local FILE_PATH = BASE_DIR .. CONFIG_FILENAME

local DEFAULT_NAMES = {
    car = {input = "默认车名", output = "新的车名"},
    party = {input = "默认派对名", output = "新的派对名"},
    user = {input = "默认用户名", output = "新的用户名"}
}

local function createDir(dir)
    os.execute("mkdir -p " .. dir)
end

local function renameConfigFile(newName)
    local oldPath = FILE_PATH
    local newPath = BASE_DIR .. newName
    os.rename(oldPath, newPath)
    CONFIG_FILENAME = newName
    FILE_PATH = newPath
end

local function saveConfig(inputName, outputName, typeKey)
    createDir(BASE_DIR)
    local lines = {}
    local file = io.open(FILE_PATH, "r")
    if file then
        for line in file:lines() do
            local t = line:match("([^|]+)|.*|.*")
            if t ~= typeKey then
                table.insert(lines, line)
            end
        end
        file:close()
    end
    if inputName and outputName then
        table.insert(lines, typeKey .. "|" .. inputName .. "|" .. outputName)
    elseif inputName then
        table.insert(lines, typeKey .. "|" .. inputName .. "|")
    end
    file = io.open(FILE_PATH, "w")
    if file then
        file:write(table.concat(lines, "\n"))
        file:close()
    end
end

local function loadConfig(typeKey)
    local config = {input = DEFAULT_NAMES[typeKey].input, output = DEFAULT_NAMES[typeKey].output}
    local file = io.open(FILE_PATH, "r")
    if not file then return config end
    for line in file:lines() do
        local t, i, o = line:match("([^|]+)|([^|]*)|(.*)")
        if t == typeKey then
            config.input = i ~= "" and i or DEFAULT_NAMES[typeKey].input
            config.output = o ~= "" and o or DEFAULT_NAMES[typeKey].output
            break
        end
    end
    file:close()
    return config
end

local function getNameInput(promptText, defaultVal)
    local input = gg.prompt({promptText}, {defaultVal or ""}, {"text"})
    if not input or #input == 0 or input[1] == "" then
        return nil
    end
    return input[1]
end

function renameFile()
    local newName = getNameInput("请输入新的配置文件名:", CONFIG_FILENAME)
    if not newName then return end
    renameConfigFile(newName)
    提示("文件名已修改为: " .. newName)
end

function fix2()
    local typeKey = "car"
    local config = loadConfig(typeKey)
    local inputname = getNameInput("请输入原本的车名:", config.input)
    if not inputname then return end
    saveConfig(inputname, nil, typeKey)
    local outputname = getNameInput("请输入修改后的车名:", config.output)
    if not outputname then return end
    saveConfig(inputname, outputname, typeKey)
    gg.searchNumber(":"..inputname, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
    gg.editAll(":"..outputname, gg.TYPE_BYTE)
    gg.processResume()
    提示("初步修改成功")
    gg.sleep(1000)
    gg.searchNumber(":"..inputname, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
    gg.editAll(":"..outputname, gg.TYPE_BYTE)
    gg.processResume()
    提示("修改成功")
end

function fix3()
    local typeKey = "party"
    local config = loadConfig(typeKey)
    local inputname = getNameInput("请输入原本的派对名:", config.input)
    if not inputname then return end
    saveConfig(inputname, nil, typeKey)
    local outputname = getNameInput("请输入修改后的派对名:", config.output)
    if not outputname then return end
    saveConfig(inputname, outputname, typeKey)
    gg.searchNumber(":"..inputname, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
    gg.editAll(":"..outputname, gg.TYPE_BYTE)
    gg.processResume()
    提示("初步修改成功")
    gg.sleep(1000)
    gg.searchNumber(":"..inputname, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
    gg.editAll(":"..outputname, gg.TYPE_BYTE)
    gg.processResume()
    提示("修改成功")
end

function fix1()
    local typeKey = "user"
    local config = loadConfig(typeKey)
    local inputname = getNameInput("请输入原本的用户名:", config.input)
    if not inputname then return end
    saveConfig(inputname, nil, typeKey)
    local outputname = getNameInput("请输入修改后的用户名:", config.output)
    if not outputname then return end
    saveConfig(inputname, outputname, typeKey)
    gg.searchNumber(":"..inputname, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
    gg.editAll(":"..outputname, gg.TYPE_BYTE)
    gg.processResume()
    提示("初步修改成功")
    gg.sleep(1000)
    gg.searchNumber(":"..inputname, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
    gg.editAll(":"..outputname, gg.TYPE_BYTE)
    gg.processResume()
    提示("修改成功")
end

function fix4()
local inputname = "暂无排名"
local outputname = "全国第一"
gg.searchNumber(":"..inputname, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":"..outputname, gg.TYPE_BYTE)
gg.processResume()
提示("初步修改成功")
gg.sleep(1000)
gg.searchNumber(":"..inputname, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":"..outputname, gg.TYPE_BYTE)
gg.processResume()
提示("修改成功")
end




gravityAddr = nil

function wuzhongli(setwuzhongli, zidinyizhongli)
    if setwuzhongli == 1 then

        if not gravityAddr then

            gg.clearResults()
            local savedItems = gg.getListItems()
            gg.removeListItems(savedItems)

            gg.searchNumber("4593671619917905920", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
            local results = gg.getResults(1000)
            if #results == 0 then
                提示("未找到目标地址")
                return
            end
            for i, v in ipairs(results) do
                v.address = v.address + 16
            end
            gg.loadResults(results)

            gg.refineNumber("4575657221408423936", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
            results = gg.getResults(1000)
            if #results == 0 then
                提示("未找到目标地址")
                return
            end
            for i, v in ipairs(results) do
                v.address = v.address + 12
            end
            gg.loadResults(results)

            gg.refineNumber("65792", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
            results = gg.getResults(1000)
            if #results == 0 then
                提示("未找到目标地址")
                return
            end
            for i, v in ipairs(results) do
                v.address = v.address - 8
            end
            gg.loadResults(results)

            local final = gg.getResults(1)
            if #final == 0 then
                提示("未找到目标地址")
                return
            end
            gravityAddr = final[1].address
            gg.clearResults()
        end

        sj = {{address = gravityAddr, value = 0}}
        if zidinyizhongli == 1 then
            xg3(nil, 16, 0, true, "(自定义重力)")
        else
            xg1(0, 16, 0, true)
        end
        提示("无重力已开启" .. (zidinyizhongli == 1 and "（自定义）" or ""))
        
    else
        if gravityAddr then
            sj = {{address = gravityAddr, value = 1}}
            xg1(1, 16, 0, false)
            gravityAddr = nil
            提示("无重力已关闭")
        else
            提示("请先开启无重力")
        end
        gg.clearResults()
    end
end


lastModifiedValue = nil
rememberLastValue = false
lastOffsetValue = 16

function 破隐自定义()
local ttt = S_Pointer({"libclient.so:bss", "Cb"}, {0x459C50, 0x10, 0x18, 0x0}, true)
local cv = gg.getValues({{address = ttt, flags = lastOffsetValue}})[1].value
local displayOffset = rememberLastValue and lastOffsetValue or 16
local input = gg.prompt({
'输入值 [当前值:'..cv..']',
'偏移值 [当前值:'..displayOffset..']',
'记住上次输入值'
}, {
rememberLastValue and (lastModifiedValue or cv) or cv,
displayOffset,
rememberLastValue
}, {
'number', 'number', 'checkbox'
})
if input then
rememberLastValue = input[3]
local nv = tonumber(input[1]) or (rememberLastValue and lastModifiedValue) or cv
local pianyi = tonumber(input[2]) or (rememberLastValue and lastOffsetValue) or 16
if rememberLastValue then
lastModifiedValue = nv
lastOffsetValue = pianyi
end
gg.addListItems({{address = ttt, flags = pianyi, value = nv, freeze = true}})
提示(("修改成功 → 值:%s 偏移:%d"..(rememberLastValue and " (已存)" or "")):format(nv, pianyi))
else
提示("已取消")
end
end




function 腾跃缴械开()
--[[pengzhuang(8.79109954834,1115.7891,7.07539987564,1115.7892,10.95450019836,1115.7893,1)]]--备用
search(8.791099548339844,16,neicun)
py1(7.075399875640869,16,4)
py1(10.954500198364258,16,8)
py1(0.0,16,12)
xg1(888.791099548339844,16,0,false)
xg1(777.075399875640869,16,4,false)
xg1(1000.954500198364258,16,8,false)
end
 
function 腾跃缴械关()
--[[pengzhuang(8.79109954834,1115.7891,7.07539987564,1115.7892,10.95450019836,1115.7893,1)]]--备用
search(888.791099548339844,16,neicun)
py1(0.0,16,12)
xg1(8.791099548339844,16,0,false)
xg1(7.075399875640869,16,4,false)
xg1(10.954500198364258,16,8,false)
end
 
function 鹰驰缴械开()
search(9.132800102233887,16,neicun)
py1(8.592900276184082,16,4)
py1(9.036499977111816,16,8)
py1(0.0,16,12)
xg1(999.132800102233887,16,0,false)
xg1(888.592900276184082,16,4,false)
xg1(999.036499977111816,16,8,false)
end
 
function 鹰驰缴械关()
search(999.132800102233887,16,neicun)
py1(0.0,16,12)
xg1(9.132800102233887,16,0,false)
xg1(8.592900276184082,16,4,false)
xg1(9.036499977111816,16,8,false)
end
 
function 大力神缴械开()
search(9.31659984588623,16,neicun)
py1(9.210000038146973,16,-4)
py1(9.896499633789062,16,4)
py1(0.0,16,8)
xg1(999.210000038146973,16,-4,false)
xg1(999.31659984588623,16,0,false)
xg1(999.896499633789062,16,4,false)
end
 
function 大力神缴械关()
search(999.31659984588623,16,neicun)
py1(0.0,16,8)
xg1(9.210000038146973,16,-4,false)
xg1(9.31659984588623,16,0,false)
xg1(9.896499633789062,16,4,false)
end
 
function 海王盾缴械开()
search(4.0507001876831055,16,neicun)
py1(4.0507001876831055,16,0)
py1(4.6645002365112305,16,8)
py1(0.0,16,12)
xg1(1444.0507001876831055,16,0,false)
xg1(1444.0507001876831055,16,0,false)
xg1(1444.6645002365112305,16,8,false)
end
 
function 海王盾缴械关()
search(1444.0507001876831055,16,neicun)
py1(0.0,16,12)
xg1(4.0507001876831055,16,0,false)
xg1(4.0507001876831055,16,0,false)
xg1(4.6645002365112305,16,8,false)
end
 
function 重装魔方缴械开()
search(10.077400207519531,16,neicun)
py1(10.077400207519531,16,4)
py1(10.077400207519531,16,8)
py1(0.0,16,12)
xg1(1000.077400207519531,16,0,false)
xg1(1000.077400207519531,16,4,false)
xg1(1000.077400207519531,16,8,false)
end
 
function 重装魔方缴械关()
search(1000.077400207519531,16,neicun)
py1(0.0,16,12)
xg1(10.077400207519531,16,0,false)
xg1(10.077400207519531,16,4,false)
xg1(10.077400207519531,16,8,false)
end
 
function 天行者缴械开()
search(7.691100120544434,16,neicun)
py1(8.28849983215332,16,4)
py1(10.892000198364258,16,8)
py1(0.0,16,12)
xg1(777.691100120544434,16,0,false)
xg1(888.28849983215332,16,4,false)
xg1(1000.892000198364258,16,8,false)
end
 
function 天行者缴械关()
search(777.691100120544434,16,neicun)
py1(0.0,16,12)
xg1(7.691100120544434,16,0,false)
xg1(8.28849983215332,16,4,false)
xg1(10.892000198364258,16,8,false)
end
 
function 午夜派对缴械开()
--[[pengzhuang(8.9139995575,1111.7891,8.22770023346,1111.7892,10.25059986115,1111.7893,1)]]--备用
search(8.913999557495117,16,neicun)
py1(8.227700233459473,16,4)
py1(10.25059986114502,16,8)
py1(0.0,16,12)
xg1(888.913999557495117,16,0,false)
xg1(888.227700233459473,16,4,false)
xg1(1000.25059986114502,16,8,false)
end
 
function 午夜派对缴械关()
--[[pengzhuang(8.9139995575,1111.7891,8.22770023346,1111.7892,10.25059986115,1111.7893,0)]]--备用
search(888.913999557495117,16,neicun)
py1(0.0,16,12)
xg1(8.913999557495117,16,0,false)
xg1(8.227700233459473,16,4,false)
xg1(10.25059986114502,16,8,false)
end
 
function 穿云缴械开()
search(11.614899635314941,16,neicun)
py1(9.922300338745117,16,-8)
py1(7.720600128173828,16,-4)
py1(0.0,16,4)
xg1(999.922300338745117,16,-8,false)
xg1(777.720600128173828,16,-4,false)
xg1(1111.614899635314941,16,0,false)
end
 
function 穿云缴械关()
search(1111.614899635314941,16,neicun)
py1(0.0,16,4)
xg1(9.922300338745117,16,-8,false)
xg1(7.720600128173828,16,-4,false)
xg1(11.614899635314941,16,0,false)
end

function 穹弩缴械开()
pengzhuang(8.07380008698,1112.7891,10.5188999176,1112.7892,11.53009986877,1112.7893,1)
end
 
function 穹弩缴械关()
pengzhuang(8.07380008698,1112.7891,10.5188999176,1112.7892,11.53009986877,1112.7893,0)
end

function 特斯拉的巨剑缴械开()
pengzhuang(13.76449966431,1113.7891,1.7661999464,1113.7892,4.12569999695,1113.7893,1)
end
 
function 特斯拉的巨剑缴械关()
pengzhuang(13.76449966431,1113.7891,1.7661999464,1113.7892,4.12569999695,1113.7893,0)
end

function 小指头缴械开()
pengzhuang(4.03049993515,1114.7891,3.12579989433,1114.7892,2.92100000381,1114.7893,1)
end
 
function 小指头缴械关()
pengzhuang(4.03049993515,1114.7891,3.12579989433,1114.7892,2.92100000381,1114.7893,0)
end

function 业火焚世缴械开()
search(21.690799713134766,16,neicun)
py1(19.002899169921875,16,4)
py1(17.172199249267578,16,8)
py1(0.0,16,12)
xg1(2111.690799713134766,16,0,false)
xg1(1999.002899169921875,16,4,false)
xg1(1777.172199249267578,16,8,false)
end
 
function 业火焚世缴械关()
search(2111.690799713134766,16,neicun)
py1(0.0,16,12)
xg1(21.690799713134766,16,0,false)
xg1(19.002899169921875,16,4,false)
xg1(17.172199249267578,16,8,false)
end
 
function 寂静之声缴械开()
search(8.98840045928955,16,neicun)
py1(13.034299850463867,16,4)
py1(12.887700080871582,16,8)
py1(0.0,16,12)
xg1(888.98840045928955,16,0,false)
xg1(1333.034299850463867,16,4,false)
xg1(1222.887700080871582,16,8,false)
end
 
function 寂静之声缴械关()
search(888.98840045928955,16,neicun)
py1(0.0,16,12)
xg1(8.98840045928955,16,0,false)
xg1(13.034299850463867,16,4,false)
xg1(12.887700080871582,16,8,false)
end
 
function 苍穹守护缴械开()
search(7.780399799346924,16,neicun)
py1(20.316699981689453,16,4)
py1(9.354499816894531,16,8)
py1(0.0,16,12)
xg1(777.780399799346924,16,0,false)
xg1(2000.316699981689453,16,4,false)
xg1(999.354499816894531,16,8,false)
end
 
function 苍穹守护缴械关()
search(777.780399799346924,16,neicun)
py1(0.0,16,12)
xg1(7.780399799346924,16,0,false)
xg1(20.316699981689453,16,4,false)
xg1(9.354499816894531,16,8,false)
end
 
function 野蜂缴械开()
search(10.114299774169922,16,neicun)
py1(9.484100341796875,16,4)
py1(14.326499938964844,16,8)
py1(0.0,16,12)
xg1(1000.114299774169922,16,0,false)
xg1(999.484100341796875,16,4,false)
xg1(1444.326499938964844,16,8,false)
end
 
function 野蜂缴械关()
search(1000.114299774169922,16,neicun)
py1(0.0,16,12)
xg1(10.114299774169922,16,0,false)
xg1(9.484100341796875,16,4,false)
xg1(14.326499938964844,16,8,false)
end

function 破隐()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x459C50, 0x10, 0x18, 0x0}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 1145}})
end

function 海王盾变红色()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x459C50, 0x10, 0x18, 0x0}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = -10000000000}})
end

function 海王盾变深红色()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x459C50, 0x10, 0x18, 0x0}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 9999999999999999999999999}})
end

function 海王盾变青与红色()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x459C50, 0x10, 0x18, 0x0}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = -9999999999999999999999999}})
end

function 地面透明()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x459C50, 0x10, 0x18, 0x0}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 32, value = 9999}})
end

function 恢复以上功能()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x459C50, 0x10, 0x18, 0x0}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 32, value = 31138512896}})
gg.sleep(50)
local t = {"libclient.so:bss", "Cb"}
local tt = {0x459C50, 0x10, 0x18, 0x0}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 2.0}})
end

function 隐藏UI()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("0.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("0.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("114511.634", gg.TYPE_FLOAT)
提示("开启成功")
gg.clearResults()
end
end

function 隐藏UI2()
search(8.47695338e-21,16,16384)
xg1(8.47695338e-20,16,0,false)
gg.sleep(100)
xg1(8.47695338e-21,16,0,false)
提示("切换至后台即可恢复")
end

function 恢复UI()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("114511.634", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("恢复失败")
else
gg.searchNumber("114511.634", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0.1", gg.TYPE_FLOAT)
提示("恢复成功")
gg.clearResults()
end
end

function 无法移动()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("0.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("0.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("-0.958", gg.TYPE_FLOAT)
提示("开启成功")
gg.clearResults()
end
end

function 恢复移动()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("-0.958", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("恢复失败")
else
gg.searchNumber("-0.958", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0.1", gg.TYPE_FLOAT)
提示("恢复成功")
gg.clearResults()
end
end

function 视角锁定()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("0.03", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("0.03", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(999999)
gg.editAll("114514", gg.TYPE_FLOAT)
提示("开启成功")
gg.clearResults()
end
end

function 恢复视角()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("恢复失败")
else
gg.searchNumber("114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(999999)
gg.editAll("0.03", gg.TYPE_FLOAT)
提示("恢复成功")
gg.clearResults()
end
end

function 特效加速()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("1", gg.TYPE_FLOAT)
gg.clearResults()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("特效加速失败")
else
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(85)
gg.editAll("250", gg.TYPE_FLOAT)
提示("特效加速成功")
gg.clearResults()
end
end

function 特效减速()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("1", gg.TYPE_FLOAT)
gg.clearResults()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("特效减速失败")
else
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(85)
gg.editAll("0.00115", gg.TYPE_FLOAT)
提示("特效减速成功")
gg.clearResults()
end
end

function 恢复特效速度()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
gg.searchNumber("0.00115", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(85)
gg.editAll("1", gg.TYPE_FLOAT)
提示("恢复成功")
gg.clearResults()
else
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("1", gg.TYPE_FLOAT)
提示("恢复成功")
gg.clearResults()
end
end

function 自定义倾斜角度()
editData(
{
{["memory"] = neicun},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = nil,["offset"] =-0x1C, ["type"] = F,["freeze"] = true},
{["value"] = nil,["offset"] =-0x14, ["type"] = F,["freeze"] = true},
},
true
)
end

function 不倒翁()
editData(
{
{["memory"] = neicun},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = 0,["offset"] =-0x1C, ["type"] = F,["freeze"] = true},
{["value"] = 0,["offset"] =-0x14, ["type"] = F,["freeze"] = true},
}
)
end

function 反向不倒翁()
editData(
{
{["memory"] = neicun},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = 1,["offset"] =-0x1C, ["type"] = F,["freeze"] = true},
{["value"] = 1,["offset"] =-0x14, ["type"] = F,["freeze"] = true},
}
)
end

function 不倒翁关()
editData(
{
{["memory"] = neicun},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = 0,["offset"] =-0x1C, ["type"] = F,["freeze"] = false},
{["value"] = 0,["offset"] =-0x14, ["type"] = F,["freeze"] = false},
}
)
end

function 爬墙()
gg.sleep(300)
search(17039360,4,neicun)
py1(65792,4,56)
xg1(900,16,-8,true)
end

cachedZuanDiAddrs = nil

function isCachedValid()
    if not cachedZuanDiAddrs or #cachedZuanDiAddrs == 0 then
        return false
    end
    local checkCnt = math.min(3, #cachedZuanDiAddrs)
    local checkList = {}
    for i = 1, checkCnt do
        checkList[i] = {address = cachedZuanDiAddrs[i].address - 96, flags = 4}
    end
    local vals = gg.getValues(checkList)
    if not vals then return false end
    for i = 1, checkCnt do
        if vals[i].value ~= 17039364 then return false end
    end
    return true
end

function getZuanDiAddrList(forceRefresh)
    if not forceRefresh and isCachedValid() then
        return cachedZuanDiAddrs
    end
    gg.clearResults()
    gg.setRanges(neicun)
    gg.searchNumber("17039364", 4, false, gg.SIGN_EQUAL, 0, -1)
    if gg.getResultCount() == 0 then
        提示("搜索基址失败")
        return nil
    end
    local baseAddr = gg.getResults(gg.getResultCount())
    local readList = {}
    for i = 1, #baseAddr do
        table.insert(readList, {address = baseAddr[i].address - 36, flags = 4})
        table.insert(readList, {address = baseAddr[i].address - 32, flags = 4})
    end
    local vals = gg.getValues(readList)
    cachedZuanDiAddrs = {}
    for i = 1, #baseAddr do
        local val1 = vals[(i - 1) * 2 + 1].value
        local val2 = vals[(i - 1) * 2 + 2].value
        if val1 == 16777215 and val2 == 257 then
            table.insert(cachedZuanDiAddrs, {address = baseAddr[i].address + 96, flags = 16})
        end
    end
    if #cachedZuanDiAddrs == 0 then
        提示("过滤条件失败")
        cachedZuanDiAddrs = nil
        return nil
    end
    gg.clearResults()
    return cachedZuanDiAddrs
end

function clearZuanDiCache()
    cachedZuanDiAddrs = nil
end

function 钻地车体()
    local addrs = getZuanDiAddrList()
    if not addrs or #addrs == 0 then
        提示("未找到地址")
        return
    end
    local oldSj = sj
    sj = addrs
    xg1(-0.000000001, 16, 0, true)
    sj = oldSj
end

function 钻地悬空推荐解体()
    local addrs = getZuanDiAddrList()
    if not addrs or #addrs == 0 then
        提示("未找到地址")
        return
    end
    local oldSj = sj
    sj = addrs
    xg1(-1000, 16, 0, true)
    sj = oldSj
end

function 恢复钻地解体用()
    local addrs = getZuanDiAddrList()
    if not addrs or #addrs == 0 then
        提示("未找到地址")
        return
    end
    local oldSj = sj
    sj = addrs
    xg1(0.007352941203862429, 16, 0, false)
    gg.sleep(100)
    xg1(1, 16, 0, false)
    sj = oldSj
    gg.clearResults()
    clearZuanDiCache()
end

function 脱离卡实体墙解体用()
    local frozenAddrs = {}
    editData(
        {
            {["memory"] = neicun},
            {["name"] = ""},
            {["value"] = 17039364, ["type"] = D},
            {["lv"] = 1111752704, ["offset"] = 0x44, ["type"] = D},
        },
        {
            {["value"] = 0, ["offset"] = -0x1C, ["type"] = F, ["freeze"] = true},
            {["value"] = 0, ["offset"] = -0x14, ["type"] = F, ["freeze"] = true},
        }
    )
    local addrs = getZuanDiAddrList(true)
    if addrs and #addrs > 0 then
        local oldSj = sj
        sj = addrs
        xg1(1700, 16, 0, true)
        for i = 1, #addrs do
            table.insert(frozenAddrs, {address = addrs[i].address})
        end
        sj = oldSj
    end
    if addrs and #addrs > 0 then
        local baseAddrs = {}
        for i = 1, #addrs do
            table.insert(baseAddrs, {address = addrs[i].address - 104, flags = 16})
        end
        local oldSj = sj
        sj = baseAddrs
        xg1(4200, 16, 0, false)
        sj = oldSj
    end
    gg.sleep(3500)
    local addrs2 = getZuanDiAddrList(true)
    if addrs2 and #addrs2 > 0 then
        local oldSj2 = sj
        sj = addrs2
        xg1(0.007352941203862429, 16, 0, false)
        gg.sleep(100)
        xg1(1, 16, 0, false)
        sj = oldSj2
    editData(
{
{["memory"] = neicun},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = 0,["offset"] =-0x1C, ["type"] = F,["freeze"] = false},
{["value"] = 0,["offset"] =-0x14, ["type"] = F,["freeze"] = false},
}
)
    end
    if #frozenAddrs > 0 then
        gg.removeListItems(frozenAddrs)
    end
    gg.clearResults()
    clearZuanDiCache()
end

function 全图毒人直接版开()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999,16,96,true,true,"(自定义全图毒人)")
end

function 全图毒人直接版关()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(0.007352941203862429,16,96,false)
end

function 毒人Promax开()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(-9999999999999999,16,76,true,true,"(自定义毒人Promax)")
end

function 毒人Promax关()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(0,16,76,false)
end

function 远程拾取范围()
search(2.7551769886168823E-40,16,neicun)
py1(9.183409485952689E-41,16,-196)
py1(9.183549615799121E-41,16,-188)
py1(0.19999998807907104,16,-140)
py1(3.7414668997472616E-43,16,-136)
py1(4.203895392974451E-45,16,-128)
py1(2.7551769886168823E-40,16,0)
xg1(9999,16,-120,冻结拾取范围)
xg1(9999,16,-116,冻结拾取范围)
xg1(9999,16,-124,冻结拾取范围)
end

function 弱网()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("0.00111516414", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("0.00111516414", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local count = gg.getResultCount()
if count == 0 then
提示("未找到弱网数据")
return
end
gg.editAll("99.9999114514", gg.TYPE_FLOAT)
gg.clearResults()
提示("弱网已开启\n共修改" .. count .. "个数据")
end

function 恢复弱网()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("99.9999114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("99.9999114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local count = gg.getResultCount()
if count == 0 then
提示("未找到弱网数据")
return
end
gg.editAll("0.00111516414", gg.TYPE_FLOAT)
gg.clearResults()
提示("弱网已关闭\n共修改" .. count .. "个数据")
end

-- 弱网备份存储
_WeakNetBackup = nil

function 初始化弱网(force)
force = force or false
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("0.00111516414", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local count = gg.getResultCount()
local isRecoverMode = false
if not force and count == 0 then
gg.searchNumber("99.9999114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
count = gg.getResultCount()
if count > 0 then
提示("检测到弱网未恢复，请先「恢复快速弱网」再初始化")
return false
end
end
if force and count == 0 then
gg.searchNumber("99.9999114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
count = gg.getResultCount()
if count > 0 then
isRecoverMode = true
end
end
if count == 0 then
提示("初始化弱网失败：未找到数据")
return false
end
local results = gg.getResults(count)
if isRecoverMode then
gg.editAll("0.00111516414", gg.TYPE_FLOAT)
gg.searchNumber("0.00111516414", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
results = gg.getResults(gg.getResultCount())
end
_WeakNetBackup = {}
for i = 1, #results do
_WeakNetBackup[i] = {
address = results[i].address,
flags = gg.TYPE_FLOAT,
value = 0.00111516414
}
end
gg.clearResults()
if force and isRecoverMode then
gg.clearResults()
提示("弱网强制初始化成功（已自动恢复并重新储存）\n共储存" .. #_WeakNetBackup .. "个地址")
elseif force then
提示("强制初始化弱网成功\n共储存" .. #_WeakNetBackup .. "个地址")
else
提示("初始化弱网成功\n共储存" .. #_WeakNetBackup .. "个地址")
end
return true
end

function 快速弱网()
HK()
if not _WeakNetBackup or #_WeakNetBackup == 0 then
提示("请先执行初始快速弱网")
return false
end
local checkList = {}
for i = 1, #_WeakNetBackup do
checkList[i] = {address = _WeakNetBackup[i].address, flags = _WeakNetBackup[i].flags}
end
local checkValues = gg.getValues(checkList)
local validCount = 0
for i = 1, #checkValues do
if checkValues[i] and checkValues[i].value then
validCount = validCount + 1
end
end
if validCount == 0 then
提示("弱网开启失败：储存的地址已失效，请重新初始化")
_WeakNetBackup = nil
return false
end
local modifyList = {}
for i = 1, #_WeakNetBackup do
modifyList[i] = {
address = _WeakNetBackup[i].address,
flags = _WeakNetBackup[i].flags,
value = 99.9999114514
}
end
gg.setValues(modifyList)
提示("弱网已开启\n共修改" .. validCount .. "个数据")
return true
end

function 恢复快速弱网()
HK()
if not _WeakNetBackup or #_WeakNetBackup == 0 then
提示("请先执行初始快速弱网")
return false
end
local checkList = {}
for i = 1, #_WeakNetBackup do
checkList[i] = {address = _WeakNetBackup[i].address, flags = _WeakNetBackup[i].flags}
end
local checkValues = gg.getValues(checkList)
local validCount = 0
for i = 1, #checkValues do
if checkValues[i] and checkValues[i].value then
validCount = validCount + 1
end
end
if validCount == 0 then
提示("弱网恢复失败：储存的地址已失效，请重新初始化")
_WeakNetBackup = nil
return false
end
gg.setValues(_WeakNetBackup)
提示("弱网已关闭\n共修改" .. validCount .. "个数据")
return true
end

function 删除地图()
search(4.3572124460608017E27,16,16384)
xg1(-1,16,4,false)
end

function 恢复删除地图()
search(4.3572124460608017E27,16,16384)
xg1(14428.5986328125,16,4,false)
end

function 穿墙推荐解体()
search(8.2795719786463182E-41,16,neicun)
py1(5.739718509874451E-42,16,12)
xg1(0,64,40,true)
xg1(0,64,72,true)
xg1(0,64,76,true)
xg1(0,64,72,true)
xg1(0,64,76,true)
end

function 转圈圈()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(969.37,16,56,true)
end

function 自定义转圈圈()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(969.37,16,56,true,true,"(自定义转圈圈)")
end

function 恢复娱乐功能()
gg.clearResults()
gg.clearList()
提示("恢复成功")
end










function 不漂移加速()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xCEBCC8, 0x50, 0x8, 0x8, 0x8, 0x30, 0x38, 0x40, 0x18, 0x14}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 2.4}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xCEBCC8, 0x50, 0x8, 0x8, 0x8, 0x8, 0x30, 0x8, 0x18, 0x20, 0x14}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value =2.4}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xCEBCC8, 0x50, 0x8, 0x8, 0x8, 0x8, 0x30, 0x38, 0x40, 0x18, 0x14}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 2.4}})
end

function 不漂移加速关闭()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xCEBCC8, 0x50, 0x8, 0x8, 0x8, 0x30, 0x38, 0x40, 0x18, 0x14}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 1.875}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xCEBCC8, 0x50, 0x8, 0x8, 0x8, 0x8, 0x30, 0x8, 0x18, 0x20, 0x14}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 1.875}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xCEBCC8, 0x50, 0x8, 0x8, 0x8, 0x8, 0x30, 0x38, 0x40, 0x18, 0x14}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 1.875}})
end

function 频率加速()
    local basePath = {"libclient.so:bss", "Cb"}
    local pointerConfigs = {
        {0xCEBCC8, 0x50, 0x8, 0x8, 0x8, 0x30, 0x38, 0x40, 0x18, 0x14},
        {0xCEBCC8, 0x50, 0x8, 0x8, 0x8, 0x8, 0x30, 0x8, 0x18, 0x20, 0x14},
        {0xCEBCC8, 0x50, 0x8, 0x8, 0x8, 0x8, 0x30, 0x38, 0x40, 0x18, 0x14},
    }
    
    local firstAddr = S_Pointer(basePath, pointerConfigs[1], true)
    if firstAddr == "0x0" then return end
    
    local cv = gg.getValues({{address = firstAddr, flags = 16}})[1].value
    
    local input = gg.prompt({
        '值 [当前:' .. cv .. ']',
        '记住'
    }, {
        remember and (lastVal or cv) or cv,
        remember
    }, {
        'number', 'checkbox'
    })
    
    if not input then 提示("已取消") return end
    
    remember = input[2]
    local nv = tonumber(input[1]) or (remember and lastVal) or cv
    if remember then lastVal = nv end

    for _, off in ipairs(pointerConfigs) do
        gg.setValues({{address = S_Pointer(basePath, off, true), flags = 16, value = nv}})
    end
    
    提示(string.format("共修改 %d 个数据 → %s%s", #pointerConfigs, nv, remember and " (已储存)" or ""))
end

function 特殊加速()
    local t = {"libclient.so:bss", "Cb"}
    local tt = {0xC7E798, 0x40, 0x30, 0x28, 0x70, 0x10}
    local ttt = S_Pointer(t, tt, true)
    local cv = gg.getValues({{address = ttt, flags = 64}})[1].value
    
    local i = gg.prompt({
        '值[当前:' .. cv .. ']',
        '记住上次输入值'
    }, {
        rememberLastValue and (lastModifiedValue or cv) or cv,
        rememberLastValue
    }, {
        'number', 'checkbox'
    })
    
    if not i then
        提示("已取消")
        return
    end
    
    rememberLastValue = i[2]
    local nv = tonumber(i[1]) or (rememberLastValue and lastModifiedValue) or cv
    if rememberLastValue then lastModifiedValue = nv end

    gg.setValues({{address = ttt, flags = 64, value = nv}})
    提示(("修改成功 - 新值→%s" .. (rememberLastValue and "(已储存)" or "")):format(nv))
    
    gg.sleep(1)
    提示("请解体修复")
    editData(
        {
            {["memory"] = gg.REGION_C_ALLOC},
            {["name"] = ""},
            {["value"] = 17039364, ["type"] = D},
            {["lv"] = 1111752704, ["offset"] = 0x44, ["type"] = D},
        },
        {
            {["value"] = 0, ["offset"] = -0x1C, ["type"] = F, ["freeze"] = true},
            {["value"] = 0, ["offset"] = -0x14, ["type"] = F, ["freeze"] = true},
        }
    )
end

function 特殊加速关闭()
    local t = {"libclient.so:bss", "Cb"}
    local tt = {0xC7E798, 0x40, 0x30, 0x28, 0x70, 0x10}
    local ttt = S_Pointer(t, tt, true)
    gg.setValues({{address = ttt, flags = 64, value = 0.5}})
    
    gg.sleep(1)
    提示("请解体修复")
    editData(
        {
            {["memory"] = gg.REGION_C_ALLOC},
            {["name"] = ""},
            {["value"] = 17039364, ["type"] = D},
            {["lv"] = 1111752704, ["offset"] = 0x44, ["type"] = D},
        },
        {
            {["value"] = 0, ["offset"] = -0x1C, ["type"] = F, ["freeze"] = false},
            {["value"] = 0, ["offset"] = -0x14, ["type"] = F, ["freeze"] = false},
        }
    )
end

function 大力神加速开()
local info = gg.getTargetInfo()
if info.x64 then
提示("检测为64位")
提示('64位大力神加速正在开启')
search(6.11029052734375,16,neicun)
py1(1.75,16,24)
py1(1.75,16,48)
py1(2.0,16,72)
xg3(nil,16,96,true,"(自定义大力神加速)")
else
提示('32位大力神加速正在开启')
search(5381523328,32,neicun)
xg3(nil,16,64,true,"(自定义大力神加速)")
end
end

function 大力神加速关()
local info = gg.getTargetInfo()
if info.x64 then
提示('64位大力神加速正在关闭')
search(6.11029052734375,16,neicun)
py1(1.75,16,24)
py1(1.75,16,48)
py1(2.0,16,72)
xg1(1.875,16,96,false)
else
提示('32位大力神加速正在关闭')
search(5381523328,32,neicun,false)
xg1(1.875,16,64,false)
end
end

function 灰屏共鸣()
local info = gg.getTargetInfo()
if info.x64 then
提示('64位灰屏共鸣正在开启')
search(6.11029052734375, 16, neicun)
py1(1.75, 16, 24)
py1(1.75, 16, 48)
py1(2.0, 16, 72)
xg1(9999,16,96,true)
else
提示('32位灰屏共鸣正在开启')
search(5381523328,32,neicun)
xg1(9999,16,64,true)
end
end

function 灰屏共鸣关闭()
local info = gg.getTargetInfo()
if info.x64 then
提示('64位灰屏共鸣正在关闭')
search(6.11029052734375,16,neicun)
py1(1.75,16,24)
py1(1.75,16,48)
py1(2.0,16,72)
xg1(1.875,16,96,false)
else
提示('32位灰屏共鸣正在关闭')
search(5381523328,32,neicun)
xg1(1.875,16,64,false)
end
end



function 停止发包开()
    local info = gg.getTargetInfo()
    local is64 = info and info.x64 or false
    
    gg.clearResults()
    gg.searchNumber("-2.01750163e20", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    local results = gg.getResults(500)
    for i, v in ipairs(results) do
        v.address = v.address - (is64 and 8 or 4)
    end
    gg.loadResults(results)
    
    gg.refineNumber("1.40129846e-44", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    local results2 = gg.getResults(500)
    for i, v in ipairs(results2) do
        v.address = v.address + (is64 and 20 or 12)
    end
    gg.loadResults(results2)
    gg.editAll("946767.125", gg.TYPE_FLOAT)
    gg.clearResults()
    提示("已开启停止发包")
end

function 停止发包关()
    local info = gg.getTargetInfo()
    local is64 = info and info.x64 or false
    
    gg.clearResults()
    gg.searchNumber("-2.01750163e20", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    local results = gg.getResults(500)
    for i, v in ipairs(results) do
        v.address = v.address - (is64 and 8 or 4)
    end
    gg.loadResults(results)
    
    gg.refineNumber("1.40129846e-44", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    local results2 = gg.getResults(500)
    for i, v in ipairs(results2) do
        v.address = v.address + (is64 and 20 or 12)
    end
    gg.loadResults(results2)
    gg.editAll("4.51408149e27", gg.TYPE_FLOAT)
    gg.clearResults()
    提示("已关闭停止发包")
end

function 核心加速开()
search(1060320052,4,neicun)
py1(1065353216,4,-24)
py1(1075000115,4,-16)
py1(1065353216,4,40)
py1(1066949149,4,52)
end

function 核心加速关()
提示("已关闭,改装后恢复")
end

function 核心激活开()
search(493312,4,neicun)
py1(681216,4,16)
xg3(5,4,-308,true,true,"(自定义核心激活)")
end

function 核心激活关()
search(493312,4,neicun)
py1(681216,4,16)
xg1(30,4,-308,false)
end

savedYData = nil
savedYAddr = nil

function 核心伪Y加加开()
savedYData = nil
savedYAddr = nil
search(992204554, 4, neicun)
py1(992204554, 4, 0)
py1(1956496814, 4, 8)
if not sj or #sj == 0 then
提示("搜索失败，无法开启")
return false
end
local addr = sj[1].address + 76
local vals = gg.getValues({{address = addr, flags = 16}})
if vals and vals[1] then
savedYAddr = addr
savedYData = vals[1].value
else
提示("读取原始值失败")
return false
end
xg3(-0.35, 16, 76, true, true, "(自定义核心伪Y++)")
return true
end

function 核心伪Y加加关()
if savedYAddr and savedYData ~= nil then
gg.removeListItems({{address = savedYAddr, flags = 16}})
gg.sleep(100)
gg.setValues({{address = savedYAddr, flags = 16, value = savedYData}})
提示("核心伪Y++已关闭，已恢复原始值")
savedYAddr = nil
savedYData = nil
else
search(992204554, 4, neicun)
py1(992204554, 4, 0)
py1(1956496814, 4, 8)
if sj and #sj > 0 then
xg1(10086, 16, 76, false)
提示("核心伪Y++已关闭（降级恢复）")
else
提示("关闭失败，未找到目标地址")
end
end
end

xjysj = nil
function 相机Y状态开()
if not xjysj or #xjysj == 0 then
search(9666035712, 32, neicun)
py1(3, 32, 52)
py1(5, 32, 28)
py1(2, 32, 4)
xjysj = sj
else
sj = xjysj
end
xg3(nil, 64, -4, false, true, "相机Y状态")
end

function 相机Y状态关()
if not xjysj or #xjysj == 0 then
search(9666035712, 32, neicun)
py1(3, 32, 52)
py1(5, 32, 28)
py1(2, 32, 4)
xjysj = sj
else
sj = xjysj
end
xg1(10, 64, -4, false)
xjysj = nil
end

local camAddresses = {}
local frozen = false

local function getCameraAddresses()
    search("1.2566370964050293", 16, 4)
    if not sj or #sj == 0 then
        提示("未找到相机特征值，无法获取地址")
        return false
    end
    local baseAddr = sj[1].address
    camAddresses[1] = baseAddr - 80
    camAddresses[2] = baseAddr - 84
    camAddresses[3] = baseAddr - 88
    return true
end

local function freezeCamera()
    if not getCameraAddresses() then return end
    local current = gg.getValues({
        {address = camAddresses[1], flags = 16},
        {address = camAddresses[2], flags = 16},
        {address = camAddresses[3], flags = 16}
    })
    local inputs = gg.prompt(
        {"目标 X 坐标", "目标 Y 坐标", "目标 Z 坐标"},
        {tostring(current[1].value), tostring(current[2].value), tostring(current[3].value)},
        {"number", "number", "number"}
    )
    if not inputs then
        提示("已取消")
        return
    end
    local targetX = tonumber(inputs[1])
    local targetY = tonumber(inputs[2])
    local targetZ = tonumber(inputs[3])
    gg.addListItems({
        {address = camAddresses[1], flags = 16, value = targetX, freeze = true},
        {address = camAddresses[2], flags = 16, value = targetY, freeze = true},
        {address = camAddresses[3], flags = 16, value = targetZ, freeze = true}
    })
    frozen = true
    提示(string.format("相机已冻结 (%.2f, %.2f, %.2f)", targetX, targetY, targetZ))
end

local function unfreezeCamera()
    if not frozen then
        提示("相机未冻结")
        return
    end
    local removed = false
    for _, addr in ipairs(camAddresses) do
        if addr and addr ~= 0 then
            gg.removeListItems({address = addr})
            removed = true
        end
    end
    if removed then
        frozen = false
        提示("相机已解冻")
    else
        提示("未找到相机冻结项")
    end
end

snsj = nil
function 霜鸟锁定数量开()
if not snsj or #snsj == 0 then
search("2.6527537714E-314", 64, 4)
py1(0.9, 64, 20)
--py1(0.8, 64, -100)
--py1(-1.0, 64, 92)
--py1(7.0, 64, -76)
py1(0.9, 64, 44)
py1(0.1, 64, -52)
--py1(0.9, 64, 68)
snsj = sj
else
sj = snsj
end
xg3(4, 64, -4, false, true, "(自定义霜鸟锁定数量)")
end

function 霜鸟锁定数量关()
if not snsj or #snsj == 0 then
search("2.6527537714E-314", 64, 4)
py1(0.9, 64, 20)
--py1(0.8, 64, -100)
--py1(-1.0, 64, 92)
--py1(7.0, 64, -76)
py1(0.9, 64, 44)
py1(0.1, 64, -52)
--py1(0.9, 64, 68)
snsj = sj
else
sj = snsj
end
xg1(3, 64, -4, false)
snsj = nil
end


hxtycdsj = nil
function 萌新CD开()
if not hxtycdsj or #hxtycdsj == 0 then
search("5.6e-322;3", 64, 4)
gs1(3, 64)
hxtycdsj = sj
else
sj = hxtycdsj
end
xg3(0.01, 64, 0, false, true, "自定义萌新CD")
end

function 萌新CD关()
if not hxtycdsj or #hxtycdsj == 0 then
search("5.6e-322;3", 64, 4)
gs1(3, 64)
hxtycdsj = sj
else
sj = hxtycdsj
end
xg1(3, 64, 0, false)
hxtycdsj = nil
end

function 核心防水开()
gg.clearResults()
gg.searchNumber("4.46582003e30", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(1000)
gg.editAll("5.264375114", gg.TYPE_FLOAT)
提示("已开启核心防水,全局有效")
end

function 核心防水关()
gg.clearResults()
gg.searchNumber("5.264375114", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(1000)
gg.editAll("4.46582003e30", gg.TYPE_FLOAT)
gg.clearResults()
提示("已关闭核心防水")
end

function 防闪光弹开()
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("6874871693448720229", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(10)
gg.editAll("114514191981044", gg.TYPE_QWORD)
gg.clearResults()
提示("已开启防闪光弹")
end

function 防闪光弹关()
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("114514191981044", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(10)
gg.editAll("6874871693448720229", gg.TYPE_QWORD)
gg.clearResults()
提示("已关闭防闪光弹")
end

function guanfangesp(espset)
if espset == 1 then
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
gg.searchNumber("901004", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("8", gg.TYPE_DWORD)
espsave = gg.getResults(1000)
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
提示("已开启海王盾绘制,请刷新画质")
else
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
gg.loadResults(espsave)
gg.addListItems(espsave)
gg.sleep(100)
gg.refineNumber("8", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("901004", gg.TYPE_DWORD)
espsave = nil
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
提示("已关闭海王盾绘制,请刷新画质")
end
end

function 特殊视角开()
search(-1.2566370964050293,16,4)
xg3(nil,16,-72,true,true,"(特殊视角)")
end

function 特殊视角关()
search(-1.2566370964050293,16,4)
xg1(1,16,-72,false)
end




function 萌新范围开()
local qmnb = {
{['memory'] = neicun},
{['name'] = '萌新范围'},
{['value'] = 3.281599998474121, ['type'] = 16},
{['lv'] = 3.281599998474121, ['offset'] = 0, ['type'] = 16},
{['lv'] = 4.73360013961792, ['offset'] = 4, ['type'] = 16},
{['lv'] = 4.791800022125244, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 1750.1145, ['offset'] = 0, ['type'] = 16},
{['value'] = 1750.1146, ['offset'] = 4, ['type'] = 16},
{['value'] = 1750.1147, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "open")
end

function 萌新范围关()
local qmnb = {
{['memory'] = neicun},
{['name'] = '萌新范围'},
{['value'] = 1750.114501953125, ['type'] = 16},
{['lv'] = 1750.114501953125, ['offset'] = 0, ['type'] = 16},
{['lv'] = 1750.1146240234375, ['offset'] = 4, ['type'] = 16},
{['lv'] = 1750.11474609375, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 3.28159999847, ['offset'] = 0, ['type'] = 16},
{['value'] = 4.73360013962, ['offset'] = 4, ['type'] = 16},
{['value'] = 4.79180002213, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "close")
end

function 铠鼠范围开()
local qmnb = {
{['memory'] = neicun},
{['name'] = '铠鼠范围'},
{['value'] = 3.605950117111206, ['type'] = 16},
{['lv'] = 3.605950117111206, ['offset'] = 0, ['type'] = 16},
{['lv'] = 4.161499977111816, ['offset'] = 4, ['type'] = 16},
{['lv'] = 1.401298464324817E-45, ['offset'] = 12, ['type'] = 16},
}
local qmxg = {
{['value'] = 1145, ['offset'] = 0, ['type'] = 16},
{['value'] = 1145, ['offset'] = 4, ['type'] = 16},
{['value'] = 1145, ['offset'] = -4, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "open")
end

function 铠鼠范围关()
local qmnb = {
{['memory'] = neicun},
{['name'] = '铠鼠范围'},
{['value'] = 1145, ['type'] = 16},
{['lv'] = 1145, ['offset'] = 0, ['type'] = 16},
{['lv'] = 1145, ['offset'] = 4, ['type'] = 16},
{['lv'] = 1145, ['offset'] = -4, ['type'] = 16},
}
local qmxg = {
{['value'] = 3.605950117111206, ['offset'] = 0, ['type'] = 16},
{['value'] = 4.161499977111816, ['offset'] = 4, ['type'] = 16},
{['value'] = 1.401298464324817E-45, ['offset'] = -4, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "close")
end

function 火萤范围开()
local qmnb = {
{['memory'] = neicun},
{['name'] = '火萤范围'},
{['value'] = 5.846799850463867, ['type'] = 16},
{['lv'] = 5.846799850463867, ['offset'] = 0, ['type'] = 16},
{['lv'] = 3.3473000526428223, ['offset'] = 4, ['type'] = 16},
{['lv'] = 6.504799842834473, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 1611.11, ['offset'] = 0, ['type'] = 16},
{['value'] = 1611.15, ['offset'] = 4, ['type'] = 16},
{['value'] = 1611.16, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "open")
end

function 火萤范围关()
local qmnb = {
{['memory'] = neicun},
{['name'] = '火萤范围'},
{['value'] = 1611.1099853515625, ['type'] = 16},
{['lv'] = 1611.1099853515625, ['offset'] = 0, ['type'] = 16},
{['lv'] = 1611.1500244140625, ['offset'] = 4, ['type'] = 16},
{['lv'] = 1611.1600341796875, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 5.846799850463867, ['offset'] = 0, ['type'] = 16},
{['value'] = 3.3473000526428223,['offset'] = 4, ['type'] = 16},
{['value'] = 6.504799842834473, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "close")
end

function 风声范围开()
local qmnb = {
{['memory'] = neicun},
{['name'] = '风声范围'},
{['value'] = 4.8165998458862305, ['type'] = 16},
{['lv'] = 4.8165998458862305, ['offset'] = 0, ['type'] = 16},
{['lv'] = 2.997499942779541, ['offset'] = 4, ['type'] = 16},
{['lv'] = 5.773600101470947, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 1227.21, ['offset'] = 0, ['type'] = 16},
{['value'] = 1227.22, ['offset'] = 4, ['type'] = 16},
{['value'] = 1227.25, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "open")
end

function 风声范围关()
local qmnb = {
{['memory'] = neicun},
{['name'] = '风声范围'},
{['value'] = 1227.2099609375, ['type'] = 16},
{['lv'] = 1227.2099609375, ['offset'] = 0, ['type'] = 16},
{['lv'] = 1227.219970703125,['offset'] = 4, ['type'] = 16},
{['lv'] = 1227.25, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 4.8165998458862305, ['offset'] = 0, ['type'] = 16},
{['value'] = 2.997499942779541, ['offset'] = 4, ['type'] = 16},
{['value'] = 5.773600101470947, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "close")
end

function 大家伙范围开()
local qmnb = {
{['memory'] = neicun},
{['name'] = '大家伙范围'},
{['value'] = 6.202899932861328, ['type'] = 16},
{['lv'] = 6.202899932861328, ['offset'] = 0, ['type'] = 16},
{['lv'] = 7.257599830627441, ['offset'] = 4, ['type'] = 16},
{['lv'] = 11.9798002243042, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 1655.1, ['offset'] = 0, ['type'] = 16},
{['value'] = 1655.2, ['offset'] = 4, ['type'] = 16},
{['value'] = 1655.3, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "open")
end

function 大家伙范围关()
local qmnb = {
{['memory'] = neicun},
{['name'] = '大家伙范围'},
{['value'] = 1655.0999755859375, ['type'] = 16},
{['lv'] = 1655.0999755859375, ['offset'] = 0, ['type'] = 16},
{['lv'] = 1655.199951171875, ['offset'] = 4, ['type'] = 16},
{['lv'] = 1655.300048828125, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 6.202899932861328, ['offset'] = 0, ['type'] = 16},
{['value'] = 7.257599830627441, ['offset'] = 4, ['type'] = 16},
{['value'] = 11.9798002243042, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "close")
end

function 夜莺范围开()
local qmnb = {
{['memory'] = neicun},
{['name'] = '夜莺范围'},
{['value'] = 5.107500076293945, ['type'] = 16},
{['lv'] = 5.107500076293945, ['offset'] = 0, ['type'] = 16},
{['lv'] = 4.912199974060059, ['offset'] = 4, ['type'] = 16},
{['lv'] = 7.106599807739258, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 1127.25, ['offset'] = 0, ['type'] = 16},
{['value'] = 1127.26, ['offset'] = 4, ['type'] = 16},
{['value'] = 1127.27, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "open")
end

function 夜莺范围关()
local qmnb = {
{['memory'] = neicun},
{['name'] = '夜莺范围'},
{['value'] = 1127.25, ['type'] = 16},
{['lv'] = 1127.25, ['offset'] = 0, ['type'] = 16},
{['lv'] = 1127.260009765625, ['offset'] = 4, ['type'] = 16},
{['lv'] = 1127.27001953125, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 5.107500076293945, ['offset'] = 0, ['type'] = 16},
{['value'] = 4.912199974060059, ['offset'] = 4, ['type'] = 16},
{['value'] = 7.106599807739258, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "close")
end

function 网虫范围开()
local qmnb = {
{['memory'] = neicun},
{['name'] = '网虫范围'},
{['value'] = 4.4567999839782715, ['type'] = 16},
{['lv'] = 4.4567999839782715, ['offset'] = 0, ['type'] = 16},
{['lv'] = 4.437600135803223, ['offset'] = 4, ['type'] = 16},
{['lv'] = 9.900099754333496, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 1357.13, ['offset'] = 0, ['type'] = 16},
{['value'] = 1357.14, ['offset'] = 4, ['type'] = 16},
{['value'] = 1357.15, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "open")
end

function 网虫范围关()
local qmnb = {
{['memory'] = neicun},
{['name'] = '网虫范围'},
{['value'] = 1357.1300048828125, ['type'] = 16},
{['lv'] = 1357.1300048828125, ['offset'] = 0, ['type'] = 16},
{['lv'] = 1357.1400146484375, ['offset'] = 4, ['type'] = 16},
{['lv'] = 1357.1500244140625, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 4.4567999839782715, ['offset'] = 0, ['type'] = 16},
{['value'] = 4.437600135803223, ['offset'] = 4, ['type'] = 16},
{['value'] = 9.900099754333496, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "close")
end

function 幻灵范围开()
local qmnb = {
{['memory'] = neicun},
{['name'] = '幻灵范围'},
{['value'] = 5.154799938201904, ['type'] = 16},
{['lv'] = 5.154799938201904, ['offset'] = 0, ['type'] = 16},
{['lv'] = 4.906000137329102, ['offset'] = 4, ['type'] = 16},
{['lv'] = 4.9253997802734375,['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 1571.11, ['offset'] = 0, ['type'] = 16},
{['value'] = 1571.15, ['offset'] = 4, ['type'] = 16},
{['value'] = 1571.17, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "open")
end

function 幻灵范围关()
local qmnb = {
{['memory'] = neicun},
{['name'] = '幻灵范围'},
{['value'] = 1571.1099853515625, ['type'] = 16},
{['lv'] = 1571.1099853515625, ['offset'] = 0, ['type'] = 16},
{['lv'] = 1571.1500244140625, ['offset'] = 4, ['type'] = 16},
{['lv'] = 1571.1700439453125, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 5.154799938201904, ['offset'] = 0, ['type'] = 16},
{['value'] = 4.906000137329102, ['offset'] = 4, ['type'] = 16},
{['value'] = 4.9253997802734375,['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "close")
end

function 铁驭范围开()
local qmnb = {
{['memory'] = neicun},
{['name'] = '铁驭范围'},
{['value'] = 5.855299949645996, ['type'] = 16},
{['lv'] = 5.162399768829346, ['offset'] = 4, ['type'] = 16},
{['lv'] = 5.232500076293945, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 255.855299949645996, ['offset'] = 0, ['type'] = 16},
{['value'] = 255.162399768829346, ['offset'] = 4, ['type'] = 16},
{['value'] = 255.232500076293945, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "open")
end

function 铁驭范围关()
local qmnb = {
{['memory'] = neicun},
{['name'] = '铁驭范围'},
{['value'] = 255.855299949645996, ['type'] = 16},
{['lv'] = 255.162399768829346, ['offset'] = 4, ['type'] = 16},
{['lv'] = 255.232500076293945, ['offset'] = 8, ['type'] = 16},
}
local qmxg = {
{['value'] = 5.855299949645996, ['offset'] = 0, ['type'] = 16},
{['value'] = 5.162399768829346, ['offset'] = 4, ['type'] = 16},
{['value'] = 5.232500076293945, ['offset'] = 8, ['type'] = 16},
}
xqmnb2(qmnb, qmxg, "close")
end

function 一键开启核心范围执行()
HK()
fw1 = true
local count = 0
local gd = gg.prompt({'自定义循环次数'},{[1]='1'})
local max_count = tonumber(gd[1])
if max_count and max_count > 0 then
while count < max_count do
萌新范围开()
铠鼠范围开()
火萤范围开()
风声范围开()
大家伙范围开()
夜莺范围开()
网虫范围开()
幻灵范围开()
铁驭范围开()
count = count + 1
end
fw1 = false
else
提示("请输入一个有效的正整数作为循环次数")
end
end

function 一键关闭核心范围执行()
HK()
fw1 = true
local count = 0
local gd = gg.prompt({'自定义循环次数'},{[1]='1'})
local max_count = tonumber(gd[1])
if max_count and max_count > 0 then
while count < max_count do
萌新范围关()
铠鼠范围关()
火萤范围关()
风声范围关()
大家伙范围关()
夜莺范围关()
网虫范围关()
幻灵范围关()
铁驭范围关()
count = count + 1
end
fw1 = false
else
提示("请输入一个有效的正整数作为循环次数")
end
end

function 子弹无伤开()
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("3,773,846,507,450,360,164", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(114514)
gg.editAll("3,773,846,507,450,360,200", gg.TYPE_QWORD)
提示("子弹无伤已开启")
end

function 子弹无伤关()
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("3,773,846,507,450,360,200", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(114514)
gg.editAll("3,773,846,507,450,360,164", gg.TYPE_QWORD)
提示("子弹无伤已关闭")
end

function 子弹打盾无伤开()
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("7,094,703,641,771,406,433", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(114514)
gg.editAll("7,094,703,641,771,406,500", gg.TYPE_QWORD)
提示("子弹打盾无伤已开启")
end

function 子弹打盾无伤关()
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("7,094,703,641,771,406,500", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(114514)
gg.editAll("7,094,703,641,771,406,433", gg.TYPE_QWORD)
提示("子弹打盾无伤已关闭")
end

function LSQ_pointer(search, write)
    local region_start, region_end
    if type(search[5]) == "number" and type(search[6]) == "number" then
        region_start = search[5]
        region_end = search[6]
    else
        region_start = 0
        region_end = -1
    end

    gg.clearResults()
    gg.setRanges(search[1][3])
    gg.searchNumber(search[1][1], search[1][2], false, gg.SIGN_EQUAL, region_start, region_end)
    gg.refineNumber(search[1][1], search[1][2], false, gg.SIGN_EQUAL, region_start, region_end)

    local count = gg.getResultsCount()
    if count == 0 then
        提示("没有搜索到指针数据")
        return false
    end

    local results = gg.getResults(count)
    gg.clearResults()

    for i = 2, #search do
        local offset = search[i][2]
        local flags = search[i][3]
        local target_value = search[i][1]

        local addr_list = {}
        for k, v in ipairs(results) do
            addr_list[#addr_list + 1] = {
                address = v.address + offset,
                flags = flags
            }
        end

        local values = gg.getValues(addr_list)
        local valid_results = {}
        for k, v in ipairs(values) do
            if v.value == target_value then
                valid_results[#valid_results + 1] = results[k]
            end
        end
        results = valid_results

        if #results == 0 then
            提示("未找到偏移数据")
            return false
        end
    end

    local modify_list = { {}, {} }
    for _, addr in ipairs(results) do
        for _, mod in ipairs(write) do
            local item = {
                address = addr.address + mod[2],
                flags = mod[3],
                value = mod[1],
                freeze = mod[4] and true or false
            }
            if item.freeze then
                modify_list[2][#modify_list[2] + 1] = item
            else
                modify_list[1][#modify_list[1] + 1] = item
            end
        end
    end

    if #modify_list[2] > 0 then
        gg.addListItems(modify_list[2])
    end
    if #modify_list[1] > 0 then
        gg.setValues(modify_list[1])
    end

    local total_modified = #modify_list[1] + #modify_list[2]
    提示("共修改 " .. total_modified .. " 个数据")
    return true
end

function 正常秒杀范围优化二进制()
    fw1 = true
    local search_tbl = {
        {4652218415073722371, 32, 4, "二进制秒杀"},
        {236227496247808,-72, 32},
        {2199026335744,-60, 32},
        {236227496247808,-56, 32},
        {3080192,-44, 32},
        {0,-40, 32},
        {0,-36, 32},
        {4575657221408423936,-32, 32},
        {1065353216,-28, 32},
        {0,-24, 32},
        {0,-20, 32},
        {4489188105126936576,-16, 32},
        {4652218415073722371,0,32},
    }
    local write_tbl = {
        {9, 4, 16, fwsfdj},
        {999999999, 8, 16, fwsfdj},
        {999999999, 12, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 正常秒杀范围二进制()
    fw1 = true
    local search_tbl = {
        {7.707281683632926E-41, 16, neicun},
        {0.0, 12, 16},
        {0.0, 16, 16},
        {0.0, 20, 16},
        {1.0, 24, 16},
        {0.0, 28, 16},
        {0.0, 32, 16},
        {0.0, 36, 16},
        {4.5, 60, 16},
        {4.5, 64, 16}
    }
    local write_tbl = {
        {回拉值[1], 64, 16, fwsfdj},
        {999999999, 60, 16, fwsfdj},
        {999999999, 56, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 不挡秒杀范围新二进制()
    fw1 = true
    local search_tbl = {
        {7.707281683632926E-41, 16, neicun},
        {7.1746481373430634E-43, 4, 16},
        {4.316268319425587E-39, 8, 16},
        {0.0, 12, 16},
        {0.0, 16, 16},
        {0.0, 20, 16},
        {1.0, 24, 16},
        {0.0, 28, 16},
        {0.0, 32, 16},
        {0.0, 36, 16},
        {0.19999998807907104, 40, 16},
        {4.203895392974451E-45, 52, 16},
        {4.5, 64, 16}
    }
    local write_tbl = {
        {回拉值[1], 64, 16, fwsfdj},
        {999999999, 60, 16, fwsfdj},
        {999999999, 56, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 队友不挡高伤范围二进制()
    fw1 = true
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        local search_tbl1 = {
            {7.707281683632926E-41, 16, neicun},
            {7.1746481373430634E-43, 4, 16},
            {7.1746481373430634E-43, 20, 16},
            {0.0, 36, 16},
            {1.0, 40, 16},
            {4.5, 76, 16}
        }
        local write_tbl1 = {
            {回拉值[1], 64, 16, fwsfdj},
            {999999999, 72, 16, fwsfdj},
            {0, 76, 16, fwsfdj},
            {999999999, 68, 16, fwsfdj}
        }
        LSQ_pointer(search_tbl1, write_tbl1)
        gg.sleep(100)
        local search_tbl2 = {
            {7.1746481373430634E-43, 16, neicun},
            {7.1746481373430634E-43, 20, 16},
            {0.0, 36, 16},
            {1.0, 40, 16},
            {4.5, 76, 16}
        }
        local write_tbl2 = {
            {999999999, 72, 16, fwsfdj},
            {0, 76, 16, fwsfdj},
            {999999999, 68, 16, fwsfdj}
        }
        LSQ_pointer(search_tbl2, write_tbl2)
        gg.sleep(100)
        local search_tbl3 = {
            {7.707281683632926E-41, 16, neicun},
            {7.1746481373430634E-43, 4, 16},
            {4.316268319425587E-39, 8, 16},
            {0.0, 12, 16},
            {0.0, 16, 16},
            {0.0, 20, 16},
            {1.0, 24, 16},
            {0.0, 28, 16},
            {0.0, 32, 16},
            {0.0, 36, 16},
            {0.19999998807907104, 40, 16},
            {4.203895392974451E-45, 52, 16},
            {4.5, 64, 16}
        }
        local write_tbl3 = {
            {回拉值[1], 64, 16, fwsfdj},
            {999999999, 60, 16, fwsfdj},
            {999999999, 56, 16, fwsfdj}
        }
        LSQ_pointer(search_tbl3, write_tbl3)
    end
end):start()
end

function 执行迅速秒杀范围新二进制()
    fw1 = true
    local search_tbl = {
        {7.707281683632926E-41, 16, neicun},
        {0.0, 12, 16},
        {0.0, 16, 16},
        {0.0, 20, 16},
        {1.0, 24, 16},
        {0.0, 28, 16},
        {0.0, 32, 16},
        {0.0, 36, 16},
        {0.19999998807907104, 40, 16},
        {4.203895392974451E-45, 52, 16},
        {4.5, 64, 16}
    }
    local write_tbl = {
        {回拉值[1], 64, 16, fwsfdj},
        {999999999, 60, 16, fwsfdj},
        {999999999, 56, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 频率优化秒杀范围旧二进制()
    fw1 = true
    local search_tbl = {
        {7.707281683632926E-41, 16, neicun},
        {1.0, 24, 16},
        {0.0, 28, 16},
        {0.0, 32, 16},
        {0.0, 36, 16},
        {4.5, 60, 16}
    }
    local write_tbl = {
        {回拉值[1], 64, 16, fwsfdj},
        {999999999, 60, 16, fwsfdj},
        {999999999, 56, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 频率优化秒杀范围新二进制()
    fw1 = true
    local search_tbl = {
        {7.707281683632926E-41, 16, neicun},
        {1.0, 24, 16},
        {0.0, 36, 16},
        {4.5, 60, 16}
    }
    local write_tbl = {
        {回拉值[1], 64, 16, fwsfdj},
        {999999999, 60, 16, fwsfdj},
        {999999999, 56, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 极小秒杀范围二进制()
    local input = gg.prompt({'自定义范围'}, {[1]='100'})
    if not input then return end
    local gd = tonumber(input[1])
    if not gd then
        gd = 100
        提示("输入无效，使用默认值100")
    end
    fw1 = true
    local search_tbl = {
        {7.707281683632926E-41, 16, neicun},
        {1.0, 24, 16},
        {0.0, 28, 16},
        {0.0, 32, 16},
        {0.0, 36, 16},
        {4.5, 60, 16}
    }
    local write_tbl = {
        {回拉值[1], 64, 16, fwsfdj},
        {gd, 60, 16, fwsfdj},
        {gd, 56, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 不秒杀范围二进制()
    fw1 = true
    local search_tbl = {
        {4.5, 16, neicun},
        {0.19999998807907104, -20, 16},
        {4.5, 0, 16}
    }
    local write_tbl = {
        {999999999, 0, 16, fwsfdj},
        {999999999, -4, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 自定义不秒杀范围二进制()
    local input = gg.prompt({'自定义范围'}, {[1]='100'})
    local gd = tonumber(input and input[1]) or 100
    if not gd then 提示("输入无效，使用默认值100") end
    fw1 = true
    local search_tbl = {
        {4.5, 16, neicun},
        {0.19999998807907104, -20, 16},
        {4.5, 0, 16}
    }
    local write_tbl = {
        {gd, 0, 16, fwsfdj},
        {gd, -4, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 范围穿甲弹二进制()
    fw1 = true
    local search_tbl = {
        {7.707281683632926E-41, 16, neicun},
        {0.0, 12, 16},
        {0.0, 16, 16},
        {0.0, 20, 16},
        {1.0, 24, 16},
        {0.0, 28, 16},
        {0.0, 32, 16},
        {0.0, 36, 16},
        {4.5, 60, 16},
        {4.5, 64, 16}
    }
    local write_tbl = {
        {100, 60, 16, fwsfdj},
        {100, 56, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 高伤二进制()
    fw1 = true
    local search_tbl = {
        {1083179008, 4, neicun},
        {1045220556, -20, 4},
        {1083179008, 0, 4}
    }
    local write_tbl = {
        {24552, 0, 16, fwsfdj},
        {0, 4, 16, fwsfdj},
        {95452, -4, 16, fwsfdj}
    }
luajava.newThread(function()
    while fw1 do
        gg.sleep(100)
        LSQ_pointer(search_tbl, write_tbl)
    end
end):start()
end

function 正常秒杀范围优化()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(4652218415073722371,32,4)
py1(236227496247808,32,-72)
py1(2199026335744,32,-60)
py1(236227496247808,32,-56)
py1(3080192,32,-44)
py1(0,32,-40)
py1(0,32,-36)
py1(4575657221408423936,32,-32)
py1(1065353216,32,-28)
py1(0,32,-24)
py1(0,32,-20)
py1(4489188105126936576,32,-16)
py1(4652218415073722371,32,0)
xg1(4.5,16,4,fwsfdj)
xg1(999999999,16,8,fwsfdj)
xg1(999999999,16,12,fwsfdj)
end
end):start()
end

function 正常秒杀范围()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,60)
py1(4.5,16,64)
xg1(回拉值[1],16,64,fwsfdj)
xg1(999999999,16,60,fwsfdj)
xg1(999999999,16,56,fwsfdj)
end
end):start()
end

function 不挡秒杀范围新()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(7.707281683632926E-41,16,neicun)
py1(7.1746481373430634E-43,16,4)
py1(4.316268319425587E-39,16,8)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(0.19999998807907104,16,40)
py1(4.203895392974451E-45,16,52)
py1(4.5,16,64)
xg1(回拉值[1],16,64,fwsfdj)
xg1(999999999,16,60,fwsfdj)
xg1(999999999,16,56,fwsfdj)
end
end):start()
end

function 队友不挡高伤范围()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(7.707281683632926E-41,16,neicun)
py1(7.1746481373430634E-43,16,4)
py1(7.1746481373430634E-43,16,20)
py1(0.0,16,36)
py1(1.0,16,40)
py1(4.5,16,76)
xg1(回拉值[1],16,64,fwsfdj)
xg1(999999999,16,72,fwsfdj)
xg1(0,16,76,fwsfdj)
xg1(999999999,16,68,fwsfdj)
gg.sleep(100)
search(7.1746481373430634E-43,16,neicun)
py1(7.1746481373430634E-43,16,20)
py1(0.0,16,36)
py1(1.0,16,40)
py1(4.5,16,76)
xg1(999999999,16,72,fwsfdj)
xg1(0,16,76,fwsfdj)
xg1(999999999,16,68,fwsfdj)
gg.sleep(100)
search(7.707281683632926E-41,16,neicun)
py1(7.1746481373430634E-43,16,4)
py1(4.316268319425587E-39,16,8)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(0.19999998807907104,16,40)
py1(4.203895392974451E-45,16,52)
py1(4.5,16,64)
xg1(回拉值[1],16,64,fwsfdj)
xg1(999999999,16,60,fwsfdj)
xg1(999999999,16,56,fwsfdj)
end
end):start()
end

function 执行迅速秒杀范围新()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(0.19999998807907104,16,40)
py1(4.203895392974451E-45,16,52)
py1(4.5,16,64)
xg1(回拉值[1],16,64,fwsfdj)
xg1(999999999,16,60,fwsfdj)
xg1(999999999,16,56,fwsfdj)
end
end):start()
end

function 频率优化秒杀范围旧()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(7.707281683632926E-41,16,neicun)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,60)
xg1(回拉值[1],16,64,fwsfdj)
xg1(999999999,16,60,fwsfdj)
xg1(999999999,16,56,fwsfdj)
end
end):start()
end

function 频率优化秒杀范围新()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(7.707281683632926E-41,16,neicun)
py1(1.0,16,24)
py1(0.0,16,36)
py1(4.5,16,60)
xg1(回拉值[1],16,64,fwsfdj)
xg1(999999999,16,60,fwsfdj)
xg1(999999999,16,56,fwsfdj)
end
end):start()
end

function 极小秒杀范围()
local input=gg.prompt({'自定义范围'}, {[1]='100'})
if not input then return end
local gd=tonumber(input[1])
if not gd then gd=100 提示("输入无效，使用默认值100") end
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(7.707281683632926E-41,16,neicun)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,60)
xg1(回拉值[1],16,64,fwsfdj)
xg1(gd,16,60,fwsfdj)
xg1(gd,16,56,fwsfdj)
end
end):start()
end

function 子弹穿墙开()
search(0.7070000171661377,16,16)
py1(0.7070000171661377,16,4)
xg3(0,16,-128,true,true,"(自定义子弹穿墙)")
xg4(0,16,-124,true)
xg4(0,16,-136,true)
end

function 子弹穿墙关()
search(0.7070000171661377,16,16)
py1(0.7070000171661377,16,4)
xg1(2,16,-128,false)
xg1(2,16,-124,false)
xg1(2,16,-136,false)
end

function 不秒杀范围()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(4.5,16,neicun)
py1(0.19999998807907104,16,-20)
py1(4.5,16,0)
xg1(999999999,16,0,fwsfdj)
xg1(999999999,16,-4,fwsfdj)
end
end):start()
end

function 自定义不秒杀范围()
local input=gg.prompt({'自定义范围'}, {[1]='100'})
local gd=tonumber(input and input[1]) or 100
if not gd then 提示("输入无效，使用默认值100") end
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(4.5,16,neicun)
py1(0.19999998807907104,16,-20)
py1(4.5,16,0)
xg1(gd,16,0,fwsfdj)
xg1(gd,16,-4,fwsfdj)
end
end):start()
end

function 范围穿甲弹()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,60)
py1(4.5,16,64)
xg1(100,16,60,fwsfdj)
xg1(100,16,56,fwsfdj)
end
end):start()
end

function 自瞄炮范围()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("4.5", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount()==0 then
else
gg.searchNumber("4.5;4.5", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("295", gg.TYPE_FLOAT)
gg.clearResults()
end
end
end):start()
end

function 高伤()
fw1=true
luajava.newThread(function()
while fw1 do
gg.sleep(100)
search(1083179008,4,neicun)
py1(1045220556,4,-20)
py1(1083179008,4,0)
xg1(24552,16,0,fwsfdj)
xg1(0,16,4,fwsfdj)
xg1(95452,16,-4,fwsfdj)
end
end):start()
end


function fanglog()
gg.clearResults()
gg.setRanges(100)
gg.searchNumber(":logs.yiworld.com", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber(":logs.yiworld.com", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0", gg.TYPE_BYTE)
gg.clearResults()
gg.setRanges(100)
gg.searchNumber(":acsdk.gameyw.netease.com", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber(":acsdk.gameyw.netease.com", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0", gg.TYPE_BYTE)
end

function fangduanko()
gg.clearResults()
gg.setRanges(100)
gg.searchNumber(":fp.", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber(":fp.", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0", gg.TYPE_BYTE)
gg.clearResults()
gg.setRanges(100)
gg.searchNumber(":acsdk.gameyw.netease.com", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber(":acsdk.gameyw.netease.com", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0", gg.TYPE_BYTE)
end

function guojiance()
gg.setRanges(neicun)
gg.clearResults()
gg.searchNumber(":635959318", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(114514)
gg.editAll("0", gg.TYPE_BYTE)
gg.clearResults()
gg.clearResults()
gg.setRanges(100)
gg.searchNumber(":wxzcin", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber(":wxzcin", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0", gg.TYPE_BYTE)
end

function fangjiance()
local t={"libclient.so:bss","Cb"}
local tt={3616548,204,128}
local ttt=S_Pointer(t,tt)
gg.addListItems({{address=ttt,flags=4,value=7955819,freeze=true}})

local t={"libclient.so:bss","Cb"}
local tt={3616548,204,164}
local ttt=S_Pointer(t,tt)
gg.addListItems({{address=ttt,flags=4,value=7955819,freeze=true}})

local t={"libclient.so:bss","Cb"}
local tt={3616548,204,132}
local ttt=S_Pointer(t,tt)
gg.addListItems({{address=ttt,flags=4,value=7955819,freeze=true}})

local t={"libclient.so:bss","Cb"}
local tt={3616548,204,168}
local ttt=S_Pointer(t,tt)
gg.addListItems({{address=ttt,flags=4,value=7955819,freeze=true}})

local t={"libclient.so:bss","Cb"}
local tt={3616548,204,136}
local ttt=S_Pointer(t,tt)
gg.addListItems({{address=ttt,flags=4,value=7955819,freeze=true}})

local t={"libclient.so:bss","Cb"}
local tt={3616548,204,124}
local ttt=S_Pointer(t,tt)
gg.addListItems({{address=ttt,flags=4,value=7955819,freeze=true}})

local t={"libclient.so","Cd"}
local tt={3529224,36}
local ttt=S_Pointer(t,tt)
gg.addListItems({{address=ttt,flags=4,value=1747873614,freeze=true}})

local t={"libclient.so","Cd"}
local tt={3529224,32}
local ttt=S_Pointer(t,tt)
gg.addListItems({{address=ttt,flags=4,value=1747873614,freeze=true}})

local t={"libclient.so","Cd"}
local tt={3529224,40}
local ttt=S_Pointer(t,tt)
gg.addListItems({{address=ttt,flags=4,value=1747873614,freeze=true}})
end












创建开关页面("秒杀范围",
function()
HK()
提示('范围已开启')
if msfwqh == false then
频率优化秒杀范围旧()
else
频率优化秒杀范围旧二进制()
end
end,
function()
fw1=false
提示("已停止所有范围循环")
end
)

创建开关页面("秒杀小范围",
function()
HK()
提示('范围已开启')
if msfwqh == false then
极小秒杀范围()
else
极小秒杀范围二进制()
end
end,
function()
fw1=false
提示("已停止所有范围循环")
end
)

创建开关页面("车体范围",
function()
HK()
提示('范围已开启')
if msfwqh == false then
不秒杀范围()
else
不秒杀范围二进制()
end
end,
function()
fw1=false
提示("已停止所有范围循环")
end
)

创建开关页面("车体小范围",
function()
HK()
提示('范围已开启')
if msfwqh == false then
自定义不秒杀范围()
else
自定义不秒杀范围二进制()
end
end,
function()
fw1=false
提示("已停止所有范围循环")
end
)

创建开关页面("后坐力(上抬)",
function()
HK()
search(1077149696,4,neicun)
py1(1071644672,4,-96)
py1(1202590843,4,-52)
xg3(0,64,236,true,true,"(自定义后坐力[上抬])")
end,
function()
search(1077149696,4,neicun)
py1(1071644672,4,-96)
py1(1202590843,4,-52)
xg1(100,64,236,false)
end
)

创建开关页面("后坐力",
function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(nil,16,96,true,"(自定义后坐)")
end,
function()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(0.007352941203862429,16,96,false)
end
)

创建开关页面("机枪后坐",
function()
HK()
gg.clearResults()
local info = gg.getTargetInfo()
if info.x64 then
提示("64位机枪后坐力正在开启")
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg3(nil,16,24,false,"(自定义机枪后坐)")
else
提示("32位机枪后坐力正在开启")
gg.refineNumber("89,128.9609375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local finalResults = gg.getResults(1000)
local currentValue = finalResults[1] and finalResults[1].value or "未知"
local pt = "当前值:" .. tostring(currentValue) .. " | 输入新值(推荐:-9)"
local i = gg.prompt({pt, "记住"}, {"-9", false}, {"number", "checkbox"})
if not i then
提示("已取消")
gg.clearResults()
return
end
local inputValue = i[1]
if not inputValue or not inputValue:match("^%-?%d+%.?%d*$") then
提示("输入错误,已取消")
gg.clearResults()
return
end
for j, v in ipairs(finalResults) do
v.address = v.address + 0x24
end
gg.loadResults(finalResults)
gg.editAll(inputValue, gg.TYPE_FLOAT)
提示("共修改 " .. #finalResults .. " 个数据 → " .. inputValue)
gg.clearResults()
end
end,
function()
HK()
gg.clearResults()
local info = gg.getTargetInfo()
if info.x64 then
提示("64位机枪后坐力正在关闭")
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg1(3.841796875,16,24,false)
else
提示("32位机枪后坐力正在关闭")
gg.searchNumber("1.9375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(1000)
for i, v in ipairs(results) do
    v.address = v.address + 0x14
end
gg.loadResults(results)
gg.refineNumber("1.12103877e-44", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results2 = gg.getResults(1000)
for i, v in ipairs(results2) do
    v.address = v.address + 0x18
end
gg.loadResults(results2)
gg.refineNumber("89,128.9609375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results3 = gg.getResults(1000)
for i, v in ipairs(results3) do
    v.address = v.address + 0x24
end
gg.loadResults(results3)
gg.editAll("3.841796875", gg.TYPE_FLOAT)
提示("已关闭反向后坐力")
gg.clearResults()
end
end
)

创建开关页面("离线",
function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(-10,4,92,true)
xg1(-10,4,84,true)
end,
function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(0,4,92,false)
xg1(0,4,84,false)
end
)

创建开关页面("离线Pro",
function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(-25,11,100,true)
end,
function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(0,11,100,false)
end
)

创建开关页面("机枪离线",
function()
HK()
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg3(-1,4,24,false,true,"(机枪离线)")
end,
function()
HK()
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg1(1081466880,4,24,false)
end
)

创建开关页面("全局加速",
function()
HK()
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("500", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("500",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("-99999999114514", FLOAT)
提示("开启成功")
gg.clearResults()
end
end,
function()
HK()
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("500", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
else
gg.searchNumber("500",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("-99999999114514", FLOAT)
gg.clearResults()
end
gg.clearResults()
gg.searchNumber("-99999999114514",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("500", FLOAT)
提示("恢复")
gg.clearResults()
end
)

创建开关页面("弱网",
function()
HK()
弱网()
end,
function()
HK()
恢复弱网()
end
)

创建按钮页面("初始快速弱网",
function() 
HK()
初始化弱网()
end
)

创建开关页面("快速弱网",
function()
HK()
快速弱网()
end,
function()
HK()
恢复快速弱网()
end
)

创建开关页面("停止发包",
function()
HK()
停止发包开()
end,
function()
HK()
停止发包关()
end
)

创建开关页面("破隐",
function()
HK()
破隐()
end,
function()
HK()
恢复以上功能()
end
)

创建开关页面("视角",
function()
HK()
if SetSjWithOffset(-140) then
xg3(nil, 16, 0, true, "(自定义视角)")
end
end,
function()
HK()
local any = false
if SetSjWithOffset(-140) then
xg1(0, 16, 0, false)
any = true
end
if SetSjWithOffset(-92) then
xg1(1, 16, 0, false)
any = true
end
if SetSjWithOffset(-40) then
xg1(1, 16, 0, false)
any = true
end
if any then
_VisionBase = nil
_VisionOrig = {}
提示("视角已恢复，缓存已清除")
return
end
search("-1.2566370964050293", 16, neicun)
xg1(0, 16, -140, true)
xg1(1, 16, -92, true)
xg1(1, 16, -40, true)
gg.sleep(100)
xg1(0, 16, -140, false)
xg1(1, 16, -92, false)
xg1(1, 16, -40, false)
end
)

创建开关页面("视角[广角]",
function()
HK()
if SetSjWithOffset(-92) then
xg3(nil, 16, 0, true, "(自定义视角[广角])")
end
end,
function()
HK()
local any = false
if SetSjWithOffset(-140) then
xg1(0, 16, 0, false)
any = true
end
if SetSjWithOffset(-92) then
xg1(1, 16, 0, false)
any = true
end
if SetSjWithOffset(-40) then
xg1(1, 16, 0, false)
any = true
end
if any then
_VisionBase = nil
_VisionOrig = {}
提示("视角已恢复，缓存已清除")
return
end
search("-1.2566370964050293", 16, neicun)
xg1(0, 16, -140, true)
xg1(1, 16, -92, true)
xg1(1, 16, -40, true)
gg.sleep(100)
xg1(0, 16, -140, false)
xg1(1, 16, -92, false)
xg1(1, 16, -40, false)
end
)

创建开关页面("视角[旧]",
function()
HK()
if SetSjWithOffset(-40) then
xg3(nil, 16, 0, true, "(自定义视角(旧))")
end
end,
function()
HK()
local any = false
if SetSjWithOffset(-140) then
xg1(0, 16, 0, false)
any = true
end
if SetSjWithOffset(-92) then
xg1(1, 16, 0, false)
any = true
end
if SetSjWithOffset(-40) then
xg1(1, 16, 0, false)
any = true
end
if any then
_VisionBase = nil
_VisionOrig = {}
提示("视角已恢复，缓存已清除")
return
end
search("-1.2566370964050293", 16, neicun)
xg1(0, 16, -140, true)
xg1(1, 16, -92, true)
xg1(1, 16, -40, true)
gg.sleep(100)
xg1(0, 16, -140, false)
xg1(1, 16, -92, false)
xg1(1, 16, -40, false)
end
)

创建开关页面("大力神加速",
function()
HK()
大力神加速开()
end,
function()
HK()
大力神加速关()
end
)

创建开关页面("核心加速",
function()
HK()
核心加速开()
xg1(999999999999999999999,16,140,false)
end,
function()
HK()
核心加速关()
end
)

创建开关页面("核心防水",
function()
HK()
核心防水开()
end,
function()
HK()
核心防水关()
end
)

创建开关页面("防闪光弹",
function()
HK()
防闪光弹开()
end,
function()
HK()
防闪光弹关()
end
)

创建开关页面("删除地图",
function()
HK()
删除地图()
end,
function()
HK()
恢复删除地图()
end
)

创建按钮页面("应急",
function() 
HK()
提示("应急")
recordCount = recordCount + 1
if recordCount <= maxRecordCount then
-- 正常记录坐标
clearLastRecord()
startRecording()
else
-- 第三次点击，清除上次坐标，并重新开始
clearLastRecord()
recordCount = 1
startRecording()
end
xg1(0,16,-4,true)
xg1(2000,16,-8,true)
xg1(0,16,-12,true)
gg.sleep(1200)
xg1(0,16,-4,false)
xg1(2000,16,-8,false)
xg1(0,16,-12,false)
end
)

创建开关页面("不倒翁",
function()
HK()
不倒翁()
end,
function()
HK()
不倒翁关()
end
)























----UI配置区
xfcpic = "/storage/emulated/0/长安/图片/arlogo"--悬浮条前的图标
stitle = "R.G"--图标后的图片
stab = {
	"战斗类",
	"坐标类",
	"娱乐类",
	"其它类",
	"演技类",	
	"3 2 位",
	"灵体类",
	"设置类",
}



---check内容数量不限，可随意扩充
RG.menu(
{
{--1
RG.text("RunawaG","#FAEBD7","17sp"),






RG.check({"适配64位重装",}),
RG.button("检测进程位数",
function() enqueueTask(function()

HK()
 
local info = gg.getTargetInfo()
if info.x64 then
提示("检测为64位")
else
提示("检测为32位")
end
end) end
),
RG.button("检测进程",
function() enqueueTask(function()

HK()
 
function xxhq()
local time = os.date("%Y年%m月%d日 %H:%M:%S", os.time())
local info = gg.getTargetInfo()
local processName = info and info['activities'] and info['activities'][1]['label'] or "未知进程名称"
local packageName = gg.getTargetPackage() or "未知包名"
local appDataPath1 = info and info['dataDir'] or "未知数据路径1"
local appDataPath2 = "/data/data/" .. packageName .. "/files"

local xtxx = "当前时间: " .. time ..
 "\n进程名称: " .. processName ..
 "\n进程包名: " .. packageName ..
 "\n数据路径1: \n" .. appDataPath1 ..
 "\n数据路径2: \n" .. appDataPath2


local channel = 识别渠道服(packageName)
xtxx = xtxx .. "\n渠道服: " .. channel

local info = gg.getTargetInfo()
local bitType = info and info.x64 and "64位" or "32位"
xtxx = xtxx .. "\n进程位数: " .. bitType

local memorySetting
gg.clearResults()
gg.setRanges(4)
gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
gg.clearResults()
gg.setRanges(-2080896)
gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
memorySetting = gg.getResultCount() == 0 and "A内存" or "O内存"
else
memorySetting = "Ca内存"
end

xtxx = xtxx .. "\n内存设置: " .. memorySetting
gg.alert(xtxx)
gg.clearResults()
end


function 识别渠道服(packageName)

local channels = {
["com.netease.wxzc"] = "网易官服", 
["com.tencent.tmgp.eyou.zzsz"] = "虫虫助手", 
["com.netease.wxzc.bazhang"] = "7723", 
["com.netease.wxzc.ab"] = "应用宝", 
["com.netease.wxzc.4399"] = "4399", 
["com.ghzs"] = "光环助手", 
["com.vivo.xiangjiazhan"] = "VIVO手机应用商店",
["com.oppo.xiangjiazhan"] = "OPPO手机应用商店",
["com.huawei.xiangjiazhan"] = "华为手机应用商店",
["com.meizu.mstore"] = "魅族渠道服",
["com.qihoo.appstore"] = "360渠道服", 
["com.netease.wxzc.qihoo"] = "360渠道服" 
}
return channels[packageName] or "未知渠道服"
end

xxhq()
end) end
),
RG.button('显示附近人数',
function() enqueueTask(function()
HK()
rssearch(17039361,4,neicun)
rspy1(16777215,4,-36)
rspy1(1065353216,4,16)
rsxg1(999,16,-8,false)
end) end),
RG.switch("                            循环显示附近人数",
function() luajava.newThread(function()
HK()
function zhuanhuan_yanse(input_color)
    if not input_color or input_color == "" then
        return "#ff0000"
    end
    
    input_color = tostring(input_color):gsub("%s+", "")
    
    local function is_valid_hex(color)
        color = color:gsub("#", "")
        if #color == 3 then
            return color:match("^[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]$") ~= nil
        elseif #color == 6 then
            return color:match("^[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]$") ~= nil
        end
        return false
    end
    
    local function format_color(color)
        color = color:gsub("#", "")
        if #color == 3 then
            color = color:sub(1,1)..color:sub(1,1)..
                    color:sub(2,2)..color:sub(2,2)..
                    color:sub(3,3)..color:sub(3,3)
        end
        return "#" .. color:lower()
    end
    
    if is_valid_hex(input_color) then
        return format_color(input_color)
    else
        return nil
    end
end

function jianyan_shuzi(value, default)
    local num = tonumber(value)
    if not num then
        return default
    end
    return math.floor(num)
end

local input = gg.prompt({
    '颜色代码 (例如: ff0000, #ff0000, f00)',
    'X坐标 (输入数字)',
    'Y坐标 (输入数字)'
}, {
    '#ff0000',
    '200',
    '200'
}, {
    'text',
    'text',
    'text'
})

if input then
    local wenziyanse = zhuanhuan_yanse(input[1])
    while not wenziyanse do
        提示('颜色格式错误！\n\n正确格式示例：\n#ff0000\nff0000\n#f00\nf00')
        local retry = gg.prompt({
            '颜色代码 (例如: ff0000, #ff0000, f00)'
        }, {
            input[1]
        }, {
            'text'
        })
        if not retry then
            提示('已取消操作')
            return
        end
        wenziyanse = zhuanhuan_yanse(retry[1])
    end
    
    local weizhi_x = jianyan_shuzi(input[2], 200)
    if not tonumber(input[2]) then
        提示('X坐标不是有效数字，已使用默认值: 200')
    end
    
    local weizhi_y = jianyan_shuzi(input[3], 200)
    if not tonumber(input[3]) then
        提示('Y坐标不是有效数字，已使用默认值: 200')
    end
    
    draw.setColor(wenziyanse)
    hzwjrs = draw.text('', weizhi_x, weizhi_y)
    
    提示('文本创建成功\n' ..
             '颜色: ' .. wenziyanse .. '\n' ..
             '位置: ' .. weizhi_x .. ', ' .. weizhi_y)
else
    提示('已取消操作')
end
提示('开始循环显示附近人数')
fw1 = true
while fw1 == true do 
gg.sleep(1)
rssearch(17039361,4,neicun)
rspy1(16777215,4,-36)
rspy1(1065353216,4,16)
rsxg2(999,16,-8,false)
end
end):start() end,
function()
fw1=false
gg.sleep(2000)
draw.updateDraw(hzwjrs)
提示("已停止循环显示")
end
),
RG.button('初始化帧率地址',
function() enqueueTask(function()
HK()
if savedZhenlvAddr then
gg.setValues({{address = savedZhenlvAddr, flags = 4, value = 60}})
gg.removeListItems({{address = savedZhenlvAddr, flags = 4}})
savedZhenlvAddr = nil
end
search("60D;0F;0F;1F;1F;1F::21",4,neicun)
py1(60,4,0)
if sj and #sj > 0 then
savedZhenlvAddr = sj[1].address
提示("帧率地址初始化成功")
else
提示("帧率地址初始化失败")
end
end) end),
RG.button('强制90帧',
function() enqueueTask(function()
HK()
local info = gg.getTargetInfo()
if info.x64 then
if savedZhenlvAddr then
local old_sj = sj
sj = {{address = savedZhenlvAddr, flags = 4, value = 0}}
xg1(90,4,0,true)
sj = old_sj
else
提示("请先初始化帧率地址")
end
else
local t = {"libclient.so:bss", "Cb"}
local tt = {0xFC, 0xC}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 90}})
end
end) end),
RG.button('强制120帧',
function() enqueueTask(function()
HK()
local info = gg.getTargetInfo()
if info.x64 then
if savedZhenlvAddr then
local old_sj = sj
sj = {{address = savedZhenlvAddr, flags = 4, value = 0}}
xg1(120,4,0,true)
sj = old_sj
else
提示("请先初始化帧率地址")
end
else
local t = {"libclient.so:bss", "Cb"}
local tt = {0xFC, 0xC}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 120}})
end
end) end),
RG.button('强制自定义帧',
function() enqueueTask(function()
HK()
local info = gg.getTargetInfo()
if info.x64 then
if savedZhenlvAddr then
local old_sj = sj
sj = {{address = savedZhenlvAddr, flags = 4, value = 0}}
xg3(nil,4,0,true,"帧率")
sj = old_sj
else
提示("请先初始化帧率地址")
end
else
local t = {"libclient.so:bss", "Cb"}
local tt = {0xFC, 0xC}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 1145}})
end
end) end),
RG.button('一键原地自杀',
function() enqueueTask(function()
HK() 
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(-114514,16,-8,false)

search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(3000,16,-8,false)
end) end),
RG.check({"设置防封",}),
RG.box({"防封类(大厅开)",
RG.radio({"设置防封 ",
{"防log",
function() enqueueTask(function()
HK()
fanglog()
end) end
},{"防端口",
function() enqueueTask(function()
HK() 
fangduanko()
end) end
},{"过检测",
function() enqueueTask(function()
HK()
guojiance()
end) end
},{"防检测",
function() enqueueTask(function()
HK()
fangjiance()
end) end
},{"一键开启",
function() enqueueTask(function()
HK()
fanglog()
fangduanko()
guojiance()
fangjiance()
end) end
}
}),
}),
RG.check({"设置速度",}),
RG.switch("不漂移加速",
function() enqueueTask(function()
HK()
不漂移加速()
提示("已开启") 
end) end,
function()
HK()
不漂移加速关闭()
提示("已关闭")
end
),
RG.switch("频率加速",
function() enqueueTask(function()
HK()
频率加速()
end) end,
function()
HK()
不漂移加速关闭()
提示("已关闭")
end
),
RG.switch("特殊加速",
function() enqueueTask(function()
HK()
特殊加速()
end) end,
function()
HK()
特殊加速关闭()
end
),
RG.switch("大力神加速",
function() enqueueTask(function()
HK()
大力神加速开()
end) end,
function()
HK()
大力神加速关()
end
),
RG.switch("灰屏共鸣",
function() enqueueTask(function()
HK()
灰屏共鸣()
end) end,
function()
HK()
灰屏共鸣关闭()
end
),
RG.switch("停止发包",
function() enqueueTask(function()
HK()
停止发包开()
end) end,
function()
HK()
停止发包关()
end
),
RG.switch("核心加速",
function() enqueueTask(function()
HK()
核心加速开()
xg1(999999999999999999999,16,140,false)
end) end,
function()
核心加速关()
end
),
RG.switch("核心加速自定义",
function() enqueueTask(function()
HK()
核心加速开()
xg3(999999999999999999999,16,140,false,true,"(自定义核心加速)")
end) end,
function()
核心加速关()
end
),
RG.switch("核心激活",
function() enqueueTask(function()
HK()
核心激活开()
end) end,
function()
HK()
核心激活关()
end
),
RG.switch("核心伪Y++",
function() enqueueTask(function()
HK()
核心伪Y加加开()
end) end,
function()
HK()
核心伪Y加加关()
end
),
RG.switch("萌新CD",
function() enqueueTask(function()
HK()
萌新CD开()
end) end,
function()
HK()
萌新CD关()
end
),
RG.switch("核心防水",
function() enqueueTask(function()
HK()
核心防水开()
end) end,
function()
HK()
核心防水关()
end
),
RG.switch("防闪耀星光",
function() enqueueTask(function()
HK()
防闪光弹开()
end) end,
function()
HK()
防闪光弹关()
end
),
RG.switch("海王盾绘制",
function() enqueueTask(function()
HK()
guanfangesp(1)
end) end,
function()
HK()
guanfangesp(0)
end
),
RG.switch("特殊视角",
function() enqueueTask(function()
HK()
特殊视角开()
end) end,
function()
HK()
特殊视角关()
end
),
RG.switch("相机坐标",
function() enqueueTask(function()
HK()
freezeCamera()
end) end,
function()
HK()
unfreezeCamera()
end
),
RG.switch("相机Y状态",
function() enqueueTask(function()
HK()
相机Y状态开()
end) end,
function()
HK()
相机Y状态关()
end
),
RG.switch("霜鸟锁定数量",
function() enqueueTask(function()
HK()
霜鸟锁定数量开()
end) end,
function()
HK()
霜鸟锁定数量关()
end
),
RG.box({"物理加速",
RG.radio({"物理加速",
{"一级物理加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215, 4, -36)
py1(257, 4, -32)
xg1(-0.35,16,76,true)
end) end
},
{"二级物理加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215, 4, -36)
py1(257, 4, -32)
xg1(-0.45,16,76,true)
end) end
},
{"三级物理加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215, 4, -36)
py1(257, 4, -32)
xg1(-0.50,16,76,true)
end) end
},
{"自定义物理加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215, 4, -36)
py1(257, 4, -32)
xg3(nil,16,76,true,"(自定义物理加速)")
end) end
},
{"恢复物理加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215, 4, -36)
py1(257, 4, -32)
xg1(-0.35,16,76,false)
end) end
}
}),
}),
RG.box({"惯性加速",
RG.radio({"惯性加速 ",
{"开启惯性加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(-1.5,16,76,true)
end) end
},
{"自定义惯性加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(nil,16,76,true,"(自定义惯性加速)")
end) end
},
{"关闭惯性加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(-0.55,16,76,false)
end) end
}
}),
}),
RG.box({"不稳定加速",
RG.radio({"不稳定加速 ",
{"开启加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(-15,16,76,true)
end) end
},
{"关闭加速",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(-0.55,16,76,false)
end) end
}
}),
}),
RG.box({"硬核加速",
RG.box1({"普通",
RG.radio1({" ",
{"腿车专用加速" ,
function() enqueueTask(function()
HK()
search(2.6524947387E-314,64,neicun)
py1(2.653660386E-314,64,-64)
py1(2.6527537714E-314,64,-48)
py1(-550.0,64,44)
py1(7.961227744E-314,64,64)
xg1(9,64,-324,true)
end) end
}, 
{"风声加速" ,
function() enqueueTask(function()
HK()
search(2.6524947387E-314,64,neicun)
py1(2.653660386E-314,64,-64)
py1(2.6527537714E-31464,-48)
py1(-550.0,64,44)
py1(7.961227744E-314,64,64)
xg1(9,64,-324,false)
end) end
}, 
{"风声加速Plus",
function() enqueueTask(function()
HK()
search(2.6524947387E-314,64,neicun)
py1(2.653660386E-314,64,-64)
py1(2.6527537714E-314,64,-48)
py1(-550.0,64,44)
py1(7.961227744E-314,64,64)
xg1(12.3,64,-324,false)
end) end
},
{"性能加速",
function() enqueueTask(function()
HK()
search(1072693248,4,neicun)
py1(745,4,-20)
xg1(9,64,-28,true)
end) end
},
{"自定义速度",
function() enqueueTask(function()
HK()
search(2.6524947387E-314,64,neicun)
py1(2.653660386E-314,64,-64)
py1(2.6527537714E-314,64,-48)
py1(-550.0,64,44)
py1(7.961227744E-314,64,64) 
xg3(nil,64,-324,true,"(自定义风声加速)")
end) end
},
{"恢复速度",
function() enqueueTask(function()
HK()
search(2.6524947387E-314,64,neicun)
py1(2.653660386E-314,64,-64)
py1(2.6527537714E-314,64,-48)
py1(-550.0,64,44)
py1(7.961227744E-314,64,64)
xg1(9,64,-324,false)
search(2.6524947387E-314,64,neicun)
py1(2.653660386E-314,64,-64)
py1(2.6527537714E-314,64,-48)
py1(-550.0,64,44)
py1(7.961227744E-314,64,64)
xg1(0.5,64,-324,false)
search(1072693248,4,neicun)
py1(745,4,-20)
xg1(9,64,-28,false)
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("4.51", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("4.51", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(500)
gg.editAll("0.5", gg.TYPE_FLOAT)
end) end},
}),
}),
RG.box1({"基址",
RG.radio1({" ",
{"腿车专用加速" ,
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xC7E798, 0x40, 0x30, 0x28,0x70,0x10}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 64, value = 1.9}})
提示("开启成功,请解体修复") 
end) end,
}, 
{"风声加速" ,
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xC7E798, 0x40, 0x30, 0x28,0x70,0x10}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 64, value = 9}})
提示("开启成功,请解体修复") 
end) end
}, 
{"风声加速Plus",
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xC7E798, 0x40, 0x30, 0x28,0x70,0x10}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 64, value = 12}})
提示("开启成功,请解体修复") 
end) end
},
{"自定义基址风声加速",
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xC7E798, 0x40, 0x30, 0x28,0x70,0x10}
local ttt = S_Pointer(t, tt, true)
local cv = gg.getValues({{address=S_Pointer(t,tt,true),flags=64}})[1].value
local i = gg.prompt({
'值[当前:'..cv..']',
'记住上次输入值'
},{
rememberLastValue and (lastModifiedValue or cv) or cv,
rememberLastValue
},{
'number','checkbox'
})

if i then 
rememberLastValue = i[2]
local nv = tonumber(i[1]) or (rememberLastValue and lastModifiedValue) or cv
if rememberLastValue then lastModifiedValue = nv end
gg.setValues({{address=ttt,flags=64,value=nv,freeze=true}})
提示(("修改成功 - 新值→%s"..(rememberLastValue and"(已储存)"or"")):format(nv))
else 提示("已取消") end
end) end
},
{"恢复速度",
function() enqueueTask(function()
HK()

local t = {"libclient.so:bss", "Cb"}
local tt = {0xC7E798, 0x40, 0x30, 0x28,0x70,0x10}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 64, value = 0.5}})

提示("恢复成功,请解体修复") 
end) end},
}),
}),
}),
RG.line(),
RG.check({"踏空",}),
RG.box({"设置踏空",---box示例 可以删掉
RG.switch("普通车体踏空",
function() enqueueTask(function()
HK()
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('0.85',gg.TYPE_DOUBLE,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('27.6427787',gg.TYPE_DOUBLE)
提示("开启成功,请解体修复") 
end) end,
function() enqueueTask(function()
HK()
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('27.6427787',gg.TYPE_DOUBLE,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('0.85',gg.TYPE_DOUBLE)
提示("恢复成功,请解体修复") 
end) end),
RG.switch("高级车体踏空",
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xC7E798, 0x40, 0x30, 0x28,0x70,0x10}
local ttt = S_Pointer(t, tt, true)
local cv = gg.getValues({{address=S_Pointer(t,tt,true),flags=64}})[1].value
local i = gg.prompt({
'值[当前:'..cv..']',
'记住上次输入值'
},{
rememberLastValue and (lastModifiedValue or cv) or cv,
rememberLastValue
},{
'number','checkbox'
})

if i then 
rememberLastValue = i[2]
local nv = tonumber(i[1]) or (rememberLastValue and lastModifiedValue) or cv
if rememberLastValue then lastModifiedValue = nv end
gg.setValues({{address=ttt,flags=64,value=nv,freeze=true}})
提示(("修改成功 - 新值→%s"..(rememberLastValue and"(已储存)"or"")):format(nv))
else 提示("已取消") end
gg.sleep(500)
提示("请使用腾跃请解体修复")
editData(
{
	{["memory"] = gg.REGION_C_ALLOC},
	{["name"] = ""},
	{["value"] = 17039364, ["type"] = D},
	{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
	{["value"] = 0,["offset"] =-0x1C, ["type"] = F,["freeze"] = true},
	{["value"] = 0,["offset"] =-0x14, ["type"] = F,["freeze"] = true},
}
)
end) end,
function() enqueueTask(function()

HK()

local t = {"libclient.so:bss", "Cb"}
local tt = {0xC7E798, 0x40, 0x30, 0x28,0x70,0x10}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 64, value = 0.5}})

提示("请解体修复")
gg.clearResults()
gg.clearList()
end) end),
RG.switch("核心踏空",
function() enqueueTask(function()
HK()
search(1077805056,4,neicun)
py1(-1889785610,4,44)
xg3(nil,64,164,true,"(自定义踏空高度)")
gg.sleep(1)
local t = {"libclient.so:bss", "Cb"}
local tt = {0xC7E798, 0x40, 0x30, 0x28,0x70,0x10}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 64, value = 10}})
gg.sleep(500)
提示("请解体")

editData(
{
{["memory"] = gg.REGION_C_ALLOC},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = 0,["offset"] =-0x1C, ["type"] = F,["freeze"] = true},
{["value"] = 0,["offset"] =-0x14, ["type"] = F,["freeze"] = true},
}
)
end) end,
function() enqueueTask(function()

HK()
 
search(1077805056,4,neicun)
py1(-1889785610,4,44)
xg1(0.4,64,164,false)--踏空

gg.sleep(1)

local t = {"libclient.so:bss", "Cb"}
local tt = {0xC7E798, 0x40, 0x30, 0x28,0x70,0x10}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 64, value = 0.5}})

editData(
{
{["memory"] = gg.REGION_C_ALLOC},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = 0,["offset"] =-0x1C, ["type"] = F,["freeze"] = false},
{["value"] = 0,["offset"] =-0x14, ["type"] = F,["freeze"] = false},
}
)
end) end
),
}),

RG.check({"范围伤害",}),
RG.box({"设置范围伤害",
RG.box1({"设置核心范围",
RG.switch("萌新范围",
function() luajava.newThread(function()
HK()
萌新范围开()
end):start() end,
function()
HK()
萌新范围关()
end
),
RG.switch("铠鼠范围",
function() luajava.newThread(function()
HK()
铠鼠范围开()
end):start() end,
function()
HK()
铠鼠范围关()
end
),
RG.switch("火萤范围",
function() luajava.newThread(function()
HK()
火萤范围开()
end):start() end,
function()
HK()
火萤范围关()
end
),
RG.switch("风声范围",
function() luajava.newThread(function()
HK()
风声范围开()
end):start() end,
function()
HK()
风声范围关()
end
),
RG.switch("大家伙范围",
function() luajava.newThread(function()
HK()
大家伙范围开()
end):start() end,
function()
HK()
大家伙范围关()
end
),
RG.switch("夜莺范围",
function() luajava.newThread(function()
HK()
夜莺范围开()
end):start() end,
function()
HK()
夜莺范围关()
end
),
RG.switch("网虫范围",
function() luajava.newThread(function()
HK()
网虫范围开()
end):start() end,
function()
HK()
网虫范围关()
end
),
RG.switch("幻灵范围",
function() luajava.newThread(function()
HK()
幻灵范围开()
end):start() end,
function()
HK()
幻灵范围关()
end
),
RG.switch("铁驭/赋能/序列范围",
function() luajava.newThread(function()
HK()
铁驭范围开()
end):start() end,
function()
HK()
铁驭范围关()
end
),
RG.button('一键开启核心范围',
function() luajava.newThread(function()
HK()
一键开启核心范围执行()
end):start() end),
RG.button('一键关闭核心范围',
function() luajava.newThread(function()
HK()
一键关闭核心范围执行()
end):start() end),
}),
RG.line(),
RG.check({"false/true",}),
RG.switch("是/否冻结以下范围修改",
function() luajava.newThread(function()
是否冻结切换(true)
提示("已切换为冻结范围")
end):start() end,
function()
是否冻结切换(false)
HA()
提示("已切换为非冻结范围")
end
),
RG.check({"关/开",}),
RG.switch("秒杀范围回拉",
function() luajava.newThread(function()
回拉值切换(true)
提示("已开启秒杀范围回拉")
end):start() end,
function()
回拉值切换(false)
提示("已关闭秒杀范围回拉")
end
),
RG.check({"浮点/二进制",}),
RG.switch("车体范围切换",
function() luajava.newThread(function()
msfwqh = true 
提示("已切换为二进制版本秒杀范围")
end):start() end,
function()
msfwqh = false 
提示("已切换为浮点版本秒杀范围")
end
),
RG.check({"关/开",}),
RG.switch("子弹无伤",
function() luajava.newThread(function()
HK()
子弹无伤开()
end):start() end,
function()
HK()
子弹无伤关()
end
),
RG.check({"关/开",}),
RG.switch("子弹打盾无伤",
function() luajava.newThread(function()
HK()
子弹打盾无伤开()
end):start() end,
function()
HK()
子弹打盾无伤关()
end
),
RG.check({"2级/1级",}),
RG.switch("模块增伤伤害等级",
function() luajava.newThread(function()
setDamageLevel(1)
end):start() end,
function()
setDamageLevel(2)
end
),
RG.line(),
RG.box1({"模块增伤",
RG.switch("上等兵",
function() enqueueTask(function()
HK()
zengshang(4020,1)
end) end,
function()
HK()
zengshang(4020,0)
end
),
RG.switch("午夜派对",
function() enqueueTask(function()
HK()
zengshang(4040,1)
end) end,
function()
HK()
zengshang(4040,0)
end
),
RG.switch("碧蓝使者",
function() enqueueTask(function()
HK()
zengshang(4140,1)
end) end,
function()
HK()
zengshang(4140,0)
end
),
RG.switch("穿云",
function() enqueueTask(function()
HK()
zengshang(3104010,1)
end) end,
function()
HK()
zengshang(3104010,0)
end
),
RG.switch("裂空",
function() enqueueTask(function()
HK()
zengshang(3704010,1)
end) end,
function()
HK()
zengshang(3704010,0)
end
),
RG.switch("球状闪电",
function() enqueueTask(function()
HK()
zengshang(3404010,1)
end) end,
function()
HK()
zengshang(3404010,0)
end
),
RG.switch("防空炮",
function() enqueueTask(function()
HK()
zengshang(3704020,1)
end) end,
function()
HK()
zengshang(3704020,0)
end
),
RG.switch("泡泡枪",
function() enqueueTask(function()
HK()
zengshang(3511010,1)
end) end,
function()
HK()
zengshang(3511010,0)
end
),
RG.switch("业火焚世",
function() enqueueTask(function()
HK()
zengshang(3304010,1)
end) end,
function()
HK()
zengshang(3304010,0)
end
),
RG.switch("自定义模块增伤",
function() enqueueTask(function()
HK()
local input = gg.prompt({'自定义模块增伤'}, {[1]='4020'})
if not input then return end
zidinyimokuaizenshang = tonumber(input[1])
if not zidinyimokuaizenshang then
zidinyimokuaizenshang = 4020
提示("输入无效，使用默认值4020")
end
zengshang(zidinyimokuaizenshang,1)
end) end,
function()
HK()
if zidinyimokuaizenshang then
zengshang(zidinyimokuaizenshang,0)
else
提示("请先使用自定义模块增伤功能")
end
end
),
RG.switch("自定义模块穿透",
function() enqueueTask(function()
HK()
local input = gg.prompt({'自定义模块穿透'}, {[1]='3304010'})
if not input then return end
zidinyimokuaicuantou = tonumber(input[1])
if not zidinyimokuaicuantou then
zidinyimokuaicuantou = 3304010
提示("输入无效，使用默认值3304010")
end
zengshang(zidinyimokuaicuantou,1)
end) end,
function()
HK()
if zidinyimokuaicuantou then
zengshang(zidinyimokuaicuantou,0)
else
提示("请先使用自定义模块穿透功能")
end
end
),
RG.button("查看模块ID",
function() runAsyncTask(function()
HK()
showAllKnownModules()
end) end),
}),
RG.line(),
RG.box1({"模块缴械",
RG.switch("腾跃缴械",
function() enqueueTask(function()
HK()
腾跃缴械开()
end) end,
function()
HK()
腾跃缴械关()
end
),
RG.switch("鹰驰缴械",
function() enqueueTask(function()
HK()
鹰驰缴械开()
end) end,
function()
HK()
鹰驰缴械关()
end
),
RG.switch("大力神缴械",
function() enqueueTask(function()
HK()
大力神缴械开()
end) end,
function()
HK()
大力神缴械关()
end
),
RG.switch("海王盾缴械",
function() enqueueTask(function()
HK()
海王盾缴械开()
end) end,
function()
HK()
海王盾缴械关()
end
),
RG.switch("重装魔方缴械",
function() enqueueTask(function()
HK()
重装魔方缴械开()
end) end,
function()
HK()
重装魔方缴械关()
end
),
RG.switch("天行者缴械",
function() enqueueTask(function()
HK()
天行者缴械开()
end) end,
function()
HK()
天行者缴械关()
end
),
RG.switch("午夜派对缴械",
function() enqueueTask(function()
HK()
午夜派对缴械开()
end) end,
function()
HK()
午夜派对缴械关()
end
),
RG.switch("穿云缴械",
function() enqueueTask(function()
HK()
穿云缴械开()
end) end,
function()
HK()
穿云缴械关()
end
),
RG.switch("穹弩缴械",
function() enqueueTask(function()
HK()
穹弩缴械开()
end) end,
function()
HK()
穹弩缴械关()
end
),
RG.switch("特斯拉的巨剑缴械",
function() enqueueTask(function()
HK()
特斯拉的巨剑缴械开()
end) end,
function()
HK()
特斯拉的巨剑缴械关()
end
),
RG.switch("小指头缴械",
function() enqueueTask(function()
HK()
小指头缴械开()
end) end,
function()
HK()
小指头缴械关()
end
),
RG.switch("业火焚世缴械",
function() enqueueTask(function()
HK()
业火焚世缴械开()
end) end,
function()
HK()
业火焚世缴械关()
end
),
RG.switch("寂静之声缴械",
function() enqueueTask(function()
HK()
寂静之声缴械开()
end) end,
function()
HK()
寂静之声缴械关()
end
),
RG.switch("苍穹守护缴械",
function() enqueueTask(function()
HK()
苍穹守护缴械开()
end) end,
function()
HK()
苍穹守护缴械关()
end
),
RG.switch("野蜂缴械",
function() enqueueTask(function()
HK()
野蜂缴械开()
end) end,
function()
HK()
野蜂缴械关()
end
)
}),
RG.line(),
RG.box1({"设置车体范围",
RG.switch("正常秒杀范围优化",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    正常秒杀范围优化()
else
    正常秒杀范围优化二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("正常秒杀范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    正常秒杀范围()
else
    正常秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("不挡秒杀范围(新)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    不挡秒杀范围新()
else
    不挡秒杀范围新二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("队友不挡高伤范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    队友不挡高伤范围()
else
    队友不挡高伤范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("执行迅速秒杀范围(新)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    执行迅速秒杀范围新()
else
    执行迅速秒杀范围新二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("频率优化秒杀范围(旧)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    频率优化秒杀范围旧()
else
    频率优化秒杀范围旧二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("频率优化秒杀范围(新)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    频率优化秒杀范围新()
else
    频率优化秒杀范围新二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("极小秒杀范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    极小秒杀范围()
else
    极小秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("迫击炮延迟发包(轰炸区)",
function() luajava.newThread(function()
HK()
paijipaofabao(true)
end):start() end,
function()
paijipaofabao(false)
end
),
RG.switch("子弹穿墙",
function() luajava.newThread(function()
HK()
提示('已开启')
子弹穿墙开()
end):start() end,
function()
HK()
提示('已关闭')
子弹穿墙关()
end
),
}),
RG.line(),
RG.box1({"设置车体旧范围",
RG.switch("不秒杀范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    不秒杀范围()
else
    不秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("自定义不秒杀范围",
function() luajava.newThread(function()
HK()
if msfwqh == false then
    自定义不秒杀范围()
else
    自定义不秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("子弹穿墙",
function() luajava.newThread(function()
HK()
提示('已开启')
子弹穿墙开()
end):start() end,
function()
HK()
提示('已关闭')
子弹穿墙关()
end
),
RG.check({"以下范围伤害可能容易闪退",}),
RG.switch("范围穿甲弹",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    范围穿甲弹()
else
    范围穿甲弹二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("自瞄炮范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
自瞄炮范围()
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("高伤",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    高伤()
else
    高伤二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
}),
}),
RG.line(),
RG.check({"后坐力",}),
RG.box({"设置后坐",
RG.radio({"",
{"反后坐(会穿墙)" ,
function() enqueueTask(function()
HK()
提示("传送至高空并开启后坐")
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5000,16,-8,false)
xg1(-3.5,16,96,true) 
end) end
}, 
{"反后坐plus" ,
function() enqueueTask(function()
HK()
提示("传送至高空并开启后坐")
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5000,16,-8,false)
xg1(-9,16,96,true) 
end) end
}, 
{"无重力反后坐" ,
function() enqueueTask(function()
HK()
提示("传送至高空并开启后坐")
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5000,16,-8,false)
xg1(-35,16,96,true) 
end) end
}, 
{"高后坐",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(3.5,16,96,true) 
end) end},
{"高后坐plus",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(9,16,96,true) 
end) end},
{"机枪后坐",
function() enqueueTask(function()
HK()
gg.clearResults()
local info = gg.getTargetInfo()
if info.x64 then
提示("64位机枪后坐力正在开启")
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg1(-9,16,24,false)
else
提示("32位机枪后坐力正在开启")
gg.searchNumber("1.9375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(1000)
for i, v in ipairs(results) do
    v.address = v.address + 0x14
end
gg.loadResults(results)
gg.refineNumber("1.12103877e-44", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results2 = gg.getResults(1000)
for i, v in ipairs(results2) do
    v.address = v.address + 0x18
end
gg.loadResults(results2)
gg.refineNumber("89,128.9609375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results3 = gg.getResults(1000)
for i, v in ipairs(results3) do
    v.address = v.address + 0x24
end
gg.loadResults(results3)

gg.editAll("-9", gg.TYPE_FLOAT)
提示("已开启反向后坐力")
gg.clearResults()
end
end) end},
{"自定义机枪后坐",
function() enqueueTask(function()
HK()
gg.clearResults()
local info = gg.getTargetInfo()
if info.x64 then
提示("64位机枪后坐力正在开启")
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg3(nil,16,24,false,"(自定义机枪后坐)")
else
提示("32位机枪后坐力正在开启")
gg.refineNumber("89,128.9609375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local finalResults = gg.getResults(1000)
local currentValue = finalResults[1] and finalResults[1].value or "未知"
local pt = "当前值:" .. tostring(currentValue) .. " | 输入新值(推荐:-9)"
local i = gg.prompt({pt, "记住"}, {"-9", false}, {"number", "checkbox"})
if not i then
提示("已取消")
gg.clearResults()
return
end
local inputValue = i[1]
if not inputValue or not inputValue:match("^%-?%d+%.?%d*$") then
提示("输入错误,已取消")
gg.clearResults()
return
end
for j, v in ipairs(finalResults) do
v.address = v.address + 0x24
end
gg.loadResults(finalResults)
gg.editAll(inputValue, gg.TYPE_FLOAT)
提示("共修改 " .. #finalResults .. " 个数据 → " .. inputValue)
gg.clearResults()
end
end) end},
{"自定义后坐",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(nil,16,96,true,"(自定义后坐)")
end) end},
{"机枪离线",
function() enqueueTask(function()
HK()
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg3(-1,4,24,false,true,"(自定义机枪离线)")
end) end},
{"恢复以上",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(0.007352941203862429,16,96,false)
gg.clearResults()
local info = gg.getTargetInfo()
if info.x64 then
提示("64位机枪后坐力正在关闭")
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg1(1081466880,4,24,false)
xg1(3.841796875,16,24,false)
else
提示("32位机枪后坐力正在关闭")
gg.searchNumber("1.9375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(1000)
for i, v in ipairs(results) do
    v.address = v.address + 0x14
end
gg.loadResults(results)
gg.refineNumber("1.12103877e-44", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results2 = gg.getResults(1000)
for i, v in ipairs(results2) do
    v.address = v.address + 0x18
end
gg.loadResults(results2)
gg.refineNumber("89,128.9609375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results3 = gg.getResults(1000)
for i, v in ipairs(results3) do
    v.address = v.address + 0x24
end
gg.loadResults(results3)
gg.editAll("3.841796875", gg.TYPE_FLOAT)
提示("已关闭反向后坐力")
gg.clearResults()
end
end) end},
})
}),
RG.line(),
RG.check({"高度",}),
RG.box({"设置高度",
RG.check({"true/false",}),
RG.switch("是/否冻结以下传送高度冻结",
function() luajava.newThread(function()
高度冻结方式(false)
HA()
提示("已切换为非冻结高度传送")
end):start() end,
function()
高度冻结方式(true)
提示("已切换为冻结高度传送") 
end
),
RG.line(),
RG.box1({"普通",
RG.radio1({"",
{"低空" ,
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(3200,16,-8,传送高度冻结)
end) end}, 
{"高空" ,
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(6100,16,-8,传送高度冻结)
end) end
}, {"超高" ,
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(999999,16,-8,传送高度冻结)
end) end
},{"极高" ,
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5000000,16,-8,传送高度冻结)
end) end
},
{"地下",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(-1300,16,-8,传送高度冻结)
end) end},
{"自定义高度",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(nil,16,-8,传送高度冻结,"(自定义高度)")
end) end},
{"返回地面",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(4000,16,-8,false)
end) end},
}),
}),
RG.box1({"基址",
RG.radio1({"",
{"低空" ,
function() enqueueTask(function()
HK()
gg.sleep(1)
local t = {"libclient.so:bss", "Cb"}
local tt = {0xDCBC30, 0xD30, 0x10, 0xA4}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 3000, freeze = 传送高度冻结}})
提示("↑")
end) end
}, 
{"高空" ,
function() enqueueTask(function()
HK() 
local t = {"libclient.so:bss", "Cb"}
local tt = {0xDCBC30, 0xD30, 0x10, 0xA4}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 6100, freeze = 传送高度冻结}})
提示("↑↑")
end) end
}, {"极高" ,
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xDCBC30, 0xD30, 0x10, 0xA4}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 999000, freeze = 传送高度冻结}})
提示("↑↑↑")
end) end
}, 
{"地下",
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xDCBC30, 0xD30, 0x10, 0xA4}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = -1300, freeze = 传送高度冻结}})
提示("↓")
end) end},
{"自定义高度",
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xDCBC30, 0xD30, 0x10, 0xA4}
local ttt = S_Pointer(t, tt, true)
local cv = gg.getValues({{address=S_Pointer(t,tt,true),flags=16}})[1].value
local i = gg.prompt({
'值[当前:'..cv..']',
'记住上次输入值'
},{
rememberLastValue and (lastModifiedValue or cv) or cv,
rememberLastValue
},{
'number','checkbox'
})

if i then 
rememberLastValue = i[2]
local nv = tonumber(i[1]) or (rememberLastValue and lastModifiedValue) or cv
if rememberLastValue then lastModifiedValue = nv end
gg.addListItems({{address=ttt,flags=16,value=nv,freeze=传送高度冻结}})
提示(("修改成功 - 新值→%s"..(rememberLastValue and"(已储存)"or"")):format(nv))
else 提示("已取消") end
提示("•")
end) end},
{"返回地面",
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xDCBC30, 0xD30, 0x10, 0xA4}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 4000, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xDCBC30, 0xD30, 0x10, 0xA4}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 4000, freeze = true}})
gg.sleep(50)
local t = {"libclient.so:bss", "Cb"}
local tt = {0xDCBC30, 0xD30, 0x10, 0xA4}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 4000, freeze = false}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xDCBC30, 0xD30, 0x10, 0xA4}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 4000, freeze = false}})
提示("•")
end) end}, 
}),
}),
RG.box1({"特殊高度",
RG.radio1({"",
{"低空" ,
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(3200,16,168,传送高度冻结)
end) end
}, 
{"高空" ,
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(6100,16,168,传送高度冻结)
end) end
}, {"极高" ,
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(999999999999999,16,168,传送高度冻结)
end) end
}, 
{"地下",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(-1300,16,168,传送高度冻结)
end) end},
{"自定义高度",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(nil,16,168,传送高度冻结,"(自定义高度)")
end) end},
{"返回地面",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(4000,16,168,false)
end) end}, 
}),
}),
}),
RG.line(),
RG.check({"锁核心",}),
RG.box({"锁核",
RG.box1({"坐标锁核",
RG.radio1({"",
{"初始化坐标锁核" ,
function() luajava.newThread(function()
HK()
cleanHS3()
gg.sleep(300)
HS3()
end):start() end
},
{"初始化自身坐标" ,
function() luajava.newThread(function()
HK()
HS4()
end):start() end
},
{"实体坐标排序(近→远)" ,
function() luajava.newThread(function()
resortHS3(0)
end):start() end
},
{"实体坐标排序(远→近)" ,
function() luajava.newThread(function()
resortHS3(1)
end):start() end
},
{"过滤静止玩家坐标(近→远)" ,
function() luajava.newThread(function()
filterDynamicEntities(0.05, 0)
end):start() end
},
{"过滤静止玩家坐标(远→近)" ,
function() luajava.newThread(function()
filterDynamicEntities(0.05, 1)
end):start() end
},
{"X/Y/Z是否跟随" ,
function() luajava.newThread(function()
setAxisEnable()
showAxisStatus()
end):start() end
},
{"设置传送偏移",
function() luajava.newThread(function()
local inputs = gg.prompt({
"X 轴偏移",
"Y 轴偏移",
"Z 轴偏移",
"Y 快速设置①",
"Y 快速设置②"
}, {targetOffsetX, targetOffsetY, targetOffsetZ, targetOnsetY, targetOn2setY}, {"number", "number", "number", "number", "number"})
if inputs == nil then
提示("已取消")
return
end
local x = tonumber(inputs[1])
local y = tonumber(inputs[2])
local z = tonumber(inputs[3])
local onY = tonumber(inputs[4])
local onY2 = tonumber(inputs[5])
if x == nil or y == nil or z == nil or onY == nil or onY2 == nil then
提示("输入无效，请重新输入")
return
end
targetOffsetX = x
targetOffsetY = y
targetOffsetZ = z
targetOnsetY = onY
targetOn2setY = onY2
local files = io.open(offsetFilePath, "w")
files:write(base64.encode("♧"..targetOffsetX.."♧♡"..targetOffsetY.."♡◇"..targetOffsetZ.."◇○"..xunhuanjiange.."○□"..targetOnsetY.."□◁"..targetOn2setY.."▷"))
    files:close()
    提示(string.format("目标偏移已设置: X=%.2f Y=%.2f Z=%.2f onY=%.2f onY2=%.2f", targetOffsetX, targetOffsetY, targetOffsetZ, targetOnsetY, targetOn2setY))
end):start() end
},
{"快速Y偏移修改①",
function() luajava.newThread(function()
targetOffsetY = targetOnsetY
提示(string.format("Y轴偏移已设置为: %.2f", targetOffsetY))
end):start() end
},
{"快速Y偏移修改②",
function() luajava.newThread(function()
targetOffsetY = targetOn2setY
提示(string.format("Y轴偏移已设置为: %.2f", targetOffsetY))
end):start() end
},
{"重置传送偏移",
function() luajava.newThread(function()
local files = io.open(offsetFilePath, "w")
if files then
files:write(base64.encode("♧0♧♡0♡◇0◇○0.2○□5000□◁0▷"))
files:close()
targetOffsetX = 0
targetOffsetY = 0
targetOffsetZ = 0
xunhuanjiange = 0.2
targetOnsetY = 5000
targetOn2setY = 0
提示("目标偏移已重置")
else
提示("保存失败，请检查权限")
end
end):start() end
},
{"设置环绕数据" ,
function() luajava.newThread(function()
local 玩家间距 = gg.prompt({"环绕半径", "环绕高度", "环绕角度"}, {环绕半径, 环绕高度, 环绕角度}, {"number", "number", "number"})
if 玩家间距 == nil then
提示("已取消输入")
return
else
local 输入半径 = tonumber(玩家间距[1]) or 0
local 输入高度 = tonumber(玩家间距[2]) or 0
local 输入角度 = tonumber(玩家间距[3]) or 1
环绕半径 = 输入半径
环绕高度 = 输入高度
环绕角度 = 输入角度
local files = io.open("/sdcard/长安/环绕/环绕数据文件", "w")
files:write(base64.encode("♧"..环绕半径.."♧♡"..环绕高度.."♡◇"..环绕角度.."◇"))
files:close()
提示("环绕数据已保存")
end
end):start() end
},
{"重置环绕数据" ,
function() luajava.newThread(function()
local files = io.open(filePath, "w")
if files then
fileContent1 = "♧0♧♡0♡◇1◇"
files:write(base64.encode(fileContent1))
files:close()
end
环绕半径=0
环绕高度=0
环绕角度=1
提示("环绕数据已重置")
end):start() end
},
{"打开单次锁核菜单" ,
function() luajava.newThread(function()
HK()
CD()
end):start() end
},
{"随机单次锁核菜单" ,
function() luajava.newThread(function()
HK()
randomCD()
end):start() end
},
{"查看实体坐标数据储存",
function() luajava.newThread(function()
manageEntities()
end):start() end
},
{"清除锁核储存数据",
function() luajava.newThread(function()
HK()
cleanHS3()
end):start() end
},
}),
RG.box({"循环坐标锁核",
RG.switch("停止时还原位置",
function() luajava.newThread(function()
环绕还原 = false
提示("停止环绕后将停留在当前位置")
end):start() end,
function()
环绕还原 = true
提示("停止环绕后将还原到起点")
end
),
RG.switch("原地环绕(自己)",
function() luajava.newThread(function()
        HK()
        if not selfXAddr or not selfYAddr or not selfZAddr then
            提示("请先初始化自身坐标")
            return
        end

        local coords = gg.getValues({
            {address = selfXAddr, flags = gg.TYPE_FLOAT},
            {address = selfYAddr, flags = gg.TYPE_FLOAT},
            {address = selfZAddr, flags = gg.TYPE_FLOAT}
        })
        if not coords or not coords[1] or not coords[2] or not coords[3] then
            提示("获取坐标失败")
            return
        end

        local currentX = coords[1].value
        local currentY = coords[2].value
        local currentZ = coords[3].value

        local inputs = gg.prompt(
            {"环绕圆心 X", "环绕圆心 Y", "环绕圆心 Z"},
            {tostring(currentX), tostring(currentY), tostring(currentZ)},
            {"number", "number", "number"}
        )
        if inputs == nil then
            提示("已取消")
            return
        end

        local centerX = tonumber(inputs[1])
        local centerY = tonumber(inputs[2])
        local centerZ = tonumber(inputs[3])
        if not centerX or not centerY or not centerZ then
            提示("坐标无效，必须为数字")
            return
        end

        _G.userCenterX = centerX
        _G.userCenterY = centerY
        _G.userCenterZ = centerZ

        local angle = 0

        fw1 = true

        while fw1 do
        local radius = 环绕半径 or 0
        local height = 环绕高度 or 0
        local offsetX = targetOffsetX or 0
        local offsetY = targetOffsetY or 0
        local offsetZ = targetOffsetZ or 0
        local step = 环绕角度 or 0

            angle = (angle + step) % 360
            local rad = math.rad(angle)
            local newX = centerX + offsetX + radius * math.cos(rad)
            local newY = centerY + offsetY + height
            local newZ = centerZ + offsetZ + radius * math.sin(rad)

            gg.setValues({
                {address = selfXAddr, value = newX, flags = gg.TYPE_FLOAT},
                {address = selfYAddr, value = newY, flags = gg.TYPE_FLOAT},
                {address = selfZAddr, value = newZ, flags = gg.TYPE_FLOAT},
                {address = selfXAddr + 0xB0, value = newX, flags = gg.TYPE_FLOAT},
                {address = selfYAddr + 0xB0, value = newY, flags = gg.TYPE_FLOAT},
                {address = selfZAddr + 0xB0, value = newZ, flags = gg.TYPE_FLOAT}
            })
            gg.sleep(0)
        end
end):start() end,
function()
    fw1 = false
    if 环绕还原 then
        if selfXAddr and selfYAddr and selfZAddr and _G.userCenterX then
            local success, err = pcall(gg.setValues, {
                {address = selfXAddr, value = _G.userCenterX, flags = gg.TYPE_FLOAT},
                {address = selfYAddr, value = _G.userCenterY, flags = gg.TYPE_FLOAT},
                {address = selfZAddr, value = _G.userCenterZ, flags = gg.TYPE_FLOAT},
                {address = selfXAddr + 0xB0, value = _G.userCenterX, flags = gg.TYPE_FLOAT},
                {address = selfYAddr + 0xB0, value = _G.userCenterY, flags = gg.TYPE_FLOAT},
                {address = selfZAddr + 0xB0, value = _G.userCenterZ, flags = gg.TYPE_FLOAT}
            })
            if success then
                提示("已停止原地环绕，位置已还原")
            else
                提示("还原位置失败: " .. tostring(err))
            end
        else
            提示("已停止原地环绕，但无法还原位置（坐标数据丢失）")
        end
    else
        提示("已停止原地环绕，未还原位置")
    end
end
),
RG.button("设置停留时间",
function() enqueueTask(function()
setPlayerStayTime()
end) end),
RG.switch("多玩家循环传送",
function() runAsyncTask(function()
HK()
startMultiPlayerLoop()
end) end,
function() runAsyncTask(function()
stopMultiPlayerLoop()
end) end),
RG.switch("传送玩家1(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj1tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家2(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj2tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家3(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj3tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家4(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj4tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家5(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj5tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家6(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj6tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家7(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj7tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家8(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj8tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家9(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj9tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家10(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj10tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家11(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj11tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家12(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj12tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家13(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj13tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家14(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj14tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家15(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj15tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家16(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj16tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家17(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj17tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家18(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj18tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家19(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj19tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家20(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj20tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家21(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj21tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家22(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj22tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家23(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj23tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家24(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj24tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家25(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj25tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家26(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj26tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家27(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj27tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家28(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj28tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家29(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj29tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家30(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj30tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
}),
}),
RG.line(),
RG.box1({"天罚锁核",
RG.radio1({"",
{"初始化天罚锁核" ,
function() enqueueTask(function()
HK()
HS3()
end) end
},
{"初始化自身坐标" ,
function() enqueueTask(function()
HK()
HS4()
end) end
},
{"实体坐标排序(近→远)" ,
function() luajava.newThread(function()
resortHS3(0)
end):start() end
},
{"实体坐标排序(远→近)" ,
function() luajava.newThread(function()
resortHS3(1)
end):start() end
},
{"过滤静止玩家坐标(近→远)" ,
function() luajava.newThread(function()
filterDynamicEntities(0.05, 0)
end):start() end
},
{"过滤静止玩家坐标(远→近)" ,
function() luajava.newThread(function()
filterDynamicEntities(0.05, 1)
end):start() end
},
{"天罚传送设置",
function() enqueueTask(function()
zuizongpianyi()
end) end
},
{"重置天罚传送参数",
function() enqueueTask(function()
chongzhitianfa()
end) end
},
{"天罚锁核菜单" ,
function() enqueueTask(function()
HK()
tf1()
end) end
},
{"天罚随机锁核",
function() enqueueTask(function()
HK()
randomTeleport()
end) end},
{"测试功能",
function() enqueueTask(function()
HK() 
teleportAllToMe()
end) end
},
}),
RG.box({"天罚坐标锁核",
RG.switch("多玩家选择",
function() luajava.newThread(function()
HK()
startPlayerCycle()
end):start() end,
function()
stopPlayerCycle()
end
),
RG.switch("传送玩家1(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj51tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家2(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj52tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家3(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj53tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家4(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj54tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家5(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj55tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家6(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj56tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家7(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj57tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家8(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj58tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家9(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj59tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家10(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj60tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家11(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj61tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家12(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj62tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家13(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj63tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家14(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj64tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家15(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj65tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家16(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj66tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家17(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj67tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家18(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj68tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家19(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj69tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家20(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj70tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家21(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj71tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家22(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj72tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家23(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj73tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家24(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj74tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家25(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj75tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家26(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj76tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家27(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj77tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家28(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj78tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家29(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj79tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
RG.switch("传送玩家30(循环)",
function() luajava.newThread(function()
HK()
fw1=true
while fw1 do
gg.sleep(0)
wj80tp()
end
end):start() end,
function()
fw1=false
提示("已停止所有循环传送")
end
),
}),
}),
}),
RG.check({"核心自控",}),
RG.box({'视角自控',
RG.box({'视角自控设置',
RG.button("初始化数据",
function() enqueueTask(function()
HK()
reinitViewAll()
end) end),
RG.button("模式切换",
function() enqueueTask(function()
local modeMenu = {"坐标模式", "速度模式", "双模式合并"}
local choice = gg.choice(modeMenu, nil, "选择模式")
if choice then
setViewMode(choice)
end
end) end),
RG.button("设置移速",
function() enqueueTask(function()
setViewSpeed()
end) end),
RG.switch("执行启动",
function() runAsyncTask(function()
HK()
ViewControl:start()
end) end,
function() runAsyncTask(function()
ViewControl:stop()
end) end),
}),
RG.box({'视角追敌设置',
RG.button("初始化数据",
function() enqueueTask(function()
HK()
cleanHS3()
HS3()
initViewOnly()
end) end),
RG.button("实体坐标排序(近→远)",
function() enqueueTask(function()
resortHS3(0)
end) end),
RG.button("实体坐标排序(远→近)",
function() enqueueTask(function()
resortHS3(1)
end) end),
RG.button("过滤静止玩家坐标(远→近)",
function() enqueueTask(function()
filterDynamicEntities(0.05, 0)
end) end),
RG.button("过滤静止玩家坐标(近→远)",
function() enqueueTask(function()
filterDynamicEntities(0.05, 1)
end) end),
RG.button("设置瞄准偏移",
function() enqueueTask(function()
设置固定偏移()
end) end),
RG.button("设置近处补偿",
function() enqueueTask(function()
设置近处补偿()
end) end),
RG.button("设置远处补偿",
function() enqueueTask(function()
设置远处补偿()
end) end),
RG.button("设置水平补偿",
function() enqueueTask(function()
设置水平补偿()
end) end),
RG.button("设置垂直补偿",
function() enqueueTask(function()
设置垂直补偿()
end) end),
RG.switch("执行视角追踪",
function() runAsyncTask(function()
HK()
EnemyLock:toggle()
end) end,
function() runAsyncTask(function()
EnemyLock:stop()
end) end),
RG.box({'视角追敌快捷悬浮窗',
RG.switch("执行视角追踪",
function() runAsyncTask(function()
HK()
local success = 选择要显示的玩家()
if success then
gg.sleep(200)
打开玩家列表()
end
end) end,
function() runAsyncTask(function()
关闭玩家列表()
end) end),
RG.switch("执行视角自动追踪",
function() runAsyncTask(function()
HK()
打开页面("视角锁敌")
end) end,
function() runAsyncTask(function()
HK()
关闭页面("视角锁敌")
EnemyLock:stop()
gg.sleep(200)
end) end),
}),
}),
}),
RG.check({"全局速度",}),
RG.box({"设置全局速度",
RG.buts({
{"全局加速" ,
function() enqueueTask(function()
HK()
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("500", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("500",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("-99999999114514", FLOAT)
提示("开启成功")
gg.clearResults()
end
end) end
},
{"恢复全局" ,
function() enqueueTask(function()
HK()
gg.clearResults()
gg.searchNumber("-99999999114514",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("500", FLOAT)
提示("恢复")
gg.clearResults()
end) end
},
}),
}),
RG.line(),
RG.check({"天线",}),
RG.box({"天线功能",---box示例 可以删掉
RG.button("添加模块天线",
function() enqueueTask(function()

HK()

gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-5", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-5",FLOAT , false, gg.SIGN_EQUAL, 0, -1)

gg.editAll("114514", FLOAT)
gg.clearResults()
提示("开启成功")
end
 

--添加模块天线")
end) end),
RG.button("关闭模块天线",
function() enqueueTask(function()

HK()

gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("114514", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("关闭失败")
else
gg.searchNumber("114514",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
提示("关闭成功")
gg.editAll("-5", FLOAT)
gg.clearResults()
end
 

--关闭模块天线")
end) end),
RG.button("添加特殊天线",
function() enqueueTask(function()

HK()

search(-943501312,4,neicun)
py1(2,4,-436)
py1(-257,4,-432)
py1(-943501312,4,-52)
py1(-943501312,4,-48)
py1(-943501312,4,-44)
py1(-943501312,4,-8)
py1(-943501312,4,-4)
py1(1203982336,4,4)
py1(1203982336,4,8)
py1(1203982336,4,12)
py1(112,4,556)
xg1(114514,16,-480,true)

 

--添加特殊天线")
end) end),
RG.button("添加萌新天线",
function() enqueueTask(function()

HK()

gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("0.65025615692", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("99.64384", gg.TYPE_FLOAT)
提示("开启")
gg.clearResults()
 

--添加萌新天线")
end) end),
RG.button("关闭萌新天线",
function() enqueueTask(function()

HK()

gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("99.64384", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0.65025615692", gg.TYPE_FLOAT)
提示("关闭")
gg.clearResults()
end) end),
}),
},
{--2
RG.box({"获取个人坐标",
RG.button("初始化自身坐标",
function() luajava.newThread(function()
HK()
提示("初始化需约15秒")   
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("16777215;257;17039364::",gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("初始化个人坐标失败")
else
gg.searchNumber("17039364", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
zszb=gg.getResults(1)
提示('初始化个人坐标成功')
end
end):start() end), 
RG.button("获取自身坐标",
function() luajava.newThread(function()
HK()
 x=gg.getValues({[1]={address=zszb[1].address-0xc,flags=16,value=nil}}) 
 y=gg.getValues({[1]={address=zszb[1].address-0x8,flags=16,value=nil}}) 
 z=gg.getValues({[1]={address=zszb[1].address-0x4,flags=16,value=nil}}) 
提示('x:'..x[1].value..'\ny:'..y[1].value..'\nz:'..z[1].value)
end):start() end),  
RG.button("循环显示自身坐标",
function() luajava.newThread(function()
HK()
    zszs=true
while zszs==true do gg.sleep(400)
 x=gg.getValues({[1]={address=zszb[1].address-0xc,flags=16,value=nil}}) 
 y=gg.getValues({[1]={address=zszb[1].address-0x8,flags=16,value=nil}}) 
 z=gg.getValues({[1]={address=zszb[1].address-0x4,flags=16,value=nil}}) 
提示('x:'..x[1].value..'\ny:'..y[1].value..'\nz:'..z[1].value)
end
end):start() end),    
RG.button("结束循环显示自身坐标",
function() luajava.newThread(function()
HK() 
zszs=false
end):start() end),    
RG.button("自定义自身坐标",
function() luajava.newThread(function()

HK()
  
    x=gg.getValues({[1]={address=zszb[1].address-0xc,flags=16,value=nil}}) 
    y=gg.getValues({[1]={address=zszb[1].address-0x8,flags=16,value=nil}}) 
    z=gg.getValues({[1]={address=zszb[1].address-0x4,flags=16,value=nil}}) 
	sr=gg.prompt({'x','y','z'},{[1]=x[1].value,[2]=y[1].value,[3]=z[1].value})
	gg.setValues({[1]={address=zszb[1].address-0xC,flags=16,value=sr[1]}}) --x
	gg.setValues({[1]={address=zszb[1].address-0x8,flags=16,value=sr[2]}}) --y
	gg.setValues({[1]={address=zszb[1].address-0x4,flags=16,value=sr[3]}}) --z        
 
    
--自定义自身坐标")
    end):start() end),    
}), 
RG.line(), 
RG.box({"获取他人坐标",
RG.button("初始化他人坐标",
function() luajava.newThread(function()

HK()
  
提示("正在初始化")       
    editData(
{
{["memory"] = neicun},
{["name"] = "找敌"},
{["value"] = 17039361, ["type"] = D},
{["lv"] = -190986834,["offset"] =0x30, ["type"] = D},
},
{
{["value"] = 1145141919,["offset"] =-0x30, ["type"] = D,["freeze"] = false},
}
)

gg.clearResults()
gg.setRanges(neicun)
--检查遗留数据(敌人)
gg.searchNumber("1145141919", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local jc=gg.getResultsCount()
if jc < 1 then
gg.editAll("0", gg.TYPE_DWORD)
else
qnmbd()
gg.clearResults()
end
--获取加密数值:所有实体
gg.searchNumber("1145141919", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)

--获取实体数量
local cs=gg.getResultsCount()

gg.clearResults()
-- 定义全局变量drzb，以存储生成出来的变量名drzb+n
local drzb={}

-- 通过循环将cs的值计算出来的变量名drzb+n的值赋值给hq
for i=1,cs do
 drzb[i]='drzb'..i
 gg.searchNumber("1145141919", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1,1)
 _G['drzb'..i] = gg.getResults(1)
 gg.editAll(0,4)
 gg.clearResults()
end
--告诉玩家找到的实体数量
提示('目前仅支持一个玩家')
gg.clearResults()
gg.searchNumber("1234567890", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local cs=gg.getResultsCount()
if cs ==1 then
local bclb=gg.getResults(1)
gg.addListItems(bclb)
else gg.editAll(0,4)
gg.clearResults()
gg.searchNumber("1234567890", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local bclb=gg.getResults(1)
gg.addListItems(bclb)
end
a=gg.getListItems(1)
gg.clearResults()
提示('初始化完成')
end):start() end), 
RG.button("获取他人坐标",
function() luajava.newThread(function()

HK()
  
local x1=gg.getValues({[1]={address=drzb1[1].address+0x24,flags=16,value=nil}}) 
local y1=gg.getValues({[1]={address=drzb1[1].address+0x28,flags=16,value=nil}}) 
local z1=gg.getValues({[1]={address=drzb1[1].address+0x2C,flags=16,value=nil}}) 
	提示('x:'..x1[1].value..'\ny:'..y1[1].value..'\nz:'..z1[1].value)
 
    
--获取他人坐标")
    end):start() end),  
RG.button("循环显示敌人坐标",
function() luajava.newThread(function()

HK()
  
    drdr=true
while drdr==true do gg.sleep(400)
local x1=gg.getValues({[1]={address=drzb1[1].address+0x24,flags=16,value=nil}}) 
local y1=gg.getValues({[1]={address=drzb1[1].address+0x28,flags=16,value=nil}}) 
local z1=gg.getValues({[1]={address=drzb1[1].address+0x2C,flags=16,value=nil}}) 
	提示('x:'..x1[1].value..'\ny:'..y1[1].value..'\nz:'..z1[1].value)
	end
 
    
--循环显示敌人坐标")
    end):start() end),    
RG.button("结束循环显示敌人坐标",
function() luajava.newThread(function()

HK()
  
drdr=false
 
    
--结束循环显示敌人坐标")
    end):start() end), 
RG.button("传送到此人身上",
function() luajava.newThread(function()

HK()
  
local x1=gg.getValues({[1]={address=drzb1[1].address+0x24,flags=16,value=nil}}) 
local y1=gg.getValues({[1]={address=drzb1[1].address+0x28,flags=16,value=nil}}) 
local z1=gg.getValues({[1]={address=drzb1[1].address+0x2C,flags=16,value=nil}}) 
	sr=gg.prompt({'x','y','z'},{[1]=x1[1].value,[2]=y1[1].value,[3]=z1[1].value})
	gg.setValues({[1]={address=zszb[1].address-0xC,flags=16,value=sr[1]}}) --x
	gg.setValues({[1]={address=zszb[1].address-0x8,flags=16,value=sr[2]}}) --y
	gg.setValues({[1]={address=zszb[1].address-0x4,flags=16,value=sr[3]}}) --z        
 
    
--传送到此人身上")
    end):start() end),       
}),
RG.line(),
RG.check({"以下为传送",}),
RG.button("初始化传送",
function() enqueueTask(function()
HK()
	recordCount = recordCount + 1
	if recordCount <= maxRecordCount then
		-- 正常记录坐标
		clearLastRecord()
		startRecording()
		else
		-- 第三次点击，清除上次坐标，并重新开始
		clearLastRecord()
		recordCount = 1
		startRecording()
	end
--初始化传送")
end) end),
RG.line(),
RG.check({"false/true",}),
RG.switch("是/否冻结以下传送后冻结",
function() luajava.newThread(function()
冻结传送切换(true)
提示("已切换为冻结传送")
end):start() end,
function()
冻结传送切换(false)
提示("已切换为非冻结传送") 
end
),
RG.switch("坐标异常回溯",
function() luajava.newThread(function()
configureAutoPullBack()
startAutoPullBack()
end):start() end,
function()
stopAutoPullBack()
end
),
RG.line(), 
RG.box({"记录坐标传送",
RG.box({"记录当前坐标",
RG.buts({
{"记录坐标1",
function() enqueueTask(function()
HK()
记录(1)
提示("记录完成")
end) end,
},
{"记录坐标2",
function() enqueueTask(function()
HK()
记录(2)
提示("记录完成")
end) end,
},
{"记录坐标3",
function() enqueueTask(function()
HK()
记录(3)
提示("记录完成")
end) end,
},
{"记录坐标4",
function() enqueueTask(function()
HK()
记录(4)
提示("记录完成")
end) end,
},
{"记录坐标5",
function() enqueueTask(function()
HK()
记录(5)
提示("记录完成")
end) end,
},
{"记录坐标6",
function() enqueueTask(function()
HK()
记录(6)
提示("记录完成")
end) end,
},
{"记录坐标7",
function() enqueueTask(function()
HK()
记录(7)
提示("记录完成")
end) end,
},
{"记录坐标8",
function() enqueueTask(function()
HK()
记录(8)
提示("记录完成")
end) end,
},
{"记录坐标9",
function() enqueueTask(function()
HK()
记录(9)
提示("记录完成")
end) end,
},
{"记录坐标10",
function() enqueueTask(function()
HK()
记录(10)
提示("记录完成")
end) end,
}, {"记录坐标11",
function() enqueueTask(function()
HK()
记录(11)
提示("记录完成")end) end,
},
{"记录坐标12",
function() enqueueTask(function()
HK()
记录(12)
提示("记录完成")
end) end,
},
{"记录坐标13",
function() enqueueTask(function()
HK()
记录(13)
提示("记录完成")
end) end,
},
{"记录坐标14",
function() enqueueTask(function()
HK()
记录(14)
提示("记录完成")
end) end,
},
{"记录坐标15",
function() enqueueTask(function()
HK()
记录(15)
提示("记录完成")
end) end,
},
{"记录坐标16",
function() enqueueTask(function()
HK()
记录(16)
提示("记录完成")
end) end,
},
{"记录坐标17",
function() enqueueTask(function()
HK()
记录(17)
提示("记录完成")
end) end,
},
{"记录坐标18",
function() enqueueTask(function()
HK()
记录(18)
提示("记录完成")
end) end,
},
{"记录坐标19",
function() enqueueTask(function()
HK()
记录(19)
提示("记录完成")
end) end,
},
{"记录坐标20",
function() enqueueTask(function()
HK()
记录(20)
提示("记录完成")
end) end,
},
{"记录坐标21",
function() enqueueTask(function()
HK()
记录(21)
提示("记录完成")
end) end,
},
{"记录坐标22",
function() enqueueTask(function()
HK()
记录(22)
提示("记录完成")
end) end,
},
{"记录坐标23",
function() enqueueTask(function()
HK()
记录(23)
提示("记录完成")
end) end,
},
{"记录坐标24",
function() enqueueTask(function()
HK()
记录(24)
提示("记录完成")
end) end,
},
{"记录坐标25",
function() enqueueTask(function()
HK()
记录(25)
提示("记录完成")
end) end,
},
{"记录坐标26",
function() enqueueTask(function()
HK()
记录(26)
提示("记录完成")
end) end,
},
{"记录坐标27",
function() enqueueTask(function()
HK()
记录(27)
提示("记录完成")
end) end,
},
{"记录坐标28",
function() enqueueTask(function()
HK()
记录(28)
提示("记录完成")
end) end,
},
{"记录坐标29",
function() enqueueTask(function()
HK()
记录(29)
提示("记录完成")
end) end,
},
{"记录坐标30",
function() enqueueTask(function()
HK()
记录(30)
提示("记录完成")
end) end,
},
}),
}),
RG.box({"传送记录坐标",
RG.buts({
{"传送坐标1",
function() enqueueTask(function()
HK()
HE()
传送(1)
end) end,
},
{"传送坐标2",
function() enqueueTask(function()
HK()
HE()
传送(2)
end) end,
},
{"传送坐标3",
function() enqueueTask(function()
HK()
HE()
传送(3)
end) end,
},
{"传送坐标4",
function() enqueueTask(function()
HK()
HE()
传送(4)
end) end,
},
{"传送坐标5",
function() enqueueTask(function()
HK()
HE()
传送(5)
end) end,
},
{"传送坐标6",
function() enqueueTask(function()
HK()
HE()
传送(6)
end) end,
},
{"传送坐标7",
function() enqueueTask(function()
HK()
HE()
传送(7)
end) end,
},
{"传送坐标8",
function() enqueueTask(function()
HK()
HE()
传送(8)
end) end,
},
{"传送坐标9",
function() enqueueTask(function()
HK()
HE()
传送(9)
end) end,
},
{"传送坐标10",
function() enqueueTask(function()
HK()
HE()
传送(10)
end) end,
}, {"传送坐标11",
function() enqueueTask(function()
HK()
HE()
传送(11)
end) end,
},
{"传送坐标12",
function() enqueueTask(function()
HK()
HE()
传送(12)
end) end,
},
{"传送坐标13",
function() enqueueTask(function()
HK()
HE()
传送(13)
end) end,
},
{"传送坐标14",
function() enqueueTask(function()
HK()
HE()
传送(14)
end) end,
},
{"传送坐标15",
function() enqueueTask(function()
HK()
HE()
传送(15)
end) end,
},
{"传送坐标16",
function() enqueueTask(function()
HK()
HE()
传送(16)
end) end,
},
{"传送坐标17",
function() enqueueTask(function()
HK()
HE()
传送(17)
end) end,
},
{"传送坐标18",
function() enqueueTask(function()
HK()
HE()
传送(18)
end) end,
},
{"传送坐标19",
function() enqueueTask(function()
HK()
HE()
传送(19)
end) end,
},
{"传送坐标20",
function() enqueueTask(function()
HK()
HE()
传送(20)
end) end,
},
{"传送坐标21",
function() enqueueTask(function()
HK()
HE()
传送(21)
end) end,
},
{"传送坐标22",
function() enqueueTask(function()
HK()
HE()
传送(22)
end) end,
},
{"传送坐标23",
function() enqueueTask(function()
HK()
HE()
传送(23)
end) end,
},
{"传送坐标24",
function() enqueueTask(function()
HK()
HE()
传送(24)
end) end,
},
{"传送坐标25",
function() enqueueTask(function()
HK()
HE()
传送(25)
end) end,
},
{"传送坐标26",
function() enqueueTask(function()
HK()
HE()
传送(26)
end) end,
},
{"传送坐标27",
function() enqueueTask(function()
HK()
HE()
传送(27)
end) end,
},
{"传送坐标28",
function() enqueueTask(function()
HK()
HE()
传送(28)
end) end,
},
{"传送坐标29",
function() enqueueTask(function()
HK()
HE()
传送(29)
end) end,
},
{"传送坐标30",
function() enqueueTask(function()
HK()
HE()
传送(30)
end) end,
},
}),
}),
}),
RG.line(),
RG.box({"自定义坐标",
RG.button("手动输入自定义坐标传送",
function() enqueueTask(function()
HK()
HE()
if lastRecord then
    local base = nil
    if sj and #sj > 0 then
        base = sj[1].address
    elseif _selfBase then
        base = _selfBase
    end
    if base then
        local tasks = {
            {address = base - 4, flags = 16},   -- X
            {address = base - 8, flags = 16},   -- Y
            {address = base - 12, flags = 16}   -- Z
        }
        local values = gg.getValues(tasks)
        if values and values[1] and values[2] and values[3] then
            lastRecord.x = values[1].value
            lastRecord.y = values[2].value
            lastRecord.z = values[3].value
        end
    end
end

if not lastRecord then
    提示("请先初始化")
    return
end
local zdyzb = gg.prompt(
{"目标X轴", "目标Y轴", "目标Z轴"}, 
{lastRecord.x, lastRecord.y, lastRecord.z},
{"number", "number", "number"}
)
if zdyzb == nil then
    return 
end
if not zdyzb[1] or zdyzb[1] == "" then
    提示("X轴不能为空") 
    return
elseif not zdyzb[2] or zdyzb[2] == "" then
    提示("Y轴不能为空") 
    return
elseif not zdyzb[3] or zdyzb[3] == "" then
    提示("Z轴不能为空") 
    return
end
xg1(zdyzb[1],16,-4,cssfdj)
xg1(zdyzb[2],16,-8,cssfdj)
xg1(zdyzb[3],16,-12,cssfdj)
end) end),
}),
RG.line(),
RG.box({"超级风暴",
RG.buts({
{"大业殿",
function() enqueueTask(function()
HK()
HE()
xg1(630,16,-8,true)--y
xg1(1849,16,-4,true)
xg1(-1788,16,-12,true)
gg.sleep(100)
xg1(630,16,-8,cssfdj)--y
xg1(1849,16,-4,cssfdj)
xg1(-1788,16,-12,cssfdj)
end) end,
},
{"可汗石头",
function() enqueueTask(function()
HK()
HE()
xg1(150,16,-8,true)
xg1(-14571,16,-4,true)
xg1(-4057,16,-12,true)
gg.sleep(100)
xg1(150,16,-8,cssfdj)
xg1(-14571,16,-4,cssfdj)
xg1(-4057,16,-12,cssfdj)
end) end,
},
{"玉皇宫",
function() enqueueTask(function()
HK()
HE()
xg1(1380,16,-8,true)--y
xg1(-11745,16,-4,true)
xg1(9276,16,-12,true)
gg.sleep(100)
xg1(1380,16,-8,cssfdj)--y
xg1(-11745,16,-4,cssfdj)
xg1(9276,16,-12,cssfdj)
end) end,
},
}),
RG.buts({
{"菩提枫",
function() enqueueTask(function()
HK()
HE()
xg1(40,16,-8,true)
xg1(-2028,16,-4,true)
xg1(9627,16,-12,true)
gg.sleep(100)
xg1(40,16,-8,cssfdj)
xg1(-2028,16,-4,cssfdj)
xg1(9627,16,-12,cssfdj)
end) end,
},
{"北岸高架",
function() enqueueTask(function()
HK()
HE()
xg1(1600,16,-8,true)--y
xg1(9825,16,-4,true)
xg1(11275,16,-12,true)
gg.sleep(100)
xg1(1600,16,-8,cssfdj)--y
xg1(9825,16,-4,cssfdj)
xg1(11275,16,-12,cssfdj)
end) end,
},
{"长滩房子",
function() enqueueTask(function()
HK()
HE()
xg1(-450,16,-8,true)
xg1(-11405.460,16,-4,true)
xg1(-1871.13,16,-12,true)
gg.sleep(100)
xg1(-450,16,-8,cssfdj)
xg1(-11405.460,16,-4,cssfdj)
xg1(-1871.13,16,-12,cssfdj)
end) end,
},
}),
RG.buts({ 
{"太平门房子",
function() enqueueTask(function()
HK()
HE()
xg1(320,16,-8,true)--y
xg1(-5424,16,-4,true)
xg1(-13166,16,-12,true)
gg.sleep(100)
xg1(320,16,-8,cssfdj)--y
xg1(-5424,16,-4,cssfdj)
xg1(-13166,16,-12,cssfdj)
end) end,
},
{"大草原",
function() enqueueTask(function()
HK()
HE()
xg1(3600,16,-8,true)--y
xg1(7046.460,16,-4,true)
xg1(-10906,16,-12,true)
gg.sleep(100)
xg1(3600,16,-8,cssfdj)--y
xg1(7046.460,16,-4,cssfdj)
xg1(-10906,16,-12,cssfdj)
end) end,
},
{"荷塘房子",
function() enqueueTask(function()
HK()
HE()
xg1(490,16,-8,true)--y
xg1(-25.4606,16,-4,true)
xg1(-11460,16,-12,true)
gg.sleep(100)
xg1(490,16,-8,cssfdj)--y
xg1(-25.4606,16,-4,cssfdj)
xg1(-11460,16,-12,cssfdj)
end) end,
},
}),
RG.buts({
{"菩提枫房子",
function() enqueueTask(function()
HK()
HE()
xg1(-570,16,-8,true)--y
xg1(806.46063,16,-4,true)
xg1(10701,16,-12,true)
gg.sleep(100)
xg1(-570,16,-8,cssfdj)--y
xg1(806.46063,16,-4,cssfdj)
xg1(10701,16,-12,cssfdj)
end) end,
},
{"美食街车",
function() enqueueTask(function()
HK()
HE()
xg1(-500,16,-8,true)
xg1(-9261,16,-4,true)
xg1(5207,16,-12,true)
gg.sleep(100)
xg1(-500,16,-8,cssfdj)
xg1(-9261,16,-4,cssfdj)
xg1(5207,16,-12,cssfdj)
end) end,
},
{"北岸木头",
function() enqueueTask(function()
HK()
HE()
xg1(-180,16,-8,true)--y
xg1(11391.460,16,-4,true)
xg1(9863,16,-12,true)
gg.sleep(100)
xg1(-180,16,-8,cssfdj)--y
xg1(11391.460,16,-4,cssfdj)
xg1(9863,16,-12,cssfdj)
end) end,
},
}),
RG.buts({
{"天鹤山房子",
function() enqueueTask(function()
HK()
HE()
xg1(1300,16,-8,true)--y
xg1(5651.46,16,-4,true)
xg1(204,16,-12,true)
gg.sleep(100)
xg1(1300,16,-8,cssfdj)--y
xg1(5651.46,16,-4,cssfdj)
xg1(204,16,-12,cssfdj)
end) end,
}, 
{"可汗中心",
function() enqueueTask(function()
HK()
HE()
xg1(700,16,-8,true)--y
xg1(-11733,16,-4,true)
xg1(-10492,16,-12,true)
gg.sleep(100)
xg1(700,16,-8,cssfdj)--y
xg1(-11733,16,-4,cssfdj)
xg1(-10492,16,-12,cssfdj)
end) end,
},
{"地龟山石头",
function() enqueueTask(function()
HK()
HE()
xg1(560,16,-8,true)--y
xg1(-4983.4606,16,-4,true)
xg1(-6715,16,-12,true)
gg.sleep(100)
xg1(560,16,-8,cssfdj)--y
xg1(-4983.4606,16,-4,cssfdj)
xg1(-6715,16,-12,cssfdj)
end) end,
}, 
}),
}), 
RG.box({"单人风暴",
RG.buts({
{"中心枢纽",
function() enqueueTask(function()
HK()
HE()
xg1(3031,16,-8,true)
xg1(791,16,-4,true)
xg1(-297,16,-12,true)
gg.sleep(100)
xg1(3031,16,-8,cssfdj)
xg1(791,16,-4,cssfdj)
xg1(-297,16,-12,cssfdj)
end) end,
},
{"灰色工厂",
function() enqueueTask(function()
HK()
HE()
xg1(999,16,-8,true)
xg1(-5324,16,-4,true)
xg1(-1950,16,-12,true)
gg.sleep(100)
xg1(999,16,-8,cssfdj)
xg1(-5324,16,-4,cssfdj)
xg1(-1950,16,-12,cssfdj)
end) end,
},
{"守望台",
function() enqueueTask(function()
HK()
HE()
xg1(1594,16,-8,true)
xg1(-5739,16,-4,true)
xg1(2004,16,-12,true)
gg.sleep(100)
xg1(1594,16,-8,cssfdj)
xg1(-5739,16,-4,cssfdj)
xg1(2004,16,-12,cssfdj)
end) end,
},
}),
RG.buts({
{"零号仓库",
function() enqueueTask(function()
HK()
HE()
xg1(35,16,-8,true)
xg1(6712,16,-4,true)
xg1(-5863,16,-12,true)
gg.sleep(100)
xg1(35,16,-8,cssfdj)
xg1(6712,16,-4,cssfdj)
xg1(-5863,16,-12,cssfdj)
end) end,
},
{"小试验场",
function() enqueueTask(function()
HK()
HE()
xg1(575,16,-8,true)--y
xg1(-4525.46063,16,-4,true)
xg1(-2259,16,-12,true)
gg.sleep(100)
xg1(575,16,-8,cssfdj)--y
xg1(-4525.46063,16,-4,cssfdj)
xg1(-2259,16,-12,cssfdj)
end) end,
},
{"灰工集装箱",
function() enqueueTask(function()
HK()
HE()
xg1(102,16,-8,true)--y
xg1(-2474.4606,16,-4,true)
xg1(-6128,16,-12,true)
gg.sleep(100)
xg1(102,16,-8,cssfdj)--y
xg1(-2474.4606,16,-4,cssfdj)
xg1(-6128,16,-12,cssfdj)
end) end,
},
})
}),
RG.box({"乱斗",
RG.buts({
{"空投点1",
function() enqueueTask(function()
HK()
HE()
xg1(5799,16,-8,true)--y
xg1(2932.199,16,-4,true)
xg1(-4221,16,-12,true)
gg.sleep(100)
xg1(799,16,-8,cssfdj)--y
xg1(2932.199,16,-4,cssfdj)
xg1(-4221,16,-12,cssfdj)
end) end,
},
{"空投点2",
function() enqueueTask(function()
HK()
HE()
xg1(5500,16,-8,true)--y
xg1(-5937.941,16,-4,true)
xg1(3917,16,-12,true)
gg.sleep(100)
xg1(1500,16,-8,cssfdj)--y
xg1(-5937.941,16,-4,cssfdj)
xg1(3917,16,-12,cssfdj)
end) end,
},
})
}),
RG.box({"单点占领",
RG.buts({
{"远征进点(上)",
function() enqueueTask(function()
HK()
HE()
xg1(10,16,-8,true)--y
xg1(511,16,-4,true)--z
xg1(-1599,16,-12,true)--x
gg.sleep(100)
xg1(10,16,-8,cssfdj)--y
xg1(511,16,-4,cssfdj)--z
xg1(-1599,16,-12,cssfdj)--x
end) end,
},
{"远征进点(下)",
function() enqueueTask(function()
HK()
HE()
xg1(10,16,-8,true)--y
xg1(-401.941,16,-4,true)--z
xg1(-1599,16,-12,true)--x
gg.sleep(100)
xg1(10,16,-8,cssfdj)--y
xg1(-401.941,16,-4,cssfdj)--z
xg1(-1599,16,-12,cssfdj)--x
end) end,
},
{"远征进点(特殊位1)",
function() enqueueTask(function()
HK()
HE()
xg1(-50,16,-8,true)--y
xg1(49,16,-4,true)--z
xg1(-1596,16,-12,true)--x
gg.sleep(100)
xg1(-50,16,-8,cssfdj)--y
xg1(49,16,-4,cssfdj)--z
xg1(-1596,16,-12,cssfdj)--x
end) end,
},
{"远征进点(特殊位2)",
function() enqueueTask(function()
HK()
HE()
xg1(50,16,-8,true)--y
xg1(49,16,-4,true)--z
xg1(-1596,16,-12,true)--x
gg.sleep(100)
xg1(50,16,-8,cssfdj)--y
xg1(49,16,-4,cssfdj)--z
xg1(-1596,16,-12,cssfdj)--x
end) end,
},
{"远征高台1",
function() enqueueTask(function()
HK()
HE()
xg1(633,16,-8,true)--y
xg1(-254,16,-4,true)
xg1(-603,16,-12,true)
gg.sleep(100)
xg1(633,16,-8,cssfdj)--y
xg1(-254,16,-4,cssfdj)
xg1(-603,16,-12,cssfdj)
end) end,
},
{"远征高台2",
function() enqueueTask(function()
HK()
HE()
xg1(509,16,-8,true)--y
xg1(0.75161904,16,-4,true)--z
xg1(-3474,16,-12,true)--x
gg.sleep(100)
xg1(509,16,-8,cssfdj)--y
xg1(0.75161904,16,-4,cssfdj)--z
xg1(-3474,16,-12,cssfdj)--x
end) end,
},
}),
RG.buts({
{"红石进点",function() enqueueTask(function()
HK()
HE()
xg1(-198,16,-8,true)--y
xg1(-1188,16,-4,true)--z
xg1(-800,16,-12,true)--x
gg.sleep(100)
xg1(-198,16,-8,cssfdj)--y
xg1(-1188,16,-4,cssfdj)--z
xg1(-800,16,-12,cssfdj)--x
end) end,
},
{"红石进点(特殊位)",function() enqueueTask(function()
HK()
HE()
xg1(-248,16,-8,true)--y
xg1(-1563,16,-4,true)--z
xg1(-796,16,-12,true)--x
gg.sleep(100)
xg1(-248,16,-8,cssfdj)--y
xg1(-1563,16,-4,cssfdj)--z
xg1(-796,16,-12,cssfdj)--x
end) end,
},
{"红石高台1",
function() enqueueTask(function()
HK()
HE()
xg1(1394,16,-8,true)--y
xg1(218,16,-4,true)
xg1(3164,16,-12,true)
gg.sleep(100)
xg1(1394,16,-8,cssfdj)--y
xg1(218,16,-4,cssfdj)
xg1(3164,16,-12,cssfdj)
end) end,
},
{"红石高台2",
function() enqueueTask(function()
HK()
HE()
xg1(690,16,-8,true)--y
xg1(614,16,-4,true)
xg1(-808,16,-12,true)
gg.sleep(100)
xg1(690,16,-8,cssfdj)--y
xg1(614,16,-4,cssfdj)
xg1(-808,16,-12,cssfdj)
end) end,
},
{"红石高台3",
function() enqueueTask(function()
HK()
HE()
xg1(1030,16,-8,true)--y
xg1(1174,16,-4,true)
xg1(-1337,16,-12,true)
gg.sleep(100)
xg1(1030,16,-8,cssfdj)--y
xg1(1174,16,-4,cssfdj)
xg1(-1337,16,-12,cssfdj)
end) end,
},
{"红石高台4",
function() enqueueTask(function()
HK()
HE()
xg1(470,16,-8,true)--y
xg1(77.41,16,-4,true)
xg1(-1738,16,-12,true)
gg.sleep(100)
xg1(470,16,-8,cssfdj)--y
xg1(77.41,16,-4,cssfdj)
xg1(-1738,16,-12,cssfdj)
end) end,
},
}), 
RG.buts({
{"盖亚进点(上)",
function() enqueueTask(function()
HK()
HE()
xg1(55,16,-8,true)--y
xg1(-149,16,-4,true)--z
xg1(-1189,16,-12,true)--x
gg.sleep(100)
xg1(55,16,-8,cssfdj)--y
xg1(-149,16,-4,cssfdj)--z
xg1(-1189,16,-12,cssfdj)--x
end) end,
},
{"盖亚进点(下)",
function() enqueueTask(function()
HK()
HE()
xg1(55,16,-8,true)--y
xg1(-482.941,16,-4,true)--z
xg1(-1189,16,-12,true)--x
gg.sleep(100)
xg1(55,16,-8,cssfdj)--y
xg1(-482,16,-4,cssfdj)--z
xg1(-1189,16,-12,cssfdj)--x
end) end,
},
{"盖亚进点(特殊位)",
function() enqueueTask(function()
HK()
HE()
xg1(10,16,-8,true)--y
xg1(-315,16,-4,true)--z
xg1(-1190,16,-12,true)--x
gg.sleep(100)
xg1(10,16,-8,cssfdj)--y
xg1(-315,16,-4,cssfdj)--z
xg1(-1189,16,-12,cssfdj)--x
end) end,
},
{"盖亚进点(解体位1)",
function() enqueueTask(function()
HK()
HE()
xg1(430,16,-8,true)--y
xg1(-315,16,-4,true)--z
xg1(-1189,16,-12,true)--x
gg.sleep(100)
xg1(430,16,-8,cssfdj)--y
xg1(-315,16,-4,cssfdj)--z
xg1(-1189,16,-12,cssfdj)--x
end) end,
},
{"盖亚进点(解体位2)",
function() enqueueTask(function()
HK()
HE()
xg1(400,16,-8,true)--y
xg1(-315,16,-4,true)--z
xg1(-1189,16,-12,true)--x
gg.sleep(100)
xg1(400,16,-8,cssfdj)--y
xg1(-315,16,-4,cssfdj)--z
xg1(-1189,16,-12,cssfdj)--x
end) end,
},
{"盖亚高台1",
function() enqueueTask(function()
HK()
HE()
xg1(390,16,-8,true)--y
xg1(-235.941,16,-4,true)
xg1(-2510,16,-12,true)
gg.sleep(100)
xg1(390,16,-8,cssfdj)--y
xg1(-235.941,16,-4,cssfdj)
xg1(-2510,16,-12,cssfdj)
end) end,
},
{"盖亚高台2",
function() enqueueTask(function()
HK()
HE()
xg1(1400,16,-8,true)--y
xg1(5651.46,16,-4,true)
xg1(204,16,-12,true)
gg.sleep(100)
xg1(1400,16,-8,cssfdj)--y
xg1(5651.46,16,-4,cssfdj)
xg1(204,16,-12,cssfdj)
end) end,
},
})
}), 
RG.box({"多点占领",
RG.buts({
{"暗黑星云进点1",
function() enqueueTask(function()
HK()
HE()
xg1(5745,16,-8,true)--y
xg1(-303,16,-4,true)
xg1(-239,16,-12,true)
gg.sleep(100)
xg1(5745,16,-8,cssfdj)--y
xg1(-303,16,-4,cssfdj)
xg1(-239,16,-12,cssfdj)
end) end,
},
{"暗黑星云进点2",
function() enqueueTask(function()
HK()
HE()
xg1(8018,16,-8,true)--y
xg1(7150,16,-4,true)
xg1(-255,16,-12,true)
gg.sleep(100)
xg1(8018,16,-8,cssfdj)--y
xg1(7150,16,-4,cssfdj)
xg1(-255,16,-12,cssfdj)
end) end,
},
{"暗黑星云辅助位",
function() enqueueTask(function()
HK()
HE()
xg1(4073,16,-8,true)--y
xg1(10309,16,-4,true)
xg1(-16878,16,-12,true)
gg.sleep(100)
xg1(4073,16,-8,cssfdj)--y
xg1(10309,16,-4,cssfdj)
xg1(-16878,16,-12,cssfdj)
end) end,
},
}),
RG.buts({
{"陨星基地进点1",
function() enqueueTask(function()
HK()
HE()
xg1(1000,16,-8,true)--y
xg1(-1404,16,-4,true)
xg1(1389,16,-12,true)
gg.sleep(100)
xg1(1000,16,-8,cssfdj)--y
xg1(-1404,16,-4,cssfdj)
xg1(1389,16,-12,cssfdj)
end) end,
},
{"陨星基地进点2",
function() enqueueTask(function()
HK()
HE()
xg1(100,16,-8,true)--y
xg1(1626,16,-4,true)
xg1(2071,16,-12,true)
gg.sleep(100)
xg1(100,16,-8,cssfdj)--y
xg1(1626,16,-4,cssfdj)
xg1(2071,16,-12,cssfdj)
end) end,
},
{"陨星基地进点3",
function() enqueueTask(function()
HK()
HE()
xg1(202,16,-8,true)--y
xg1(234,16,-4,true)
xg1(-2906,16,-12,true)
gg.sleep(100)
xg1(202,16,-8,cssfdj)--y
xg1(234,16,-4,cssfdj)
xg1(-2906,16,-12,cssfdj)
end) end,
},
}),
RG.buts({
{"乐园进点1",
function() enqueueTask(function()
HK()
HE()
xg1(190,16,-8,true)--y
xg1(103,16,-4,true)
xg1(-1509,16,-12,true)
gg.sleep(100)
xg1(190,16,-8,cssfdj)--y
xg1(103,16,-4,cssfdj)
xg1(-1509,16,-12,cssfdj)
end) end,
},
{"乐园进点2",
function() enqueueTask(function()
HK()
HE()
xg1(99,16,-8,true)--y
xg1(2116,16,-4,true)
xg1(281,16,-12,true)
gg.sleep(100)
xg1(99,16,-8,cssfdj)--y
xg1(2116,16,-4,cssfdj)
xg1(281,16,-12,cssfdj)
end) end,
},
{"乐园进点3",
function() enqueueTask(function()
HK()
HE()
xg1(98,16,-8,true)--y
xg1(-2125,16,-4,true)
xg1(1834,16,-12,true)
gg.sleep(100)
xg1(98,16,-8,cssfdj)--y
xg1(-2125,16,-4,cssfdj)
xg1(1834,16,-12,cssfdj)
end) end,
},
})
}),
RG.box({"无限擂台",
RG.buts({
{"中心",
function() enqueueTask(function()
HK()
HE()
xg1(5130,16,-8,true)--y
xg1(28,16,-4,true)
xg1(227,16,-12,true)
gg.sleep(100)
xg1(130,16,-8,cssfdj)--y
xg1(28,16,-4,cssfdj)
xg1(227,16,-12,cssfdj)
end) end,
},
{"高台1",
function() enqueueTask(function()
HK()
HE()
xg1(5803,16,-8,true)--y
xg1(-2245.1,16,-4,true)
xg1(272,16,-12,true)
gg.sleep(100)
xg1(803,16,-8,cssfdj)--y
xg1(-2245.1,16,-4,cssfdj)
xg1(272,16,-12,cssfdj)
end) end,
},
{"高台2",
function() enqueueTask(function()
HK()
HE()
xg1(5803,16,-8,true)--y
xg1(1185,16,-4,true)
xg1(-1718,16,-12,true)
gg.sleep(100)
xg1(803,16,-8,cssfdj)--y
xg1(1185,16,-4,cssfdj)
xg1(-1718,16,-12,cssfdj)
end) end,
}, 
}),
RG.buts({
{"高台3",
function() enqueueTask(function()
HK()
HE()
xg1(5400,16,-8,true)--y
xg1(5651.46,16,-4,true)
xg1(204,16,-12,true)
gg.sleep(100)
xg1(803,16,-8,cssfdj)--y
xg1(1169,16,-4,cssfdj)
xg1(2253,16,-12,cssfdj)
end) end,
},
{ "地下小空间",
function() enqueueTask(function()
HK()
HE()
xg1(5095.5,16,-8,true)--y
xg1(-1452.46,16,-4,true)
xg1(1185,16,-12,true)
gg.sleep(100)
xg1(-45.5,16,-8,cssfdj)--y
xg1(-1452.46,16,-4,cssfdj)
xg1(1185,16,-12,cssfdj)
end) end,
},
{"柱子里",
function() enqueueTask(function()
HK()
HE()
xg1(10,16,-8,true)--y
xg1(547,16,-4,true)
xg1(-616,16,-12,true)
gg.sleep(100)
xg1(10,16,-8,cssfdj)--y
xg1(547,16,-4,cssfdj)
xg1(-616,16,-12,cssfdj)
end) end,
},
}),
RG.buts({
{"斜坡旁(建议解体",
function() enqueueTask(function()
HK()
HE()
xg1(-90,16,-8,true)--y
xg1(1028,16,-4,true)
xg1(789,16,-12,true)
gg.sleep(100)
xg1(-90,16,-8,cssfdj)--y
xg1(1028,16,-4,cssfdj)
xg1(789,16,-12,cssfdj)
end) end,
},
})
}),
RG.box({"试验场",
RG.buts({
{"雷达",
function() enqueueTask(function()
HK()
HE()
xg1(11546,16,-8,true)
xg1(1649.94140625,16,-4,true)
xg1(-3236.765625,16,-12,true)
gg.sleep(100)
xg1(1546,16,-8,cssfdj)
xg1(1649.94140625,16,-4,cssfdj)
xg1(-3236.765625,16,-12,cssfdj)
end) end,
},
{"车库",
function() enqueueTask(function()
HK()
HE()
xg1(5000,16,-8,true)--y
xg1(2280,16,-4,true)
xg1(-4875,16,-12,true)
gg.sleep(100)
xg1(-50,16,-8,cssfdj)--y
xg1(2280,16,-4,cssfdj)
xg1(-4875,16,-12,cssfdj)
end) end,
},
{"禁闭小屋",
function() enqueueTask(function()
HK()
HE()
xg1(5427,16,-8,true)
xg1(986.94140625,16,-4,true)
xg1(-2060.765625,16,-12,true)
gg.sleep(100)
xg1(427,16,-8,cssfdj)
xg1(986.94140625,16,-4,cssfdj)
xg1(-2060.765625,16,-12,cssfdj)
end) end,
},
}),
RG.buts({
{"雷达旁",
function() enqueueTask(function()
HK()
HE()
xg1(5210,16,-8,true)--y
xg1(426,16,-4,true)
xg1(-2630,16,-12,true)
gg.sleep(100)
xg1(1210,16,-8,cssfdj)--y
xg1(426,16,-4,cssfdj)
xg1(-2630,16,-12,cssfdj)
end) end,
},
{"发射仓",
function() enqueueTask(function()
HK()
HE()
xg1(6220,16,-8,true)--y
xg1(-4458,16,-4,true)
xg1(-825,16,-12,true)
gg.sleep(100)
xg1(220,16,-8,cssfdj)--y
xg1(-4458,16,-4,cssfdj)
xg1(-825,16,-12,cssfdj)
end) end,
},
{"大圆环",
function() enqueueTask(function()
HK()
HE()
xg1(6578,16,-8,true)--y
xg1(-2255,16,-4,true)
xg1(2614,16,-12,true)
gg.sleep(100)
xg1(578,16,-8,cssfdj)--y
xg1(-2255,16,-4,cssfdj)
xg1(2614,16,-12,cssfdj)
end) end,
},
}),
RG.buts({
{"猫爬架",
function() enqueueTask(function()
HK()
HE()
xg1(5448.6,16,-8,true)--y
xg1(-2007,16,-4,true)
xg1(1435,16,-12,true)
gg.sleep(100)
xg1(448.6,16,-8,cssfdj)--y
xg1(-2007,16,-4,cssfdj)
xg1(1435,16,-12,cssfdj)
end) end,
},
{"地图右上角斜坡",
function() enqueueTask(function()
HK()
HE()
xg1(5000,16,-8,true)--y
xg1(1156,16,-4,true)--z
xg1(1357,16,-12,true)--x
gg.sleep(100)
xg1(3,16,-8,cssfdj)--y
xg1(1156,16,-4,cssfdj)
xg1(1357,16,-12,cssfdj)
end) end,
}, 
})
}),
RG.check({"注意:进入游戏约7秒后传送才可以使用"}), 
RG.box1({"教程模式", 
RG.box({"模块试炼新手教程",
RG.buts({
{"基础操作",
function() enqueueTask(function()
HK()
HE()
xg1(-2557,16,-12,false)
xg1(100,16,-8,false)
xg1(2038,16,-4,false)
gg.sleep(100)
xg1(-2024,16,-12,false)
xg1(100,16,-8,false)
xg1(1518,16,-4,false)
gg.sleep(100)
xg1(-2582,16,-12,false)
xg1(100,16,-8,false)
xg1(1039,16,-4,false)
end) end,
},
{"删除模块",
function() enqueueTask(function()
HK()
HE()
xg1(-880,16,-12,false)
xg1(100,16,-8,false)
xg1(46,16,-4,false)
gg.sleep(100)
xg1(-903,16,-12,false)
xg1(110,16,-8,false)
xg1(385,16,-4,false)
end) end,
},
{"旋转模块",
function() enqueueTask(function()
HK()
HE()
xg1(136,16,-12,false)
xg1(-113,16,-8,false)
xg1(1217,16,-4,false)
end) end,
},
}),
RG.buts({
{"腾跃",
function() enqueueTask(function()
HK()
HE()
xg1(139,16,-12,false)
xg1(100,16,-8,false)
xg1(345,16,-4,false)
gg.sleep(100)
xg1(117,16,-12,false)
xg1(100,16,-8,false)
xg1(-250,16,-4,false)
end) end,
},
{"无形魅影",
function() enqueueTask(function()
HK()
HE()
xg1(-2659,16,-12,false)
xg1(100,16,-8,false)
xg1(870,16,-4,false)
end) end,
},
{"海王盾",
function() enqueueTask(function()
HK()
HE()
xg1(-2035,16,-12,false)
xg1(100,16,-8,false)
xg1(1509,16,-4,false)
gg.sleep(100)
xg1(-2571,16,-12,false)
xg1(100,16,-8,false)
xg1(2026,16,-4,false)
gg.sleep(100)
xg1(-1996,16,-12,false)
xg1(100,16,-8,false)
xg1(2636,16,-4,false)
end) end,
},
}),
RG.buts({
{"大力神",
function() enqueueTask(function()
HK()
HE()
xg1(137,16,-12,false)
xg1(21,16,-8,false)
xg1(350,16,-4,false)
gg.sleep(100)
xg1(137,16,-12,false)
xg1(-10,16,-8,false)
xg1(690,16,-4,false)
gg.sleep(100)
xg1(137,16,-12,false)
xg1(-50,16,-8,false)
xg1(1033,16,-4,false)
end) end,
},
{"鹰驰",
function() enqueueTask(function()
HK()
HE()
xg1(201,16,-12,false)
xg1(100,16,-8,false)
xg1(-1425,16,-4,false)
end) end,
}, 
})
}),
RG.box({"建造模式新手教程",
RG.buts({
{"建造规则",
function() enqueueTask(function()
HK()
HE()
xg1(4,16,-8,false)--y
xg1(752.199,16,-4,false)
xg1(-102,16,-12,false)
gg.sleep(100)
xg1(4,16,-8,false)--y
xg1(752.199,16,-4,false)
xg1(-102,16,-12,false)
gg.sleep(100)
xg1(244,16,-8,true)--y
xg1(2509,16,-4,true)
xg1(-109,16,-12,true)
gg.sleep(100)
xg1(244,16,-8,false)--y
xg1(2509,16,-4,false)
xg1(-109,16,-12,false)
end) end,
},
{"摧毁规则",
function() enqueueTask(function()
HK()
HE()
xg1(8,16,-8,true)--y
xg1(-867.941,16,-4,true)
xg1(-112,16,-12,true)
gg.sleep(100)
xg1(8,16,-8,true)--y
xg1(-867.941,16,-4,true)
xg1(-112,16,-12,true)
gg.sleep(100)
xg1(5,16,-8,false)--y
xg1(727,16,-4,false)
xg1(-106,16,-12,false)
gg.sleep(100)
xg1(5,16,-8,false)--y
xg1(727,16,-4,false)
xg1(-106,16,-12,false)
end) end,
},
})
}),
RG.box({"占点模式新手教程",
RG.buts({
{"快速进点",
function() enqueueTask(function()
HK()
HE()
xg1(-13,16,-8,false)--y
xg1(-14.199,16,-4,false)
xg1(-1652,16,-12,false)
gg.sleep(100)
xg1(-13,16,-8,false)--y
xg1(-14.199,16,-4,false)
xg1(-1652,16,-12,false)
end) end
},
})
}) 
}),
},
{--3
RG.box({"设置重力",---box示例 可以删掉
RG.button("自身反重力plus",
function() enqueueTask(function()
HK()
search(17039360,4,neicun)
py1(17039360,4,416)
xg1(-100,16,48,true)
end) end), 
RG.button("自身反重力",
function() enqueueTask(function()
HK()
search(17039360,4,neicun)
py1(17039360,4,416)
xg1(-3,16,48,true)
end) end),
RG.button("自身无重力",
function() enqueueTask(function()
HK()
search(17039360,4,neicun)
py1(17039360,4,416)
xg1(0,16,48,true)
end) end),
RG.button("自身无重力②",
function() enqueueTask(function()
HK()
wuzhongli(1, 0)
end) end),
RG.button("自身高重力",
function() enqueueTask(function()
HK()
search(17039360,4,neicun)
py1(17039360,4,416)
xg1(3,16,48,true)
end) end), 
RG.button("自身高重力plus",
function() enqueueTask(function()
HK()
search(17039360,4,neicun)
py1(17039360,4,416)
xg1(100,16,48,true)
end) end), 
RG.button("自定义重力",
function() enqueueTask(function()
HK()
search(17039360,4,neicun)
py1(17039360,4,416)
xg3(nil,16,48,true,"(自定义重力)")
end) end),
RG.button("自定义重力②",
function() enqueueTask(function()
HK()
wuzhongli(1, 1)
end) end),
RG.button("恢复重力",
function() enqueueTask(function()
HK()
wuzhongli(0)
search(17039360,4,neicun)
py1(17039360,4,416)
xg1(1,16,48,false)
end) end),
}),
RG.line(), 
RG.box({"设置视角(硬核",---box示例 可以删掉
RG.button("极广角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(-10000, 16, 0, true)
end
end) end),
RG.button("超广角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(-6000.114514, 16, 0, true)
end
end) end),
RG.button("广角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(-4000, 16, 0, true)
end
end) end),
RG.button("微广角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(-400, 16, 0, true)
end
end) end),
RG.button("近角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(60, 16, 0, true)
end
end) end),
RG.button("超近角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(100, 16, 0, true)
end
end) end),
RG.button("核心视角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(80, 16, 0, true)
end
end) end),
RG.button("自定义视角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg3(nil, 16, 0, true, "(自定义视角)")
end
end) end),
RG.button("自定义视角(广角)", function() enqueueTask(function()
HK()
if SetSjWithOffset(-92) then
xg3(nil, 16, 0, true, "(自定义视角[广角])")
end
end) end),
RG.button("自定义视角(旧)", function() enqueueTask(function()
HK()
if SetSjWithOffset(-40) then
xg3(nil, 16, 0, true, "(自定义视角(旧))")
end
end) end),
RG.button("恢复视角", function() enqueueTask(function()
HK()
local any = false
if SetSjWithOffset(-140) then
xg1(0, 16, 0, false)
any = true
end
if SetSjWithOffset(-92) then
xg1(1, 16, 0, false)
any = true
end
if SetSjWithOffset(-40) then
xg1(1, 16, 0, false)
any = true
end
if any then
_VisionBase = nil
_VisionOrig = {}
提示("视角已恢复，缓存已清除")
return
end
search("-1.2566370964050293", 16, neicun)
xg1(0, 16, -140, true)
xg1(1, 16, -92, true)
xg1(1, 16, -40, true)
gg.sleep(100)
xg1(0, 16, -140, false)
xg1(1, 16, -92, false)
xg1(1, 16, -40, false)
end) end),
}),
RG.line(),
RG.box({"设置光照", 
RG.button("爆亮",
function() enqueueTask(function()
HK()
gz='999.96355'
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-1", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-1",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.editAll("999.96355", FLOAT)
提示("开启成功")
gg.clearResults()
end
 

--爆亮")
end) end),
 RG.button("明亮",
function() enqueueTask(function()

HK()

gz='1899.96355'
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-1", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-1",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.editAll("1899.96355", FLOAT)
提示("开启成功")
gg.clearResults()
end
 

--明亮")
end) end), 
RG.button("阴暗",
function() enqueueTask(function()

HK()

gz='-1899.96355'
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-1", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-1",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100000)--设置修改前200个代码
gg.editAll("-1899.96355", FLOAT)
提示("开启成功")
gg.clearResults()
end
 

--阴暗")
end) end),
RG.button("黑暗",
function() enqueueTask(function()

HK()

gz='-999.96355'
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-1", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-1",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100000)--设置修改前200个代码
gg.editAll("-999.96355", FLOAT)
提示("开启成功")
gg.clearResults()
end
 

--黑暗")
end) end),

RG.button("恢复光照",
function() enqueueTask(function()

HK()

提示("正在恢复")
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber(gz,FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(12100)--修改前1200个代码
gg.editAll("-1", FLOAT)
提示("恢复完成")
 

--恢复光照")
end) end),

}),
RG.line(),
RG.box({"设置透视",
RG.button("地面透视",
function() enqueueTask(function()

HK()
 
toushi='31,165,001,600'
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('31,138,512,896',gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber('', gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,165,001,600',gg.TYPE_QWORD)
提示("开启成功")

--地面透视")
end) end),
RG.button("地面透视 Pro",
function() enqueueTask(function()

HK()
 
toushi='31,215,001,600'
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('31,138,512,896',gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber('', gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,215,001,600',gg.TYPE_QWORD)
提示("开启成功")

--地面透视 Pro")
end) end),
RG.button("全透视",
function() enqueueTask(function()

HK()
 
toushi='31,215,001,900'
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('31,138,512,896',gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber('', gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,215,001,900',gg.TYPE_QWORD)
提示("开启成功")


end) end),
RG.button("透视+特效增大",
function() enqueueTask(function()

HK()
 
toushi='31,200,030,000'
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('31,138,512,896',gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber('', gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,200,030,000',gg.TYPE_QWORD)
提示("开启成功")


end) end),
RG.button("恢复透视",
function() enqueueTask(function()
HK()
提示("正在恢复") 
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber(toushi,gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,138,512,896',gg.TYPE_QWORD)
提示("恢复完成")
end) end),
}),
RG.line(),
RG.box({'天罚功能',
RG.button("天罚加速",
function() enqueueTask(function()
HK()
提示("请使用天罚并保证视角在天罚上")
search(17039620,4,neicun)
py1(16777215,4,-36)
py1(259,4,-32)
py1(17039620,4,0)
xg1(-0.8,16,76,true)
end) end),
RG.button("天罚减速",
function() enqueueTask(function()
HK()
提示("请使用天罚并保证视角在天罚上")
search(17039620,4,neicun)
py1(16777215,4,-36)
py1(259,4,-32)
py1(17039620,4,0)
xg1(1,16,76,true)
end) end),
RG.button("天罚无速度",
function() enqueueTask(function()
HK()
提示("请使用天罚并保证视角在天罚上")
search(17039620,4,neicun)
py1(16777215,4,-36)
py1(259,4,-32)
py1(17039620,4,0)
xg1(100,16,76,true)
end) end),
RG.button("天罚龟速",
function() enqueueTask(function()
HK()
提示("请使用天罚并保证视角在天罚上")
search(17039620,4,neicun)
py1(16777215,4,-36)
py1(259,4,-32)
py1(17039620,4,0)
xg1(1.65,16,76,true)
end) end),
RG.button("天罚瞬速",
function() enqueueTask(function()
HK()
提示("请使用天罚并保证视角在天罚上")
search(17039620,4,neicun)
py1(16777215,4,-36)
py1(259,4,-32)
py1(17039620,4,0)
xg1(-15,16,76,true)
end) end),
RG.button("自定义天罚速度",
function() enqueueTask(function()
HK()
提示("请使用天罚并保证视角在天罚上")
search(17039620,4,neicun)
py1(16777215,4,-36)
py1(259,4,-32)
py1(17039620,4,0)
xg3(nil,16,76,true,"(自定义天罚速度)")
end) end),
RG.button("天罚旋转",
function() enqueueTask(function()
HK()
提示("请使用天罚并保证视角在天罚上")
search(17039620,4,neicun)
py1(16777215,4,-36)
py1(259,4,-32)
py1(17039620,4,0)
xg1(999,16,56,true)
end) end
),
RG.button("天罚传送至高空",
function() enqueueTask(function()
HK()
提示("请使用天罚并保证视角在天罚上")
search(17039620,4,neicun)
py1(16777215,4,-36)
py1(259,4,-32)
py1(17039620,4,0)
xg1(3200,16,-8,false)
end) end
),
RG.button("恢复",
function() enqueueTask(function()
HK()
search(17039620,4,neicun)
py1(16777215,4,-36)
py1(259,4,-32)
py1(17039620,4,0)
xg1(0.0,16,56,false)
xg1(0.0,16,76,false)
end) end
),
}),
RG.line(),
RG.box({"设置核心跳跃高度",
RG.button("15 (极高",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(15,16,96,true)
end) end),
RG.button("10 (高",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(10,16,96,true)
end) end),
RG.button("5 (略高",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5,16,96,true)
end) end),
RG.button("1 (正常",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(1,16,96,true)
end) end),
RG.button("0.5 (低",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(0.5,16,96,true)
end) end),
RG.button("0.1 (极低",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(0.1,16,96,true)
end) end),
RG.button("自定义跳跃高度",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(nil,16,96,true,"(自定义跳跃高度)")
end) end),
RG.button("自定义跳跃高度②",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(1000593162,4,-4)
py1(992204554,4,0)
py1(1956496814,4,8)
xg3(3,16,4,true,"(自定义跳跃高度②)")
end) end),
RG.button("恢复跳跃高度",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(0.007352941203862429,16,96,false)
gg.sleep(100)
xg1(1,16,96,false)
search(992204554,4,neicun)
py1(1000593162,4,-4)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(0.007352941203862429,16,4,false)
gg.sleep(100)
xg1(1,16,4,false)
end) end),
}), 
RG.line(),
RG.box({"设置拖拽感",---box示例 可以删掉
RG.button("极大",
function() enqueueTask(function()

HK()

search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(899.62,16,184,true)

 


end) end),
RG.button("大",
function() enqueueTask(function()

HK()

search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(399.62,16,184,true)

 


end) end),
RG.button("反方向",
function() enqueueTask(function()

HK()

search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(-599.62,16,184,true)

 


end) end),
RG.button("固定位置",
function() enqueueTask(function()

HK()

search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(9399.62,16,184,true)

 


end) end),
RG.button("自定义拖拽",
function() enqueueTask(function()

HK()

search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(nil,16,184,true,"(自定义拖动)")
end) end),
RG.button("恢复",
function() enqueueTask(function()

HK()

search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(0,16,184,false)

 


end) end),
}), 
RG.line(),
RG.box({"音效延迟(不可恢复",---box示例 可以删掉
RG.button("10秒",
function() enqueueTask(function()

HK()


gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("0.01999999955", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("0.01999999955", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("10.114514", gg.TYPE_FLOAT)
提示("音效延迟")
gg.clearResults()



end) end),
RG.button("5秒",
function() enqueueTask(function()

HK()

 
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("0.01999999955", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("0.01999999955", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("5.114514", gg.TYPE_FLOAT)
提示("音效延迟")
gg.clearResults()
end) end),
RG.button("2秒",
function() enqueueTask(function()

HK()

 
gg.clearResults()
 gg.setRanges(neicun)
 gg.searchNumber("0.01999999955", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
 gg.searchNumber("0.01999999955", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
 gg.getResults(99999)
 gg.editAll("3.114514", gg.TYPE_FLOAT)
 提示("音效延迟")
 gg.clearResults()
end) end),
}), 
RG.line(),
RG.box({"需解体功能",---box示例 可以删掉
RG.button("翻滚",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(99,16,-40,true)
end) end),
RG.button("发癫",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(55,16,0,true)
end) end),
RG.button("转向Q弹",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(0,16,100,true)
end) end), 
RG.button("全图隐身",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(-114514,4,92,true)
xg1(-114514,4,84,true)
end) end),
RG.button("全图隐身(自定义)",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg3(nil,4,92,true,"(自定义全图隐身)")
xg4(nil,4,84,true)
end) end),
RG.button("隐身刀人(自定义)",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg3(-114514,4,92,true,true,"(自定义全图隐身)")
xg4(nil,4,84,true)
gg.sleep(100)
xg3(-55,4,100,true,true,"(刀人范围)")
end) end),
RG.button("隐身刀人",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(-114514,4,92,true)
xg1(-114514,4,84,true)
gg.sleep(1)
xg1(-55,4,100,true)
end) end),
RG.button("随机刀人范围",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
local random_value = math.random(-114564,-50)
xg1(random_value,11,100,true)
gg.sleep(1000)
提示("已设置随机刀人值: " .. random_value)
end) end),
RG.button("常用刀人范围",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
local random_value = math.random(-10000, -50)
xg1(random_value,11,100,true)
gg.sleep(1000)
提示("已设置随机刀人值: " .. random_value)
end) end),
RG.button("自定义刀人范围",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg3(-55,11,100,true,true,"(刀人范围)")
end) end),
RG.button("自定义刀人范围②",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg3(-55,4,100,true,true,"(刀人范围)")
end) end),
RG.button("全局离线",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(-10,4,92,true)
xg1(-10,4,84,true)
end) end),
RG.button("全局离线Pro",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(-25,11,100,true)
end) end),
RG.button("磁悬浮核心",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(0,16,92,true)
xg1(0,16,84,true)
end) end),
RG.button("恢复以上功能",
function() enqueueTask(function()
HK()
search(992204554,4,neicun)
py1(992204554,4,0)
py1(1956496814,4,8)
xg1(1,11,100,false)
xg1(1,16,100,false)
xg1(1,4,100,false)
xg1(1,4,92,false)
xg1(1,4,84,false)
xg1(1,16,0,false)
xg1(1,16,-40,false)
end) end),
}),
RG.line(),
RG.box({"地图功能",---box示例 可以删掉
RG.button("虚空世界",
function() enqueueTask(function()
HK()
search(1203982336,4,neicun)
py1(1065353216,4,-468)
py1(-257,4,-420)
py1(-943501312,4,-32)
py1(1203982336,4,-28)
py1(-943501312,4,12)
py1(1203982336,4,16)
xg1(99999,16,-352,true)
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(3000,16,168,false)
end) end),
RG.button("崩坏世界(闪退",
function() enqueueTask(function()
HK()
search(1203982336,4,neicun)
py1(1065353216,4,-468)
py1(-257,4,-420)
py1(-943501312,4,-32)
py1(1203982336,4,-28)
py1(-943501312,4,12)
py1(1203982336,4,16)
xg1(9999,16,-352,true)
end) end),
RG.button("迷雾世界",
function() enqueueTask(function()
HK()
search(1203982336,4,neicun)
py1(1065353216,4,-468)
py1(-257,4,-420)
py1(-943501312,4,-32)
py1(1203982336,4,-28)
py1(-943501312,4,12)
py1(1203982336,4,16)
xg1(-19999,16,-352,true)
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(3000,16,168,false)
end) end),
RG.button("•恢复世界",
function() enqueueTask(function()
HK()
search(1203982336,4,neicun)
py1(1065353216,4,-468)
py1(-257,4,-420)
py1(-943501312,4,-32)
py1(1203982336,4,-28)
py1(-943501312,4,12)
py1(1203982336,4,16)
xg1(0,16,-352,false)
end) end),
RG.switch("绿色世界",
function() enqueueTask(function()
HK()
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("2",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(1200)--设置修改前200个代码
gg.editAll("3.468814637", FLOAT)
提示("开启成功")
gg.clearResults()
end) end,
function() enqueueTask(function()
HK()
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("3.468814637",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(1200)--设置修改前200个代码
gg.editAll("2", FLOAT)
提示("恢复成功")
gg.clearResults()
end) end
),
}),
RG.line(), 
RG.box({"设置速度显示数值",---box示例 可以删掉

RG.button("100000000",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(100000000,16,4,true)

 


end) end), 

RG.button("10",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(10,16,4,true)

 


end) end),

 RG.button("3",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(3,16,4,true)

 


end) end),


RG.button("-3",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(-3,16,4,true)

 


end) end),
RG.button("0",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(0,16,4,true)

 


end) end),

RG.button("恢复",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(0,16,4,false)

 


end) end),


}),
RG.line(),
RG.box({"设置UI崩坏",---box示例 可以删掉
RG.button("设置（不可恢复",
function() enqueueTask(function()

HK()

search(1650667016,4,neicun)
py1(1650667016,4,0)
xg1(0.8,16,-56,true)

 


end) end),
}),
RG.line(), 
RG.box({"设置枪口上抬(后坐力",---box示例 可以删掉
RG.button("无上抬",
function() enqueueTask(function()

HK()

gg.sleep(1)

search(1077149696,4,neicun)
py1(1071644672,4,-96)
py1(1202590843,4,-52)
xg1(0,64,236,true)

 


end) end),
RG.button("严重上抬",
function() enqueueTask(function()

HK()

gg.sleep(1)

search(1077149696,4,neicun)
py1(1071644672,4,-96)
py1(1202590843,4,-52)
xg1(25,64,236,true)

 


end) end),
RG.button("自定义上抬力度",
function() enqueueTask(function()

HK()



search(1077149696,4,neicun)
py1(1071644672,4,-96)
py1(1202590843,4,-52)
xg3(nil,64,236,true,"(自定义上台力度)")

 


end) end),
RG.button("恢复",
function() enqueueTask(function()

HK()



search(1077149696,4,neicun)
py1(1071644672,4,-96)
py1(1202590843,4,-52)
xg1(100,64,236,false)

 


end) end),



}), 
RG.line(),
RG.box({"设置视角朝向",---box示例 可以删掉
RG.button('不抬不低',
function() enqueueTask(function()

HK()

search(-1079977604,4,neicun)
py1(-1079977604,4,0)
py1(1067506044,4,4)
xg1(0,16,-8,true)

 


end) end),
RG.button('仰望天空',
function() enqueueTask(function()

HK()

search(-1079977604,4,neicun)
py1(-1079977604,4,0)
py1(1067506044,4,4)
xg1(-1,16,-8,true)

 


end) end),
RG.button("抬不起头",
function() enqueueTask(function()

HK()

search(-1079977604,4,neicun)
py1(-1079977604,4,0)
py1(1067506044,4,4)
xg1(1,16,-8,true)

 


end) end), 
RG.button("自定义仰望角度",
function() enqueueTask(function()

HK()


search(-1079977604,4,neicun)
py1(-1079977604,4,0)
py1(1067506044,4,4)
xg3(nil,16,-8,true,"(自定义仰望角度)")



 


end) end), 
RG.button("恢复视角",
function() enqueueTask(function()

HK()

search(-1079977604,4,neicun)
py1(-1079977604,4,0)
py1(1067506044,4,4)
xg1(0,16,-8,false)

 


end) end),
}),

RG.line(),
RG.box({'内增高',
RG.button("细微",
function() enqueueTask(function()

HK()
gg.clearResults()
search(-687194767,4,neicun)
py1(54,4,8)
py1(858993459,4,24)
xg1(1.2,64,408,true)

 


end) end),
RG.button("略高",
function() enqueueTask(function()

HK()
gg.clearResults()
search(-687194767,4,neicun)
py1(54,4,8)
py1(858993459,4,24)
xg1(2.1,64,408,true)

 


end) end),
RG.button("高",
function() enqueueTask(function()

HK()
gg.clearResults()
search(-687194767,4,neicun)
py1(54,4,8)
py1(858993459,4,24)
xg1(3.1,64,408,true)

 


end) end),

RG.button("恢复",

function() enqueueTask(function()

HK()
gg.clearResults()
search(-687194767,4,neicun)
py1(54,4,8)
py1(858993459,4,24)
xg1(0.88,64,408,true)

 


end) end

),

}),
RG.line(),
RG.box({'改名字',
RG.button("修改用户名(临时)",
function() enqueueTask(function()
HK()
fix1()
end) end),
RG.button("修改车名",
function() enqueueTask(function()
HK()
fix2()
end) end),
RG.button("修改派对名",
function() enqueueTask(function()
HK()
fix3()
end) end),
RG.button("修改排名(临时)",
function() enqueueTask(function()
HK()
fix4()
end) end),
}),
RG.line(),
RG.box({'换皮肤',
RG.box({'选择皮肤',
RG.button("选择模块",
function() enqueueTask(function()
HK()
xuanzhemokuaipifu()
end) end),
RG.switch("一键机枪换肤",
function() runAsyncTask(function()
HK()
applySkinChange("jiqiang", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("jiqiang", 0)
end) end),
RG.switch("一键海王盾换肤",
function() runAsyncTask(function()
HK()
applySkinChange("haiwangdun", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("haiwangdun", 0)
end) end),
RG.switch("一键大力神换肤",
function() runAsyncTask(function()
HK()
applySkinChange("dalishen", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("dalishen", 0)
end) end),
RG.switch("一键穿云换肤",
function() runAsyncTask(function()
HK()
applySkinChange("chuanyun", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("chuanyun", 0)
end) end),
RG.switch("一键炮台换肤",
function() runAsyncTask(function()
HK()
applySkinChange("paotai", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("paotai", 0)
end) end),
RG.switch("一键哥斯拉巨剑换肤",
function() runAsyncTask(function()
HK()
applySkinChange("dao", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("dao", 0)
end) end),
RG.switch("一键激光换肤",
function() runAsyncTask(function()
HK()
applySkinChange("jiguang", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("jiguang", 0)
end) end),
RG.switch("一键狙击枪换肤",
function() runAsyncTask(function()
HK()
applySkinChange("juji", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("juji", 0)
end) end),
RG.switch("一键榴弹换肤",
function() runAsyncTask(function()
HK()
applySkinChange("lioudan", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("lioudan", 0)
end) end),
RG.switch("一键斥星换肤",
function() runAsyncTask(function()
HK()
applySkinChange("chixing", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("chixing", 0)
end) end),
RG.switch("一键磁暴换肤",
function() runAsyncTask(function()
HK()
applySkinChange("cibao", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("cibao", 0)
end) end),
RG.switch("一键小钻头换肤",
function() runAsyncTask(function()
HK()
applySkinChange("zuantou", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("zuantou", 0)
end) end),
RG.switch("一键跃腾换肤",
function() runAsyncTask(function()
HK()
applySkinChange("yueteng", 1)
end) end,
function() runAsyncTask(function()
HK()
applySkinChange("yueteng", 0)
end) end),
}),
RG.box({'模块皮肤解锁',
RG.button("选择原皮肤目标",
function() enqueueTask(function()
HK()
xuanzepifujiesuo()
end) end),
RG.switch("执行解锁",
function() runAsyncTask(function()
HK()
pifujiesuo(1)
end) end,
function() runAsyncTask(function()
HK()
pifujiesuo(0)
end) end),
}),
RG.box({'选择皮肤 2.0',
RG.button("选择模块",
function() enqueueTask(function()
HK()

selectSkin2()

end) end),
RG.switch("一键机枪换肤",
function() runAsyncTask(function()
HK()

switch2On(weapons.machinegun)

end) end,
function() runAsyncTask(function()
HK()

switch2Off(weapons.machinegun)

end) end),
RG.switch("一键穿云换肤",
function() runAsyncTask(function()
HK()

switch2On(weapons.chuanyun)

end) end,
function() runAsyncTask(function()
HK()

switch2Off(weapons.chuanyun)

end) end),
RG.switch("一键大力神换肤",
function() runAsyncTask(function()
HK()

switch2On(weapons.dalishen)

end) end,
function() runAsyncTask(function()
HK()

switch2Off(weapons.dalishen)

end) end),
RG.switch("一键防空炮换肤",
function() runAsyncTask(function()
HK()

switch2On(weapons.fangkongpao)

end) end,
function() runAsyncTask(function()
HK()

switch2Off(weapons.fangkongpao)

end) end),
}),
}),
RG.line(),
RG.box({"特效美化",
RG.switch("机枪特效(仅枪口)",
function() runAsyncTask(function()
HK()
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
gg.searchNumber("404013", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("110200407", gg.TYPE_DWORD)
gaitexiaojiqiangteshuban = gg.getResults(1000)
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
提示("已开启枪口特效")
end) end,
function() runAsyncTask(function()
HK()
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
gg.loadResults(gaitexiaojiqiangteshuban)
gg.addListItems(gaitexiaojiqiangteshuban)
gg.refineNumber("110200407", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("404013", gg.TYPE_DWORD)
gaitexiaojiqiangteshuban = nil
gg.clearResults()
local savedItems = gg.getListItems()
gg.removeListItems(savedItems)
提示("已关闭枪口特效")
end) end),
RG.switch("机枪特效",
function() runAsyncTask(function()
HK()
gaitexiao(4040)
gaitexiaojiqiang = linshiget
提示("已开启机枪特效")
end) end,
function() runAsyncTask(function()
HK()
linshiget = gaitexiaojiqiang
gaitexiaooff(4040)
提示("已关闭机枪特效")
end) end),
RG.switch("大力神特效",
function() runAsyncTask(function()
HK()
gaitexiao(10010)
gaitexiaodalishen = linshiget
提示("已开启大力神特效")
end) end,
function() runAsyncTask(function()
HK()
linshiget = gaitexiaodalishen
gaitexiaooff(10010)
提示("已关闭大力神特效")
end) end),
RG.switch("自瞄炮特效",
function() runAsyncTask(function()
HK()
gaitexiao(4020)
gaitexiaozimiaopao = linshiget
提示("已开启自瞄炮特效")
end) end,
function() runAsyncTask(function()
HK()
linshiget = gaitexiaozimiaopao
gaitexiaooff(4020)
提示("已关闭自瞄炮特效")
end) end),
RG.switch("穿云特效",
function() runAsyncTask(function()
HK()
gaitexiao(3104010)
gaitexiaochuanyun = linshiget
提示("已开启穿云特效")
end) end,
function() runAsyncTask(function()
HK()
linshiget = gaitexiaochuanyun
gaitexiaooff(3104010)
提示("已关闭穿云特效")
end) end),
RG.switch("烟雾发生器特效",
function() runAsyncTask(function()
HK()
gaitexiao(11030)
gaitexiaoyanwfsq = linshiget
提示("已开启烟雾发生器特效")
end) end,
function() runAsyncTask(function()
HK()
linshiget = gaitexiaoyanwfsq
gaitexiaooff(11030)
提示("已关闭烟雾发生器特效")
gg.alert('关闭后解体')
end) end),
RG.switch("狙击枪特效",
function() runAsyncTask(function()
HK()
gaitexiao(4050)
gaitexiaojujiq = linshiget
提示("已开启狙击枪特效")
end) end,
function() runAsyncTask(function()
HK()
linshiget = gaitexiaojujiq
gaitexiaooff(4050)
提示("已关闭狙击枪特效")
gg.alert('关闭后解体')
end) end),
RG.switch("天罚特效",
function() runAsyncTask(function()
HK()
gaitexiao(4060)
gaitexiaotianfa = linshiget
提示("已开启天罚特效")
end) end,
function() runAsyncTask(function()
HK()
linshiget = gaitexiaotianfa
gaitexiaooff(4060)
提示("已关闭天罚特效")
end) end),
RG.switch("炮台特效",
function() runAsyncTask(function()
HK()
gaitexiao(11020)
gaitexiaopaotai = linshiget
提示("已开启炮台特效")
end) end,
function() runAsyncTask(function()
HK()
linshiget = gaitexiaopaotai
gaitexiaooff(11020)
提示("已关闭炮台特效")
end) end),
RG.switch("大神之路特效",
function() runAsyncTask(function()
HK()
dashentexiao(1)
end) end,
function() runAsyncTask(function()
HK()
dashentexiao(0)
end) end),
}), 
RG.line(),
RG.box({'改地图/主页/模型',
RG.box({'改地图',
RG.button("选择地图",
function() enqueueTask(function()
HK()
if suoditu == 1 then
提示('请先关闭地图修改')
else
dituxiougaixuan()
end
end) end),
RG.switch("修改地图",
function() runAsyncTask(function()
HK()
dituxiougai(1)
suoditu = 1
end) end,
function() runAsyncTask(function()
HK()
dituxiougai(0)
suoditu = 0
end) end),
}),
RG.box({'改主页',
RG.button("选择主页",
function() enqueueTask(function()
HK()
if suozitu == 1 then
提示('请先关闭主页修改')
else
zhuyexiougaixuan()
end
end) end),
RG.switch("修改主页",
function() runAsyncTask(function()
HK()
zhuyexiougai(1)
suozitu = 1
end) end,
function() runAsyncTask(function()
HK()
zhuyexiougai(0)
suozitu = 0
end) end),
}),
RG.box({'改模型',
RG.button("选择模型",
function() enqueueTask(function()
HK()
if suomoxing == 0 then
xuanzhemoxing()
if intgaimoxing == 0 then
yuanmoName = "纯色魔方"
yuanmoId = "101000"
mubiaomoName = "救援无人机"
mubiaomoId = "2003"
提示('已取消')
end
else
提示('请先关闭模型修改')
end
end) end),
RG.switch("修改模型",
function() runAsyncTask(function()
HK()
suomoxing = 1
moxing(1)
end) end,
function() runAsyncTask(function()
HK()
moxing(0)
suomoxing = 0
end) end),
}),
}),
RG.line(),
RG.switch("自由视角",
function() enqueueTask(function()
HK()
search(-1.2566370964050293,16,neicun)
xg1(-9.114514,16,0,false)
xg1(9.114514,16,4,false)
提示("自由视角已开启")
end) end,
function()
HK()
search(-9.114514,16,neicun)
xg1(-1.2566370964050293,16,0,false)
xg1(1.2566370964050293,16,8,false)
提示("自由视角已关闭")
end
),
RG.switch("枪斗术",
function() enqueueTask(function()
HK()
--[[
if gg.getRangesList("libclient.so")[1] then
	local t = {}
	t[1] = gg.getRangesList("libclient.so")[1]["start"] + 0x1FDF7E4; -- 数值地址:0x7C5C9B17E4
	gg.setValues({
		[1] = { 
			address = t[1],
			flags = 16,
			value = 99999,
		},
	})
end
]]
search(-180, 16, 16384)
if sj and #sj > 0 then
_Backup_Special["甩枪"] = {
addresses = {},
originalValue = -180,
modifiedValue = nil
}
for i = 1, #sj do
_Backup_Special["甩枪"].addresses[i] = sj[i].address
end
end
xg3(999999, 16, 0, false, true, "(自定义甩枪)")
if _Backup_Special["甩枪"] then
_Backup_Special["甩枪"].modifiedValue = last
end
end) end,
function()
HK()
--[[
if gg.getRangesList("libclient.so")[1] then
	local t = {}
	t[1] = gg.getRangesList("libclient.so")[1]["start"] + 0x1FDF7E4; -- 数值地址:0x7C5C9B17E4
	gg.setValues({
		[1] = { 
			address = t[1],
			flags = 16,
			value = -185,
		},
	})
end
]]
local backup = _Backup_Special["甩枪"]
if backup and backup.addresses and #backup.addresses > 0 then
    local restoreList = {}
    for i = 1, #backup.addresses do
        table.insert(restoreList, {
            address = backup.addresses[i],
            flags = 16,
            value = backup.originalValue,
            freeze = false
        })
    end
    gg.setValues(restoreList)
    gg.removeListItems(restoreList)
    local count = #restoreList
    local userValue = backup.modifiedValue or "?"
    _Backup_Special["甩枪"] = nil
    提示(string.format("共修改%d个数据(%s)→-180", count, tostring(userValue)))
    return true
end

local searchValue = backup and backup.modifiedValue or 999999
search(searchValue, 16, 16384)
if sj and #sj > 0 then
    local count = #sj
    local userValue = searchValue
    xg1(-180, 16, 0, false)
    _Backup_Special["甩枪"] = nil
    提示(string.format("共修改%d个数据(%s)→-180", count, tostring(userValue)))
else
    提示("甩枪关闭失败：未找到地址")
    _Backup_Special["甩枪"] = nil
end
end),
RG.switch("打核心特效放大",
function() enqueueTask(function()
HK()
--[[
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber('1.2;1.3', gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber('', gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll('9.1973451344', gg.TYPE_FLOAT)
提示('开启成功')
]]
search("1.2;1.3", 16, neicun)
if sj and #sj > 0 then
_Backup_Shoot = {}
local readList = {}
for i = 1, #sj do
readList[i] = {address = sj[i].address, flags = 16}
end
local values = gg.getValues(readList)
for i = 1, #sj do
_Backup_Shoot[i] = {
address = sj[i].address,
flags = 16,
value = values[i].value
}
end
end
xg3(9.1973451344, 16, 0, false, true, "(自定义放大击中核心特效)")
end) end,
function()
HK()
--[[
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber('9.1973451344', gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll('1.2', gg.TYPE_FLOAT)
提示('恢复成功')
]]
if _Backup_Shoot and #_Backup_Shoot > 0 then
gg.setValues(_Backup_Shoot)
gg.removeListItems(_Backup_Shoot)
local count = #_Backup_Shoot
local userValue = last or 9.1973451344
_Backup_Shoot = nil
提示(string.format("共修改%d个数据(%.4f)→原始值", count, userValue))
return true
end
local searchValue = last or 9.1973451344
search(searchValue, 16, neicun)
if sj and #sj > 0 then
local count = #sj
local userValue = searchValue
xg1(1.2, 16, 0, false)
_Backup_Shoot = nil
提示(string.format("共修改%d个数据(%.4f)→1.2", count, userValue))
else
提示("放大击中核心特效关闭失败：未找到地址")
_Backup_Shoot = nil
end
end
),
RG.radio({
 "娱乐功能",
{"破隐(自定义)",
function() enqueueTask(function()
HK()
破隐自定义()
end) end,
},{"破隐",
function() enqueueTask(function()
HK()
破隐()
end) end,
},{"海王盾变红色",
function() enqueueTask(function()
HK()
海王盾变红色()
end) end,
},{"海王盾变深红色",
function() enqueueTask(function()
HK()
海王盾变深红色()
end) end,
},{"海王盾变青与红色",
function() enqueueTask(function()
HK()
海王盾变青与红色()
end) end,
},{"地面透明",
function() enqueueTask(function()
HK()
地面透明()
end) end,
},
{"恢复以上功能",
function() enqueueTask(function()
HK()
恢复以上功能()
end) end,
},
{"隐藏UI",
function() enqueueTask(function()
HK()
隐藏UI()
end) end,
},
{"隐藏UI②",
function() enqueueTask(function()
HK()
隐藏UI2()
end) end,
},
{"恢复UI",
function() enqueueTask(function()
HK()
恢复UI()
end) end,
},
{"无法移动",
function() enqueueTask(function()
HK()
无法移动()
end) end,
},
{"恢复移动",
function() enqueueTask(function()
HK()
恢复移动()
end) end,
},
{"视角锁定",
function() enqueueTask(function()
HK()
视角锁定()
end) end,
},{"恢复视角",
function() enqueueTask(function()
HK()
恢复视角()
end) end,
},{"特效加速",
function() enqueueTask(function()
HK()
特效加速()
end) end,
},{"特效减速",
function() enqueueTask(function()
HK()
特效减速()
end) end,
},{"恢复特效速度",
function() enqueueTask(function()
HK()
恢复特效速度()
end) end,
},{"钻地[可车体]" ,
function() enqueueTask(function()
HK()
钻地车体()
end) end,
},
{"钻地(悬空)[推荐解体]" ,
function() enqueueTask(function()
HK()
钻地悬空推荐解体()
end) end,
},{"脱离卡实体墙(解体用)" ,
function() enqueueTask(function()
HK()
脱离卡实体墙解体用()
end) end,
},
{"恢复钻地(解体用)" ,
function() enqueueTask(function()
HK()
恢复钻地解体用()
end) end,
},
{"全图毒人(直接版)开" ,
function() enqueueTask(function()
HK()
全图毒人直接版开()
end) end,
},
{"全图毒人(直接版)关" ,
function() enqueueTask(function()
HK()
全图毒人直接版关()
end) end,
},
{"毒人Promax开" ,
function() enqueueTask(function()
HK()
毒人Promax开()
end) end,
},{"毒人Promax关",
function() enqueueTask(function()
HK()
毒人Promax关()
end) end,
},{"远程拾取范围",
function() enqueueTask(function()
HK()
远程拾取范围()
end) end,
},{"弱网",
function() enqueueTask(function()
HK()
弱网()
end) end,
},{"恢复弱网",
function() enqueueTask(function()
HK()
恢复弱网()
end) end,
}, {"删除地图",
function() enqueueTask(function()
HK()
删除地图()
end) end,
},{"恢复删除地图",
function() enqueueTask(function()
HK()
恢复删除地图()
end) end,
},{"爬墙",
function() enqueueTask(function()
HK()
爬墙()
end) end,
},{"穿墙(推荐解体" ,
function() enqueueTask(function()
HK()
穿墙推荐解体()
end) end,
},{"自定义倾斜角度",
function() enqueueTask(function()
HK()
自定义倾斜角度()
end) end,
},{"不倒翁",
function() enqueueTask(function()
HK()
不倒翁()
end) end,
},{"反向不倒翁",
function() enqueueTask(function()
HK()
反向不倒翁()
end) end,
},{"转圈圈",
function() enqueueTask(function()
HK()
转圈圈()
end) end,
},{"自定义转圈圈",
function() enqueueTask(function()
HK()
自定义转圈圈()
end) end,
},{"恢复",
function() enqueueTask(function()
恢复娱乐功能()
end) end,
},
}),
},
{--4
RG.box({"仿gg变速自瞄炮(不是灵体)",---box示例 可以删掉
 RG.button("开启",
function() enqueueTask(function()

HK()
 
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("500", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("500",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("-9999999999929194514", FLOAT)
提示("开启成功")
gg.clearResults()
end
 


end) end),
RG.button("关闭",
function() enqueueTask(function()

HK()
 
gg.searchNumber("-9999999999929194514",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("500", FLOAT)
提示("恢复成功")
gg.clearResults()
end) end),
}),
RG.box({"改装类", 
RG.box({"解锁模块",
RG.check({"全部",}),
RG.box({"基础",
RG.buts({
{"猛犸",
function() enqueueTask(function()
HK()
gaimokuai(3200,"猛犸")
end) end,
},{"奔狼",
function() enqueueTask(function()
HK()
gaimokuai(3210,"奔狼")
end) end,
},{"变奏舞步",
function() enqueueTask(function()
HK()
gaimokuai(3503010,"变奏舞步")
end) end,
},
}),
RG.buts({
{"方舟",
function() enqueueTask(function()
HK()
gaimokuai(3203010,"方舟")
end) end,
},{"音速",
function() enqueueTask(function()
HK()
gaimokuai(3403020,"音速")
end) end,
},{"旋风",
function() enqueueTask(function()
HK()
gaimokuai(3403010,"旋风")
end) end,
},
}),
RG.buts({
{"蓝火",
function() enqueueTask(function()
HK()
gaimokuai(3410010,"蓝火")
end) end,
},{"重装魔方",
function() enqueueTask(function()
HK()
gaimokuai(3302010,"重装魔方")
end) end,
},{"天行者",
function() enqueueTask(function()
HK()
gaimokuai(3303070,"天行者")
end) end,
},
}),
RG.buts({
{"魔方 1-2",
function() enqueueTask(function()
HK()
gaimokuai(2047,"魔方 1-2")
end) end,
},{"斜面 1-2",
function() enqueueTask(function()
HK()
gaimokuai(2045,"斜面 1-2")
end) end,
},{"斜面 1-3",
function() enqueueTask(function()
HK()
gaimokuai(2046,"斜面 1-3")
end) end,
},
}),
RG.buts({
{"斜面 1-4",
function() enqueueTask(function()
HK()
gaimokuai(2048,"斜面 1-4")
end) end,
},{"棱锥 1-2",
function() enqueueTask(function()
HK()
gaimokuai(2042,"棱锥 1-2")
end) end,
},{"棱锥 1-3",
function() enqueueTask(function()
HK()
gaimokuai(2043,"棱锥 1-3")
end) end,
},
}),
RG.buts({
{"棱锥 1-4",
function() enqueueTask(function()
HK()
gaimokuai(2044,"棱锥 1-4")
end) end,
},{"圆柱 1-1",
function() enqueueTask(function()
HK()
gaimokuai(2049,"圆柱 1-1")
end) end,
},{"圆柱 1-2",
function() enqueueTask(function()
HK()
gaimokuai(2051,"圆柱 1-2")
end) end,
},
}),
RG.buts({
{"圆柱 1-3",
function() enqueueTask(function()
HK()
gaimokuai(2052,"圆柱 1-3")
end) end,
},{"圆柱 1-4",
function() enqueueTask(function()
HK()
gaimokuai(2053,"圆柱 1-4")
end) end,
},{"圆柱 1-5",
function() enqueueTask(function()
HK()
gaimokuai(2054,"圆柱 1-5")
end) end,
},
}),
RG.buts({
{"圆柱 1-6",
function() enqueueTask(function()
HK()
gaimokuai(2055,"圆柱 1-6")
end) end,
},{"圆柱 1-7",
function() enqueueTask(function()
HK()
gaimokuai(2056,"圆柱 1-7")
end) end,
},{"圆柱 1-8",
function() enqueueTask(function()
HK()
gaimokuai(2057,"圆柱 1-8")
end) end,
},
}),
RG.buts({
{"圆柱 1-9",
function() enqueueTask(function()
HK()
gaimokuai(2058,"圆柱 1-9")
end) end,
},{"球体 1-1",
function() enqueueTask(function()
HK()
gaimokuai(2059,"球体 1-1")
end) end,
},
}),
}),
RG.line(),
RG.box({"输出",
RG.buts({
{"追猎",
function() enqueueTask(function()
HK()
gaimokuai(3604010,"追猎")
end) end,
},{"陨星",
function() enqueueTask(function()
HK()
gaimokuai(3604020,"陨星")
end) end,
},{"辉光",
function() enqueueTask(function()
HK()
gaimokuai(3204010,"辉光")
end) end,
},
}),
RG.buts({
{"殉道者",
function() enqueueTask(function()
HK()
gaimokuai(3204020,"殉道者")
end) end,
},{"球状闪电",
function() enqueueTask(function()
HK()
gaimokuai(3404010,"球状闪电")
end) end,
},{"穿云",
function() enqueueTask(function()
HK()
gaimokuai(3104010,"穿云")
end) end,
},
}),
RG.buts({
{"业火焚世",
function() enqueueTask(function()
HK()
gaimokuai(3304010,"业火焚世")
end) end,
},{"地狱之刃",
function() enqueueTask(function()
HK()
gaimokuai(3305010,"地狱之刃")
end) end,
},{"防空炮",
function() enqueueTask(function()
HK()
gaimokuai(3704020,"防空炮")
end) end,
},
}),
RG.buts({
{"裂空",
function() enqueueTask(function()
HK()
gaimokuai(3704010,"裂空")
end) end,
},
}),
}),
RG.line(),
RG.box({"辅助",
RG.buts({
{"泡泡枪",
function() enqueueTask(function()
HK()
gaimokuai(3511010,"泡泡枪")
end) end,
},{"闪耀星光",
function() enqueueTask(function()
HK()
gaimokuai(3511020,"闪耀星光")
end) end,
},{"时光船锚",
function() enqueueTask(function()
HK()
gaimokuai(3511030,"时光船锚")
end) end,
},
}),
RG.buts({
{"斥械心环",
function() enqueueTask(function()
HK()
gaimokuai(3211040,"斥械心环")
end) end,
},{"严霜界碑",
function() enqueueTask(function()
HK()
gaimokuai(3211020,"严霜界碑")
end) end,
},{"空之握",
function() enqueueTask(function()
HK()
gaimokuai(3211010,"空之握")
end) end,
},
}),
RG.buts({
{"零度领域",
function() enqueueTask(function()
HK()
gaimokuai(3411010,"零度领域")
end) end,
},{"第四引力",
function() enqueueTask(function()
HK()
gaimokuai(3411020,"第四引力")
end) end,
},{"斥星",
function() enqueueTask(function()
HK()
gaimokuai(3111010,"斥星")
end) end,
},
}),
RG.buts({
{"索隐",
function() enqueueTask(function()
HK()
gaimokuai(3111020,"索隐")
end) end,
},{"无畏者",
function() enqueueTask(function()
HK()
gaimokuai(3111030,"无畏者")
end) end,
},{"推恩官",
function() enqueueTask(function()
HK()
gaimokuai(3111050,"推恩官")
end) end,
},
}),
RG.buts({
{"建造者",
function() enqueueTask(function()
HK()
gaimokuai(3311020,"建造者")
end) end,
},
}),
}),
RG.line(),
RG.box({"终极",
RG.buts({
{"蜂巢",
function() enqueueTask(function()
HK()
gaimokuai(3104020,"蜂巢")
end) end,
},{"千面",
function() enqueueTask(function()
HK()
gaimokuai(3111060,"千面")
end) end,
},{"狼群",
function() enqueueTask(function()
HK()
gaimokuai(3111040,"狼群")
end) end,
},
}),
RG.buts({
{"苍穹守护",
function() enqueueTask(function()
HK()
gaimokuai(3307010,"苍穹守护")
end) end,
},
}),
}),
RG.line(),
RG.box({"娱乐",
RG.buts({
{"角鹰",
function() enqueueTask(function()
HK()
gaimokuai(3612010,"角鹰")
end) end,
},{"渡鸦",
function() enqueueTask(function()
HK()
gaimokuai(3612020,"渡鸦")
end) end,
},{"黑尾",
function() enqueueTask(function()
HK()
gaimokuai(3612030,"黑尾")
end) end,
},
}),
RG.buts({
{"野蜂",
function() enqueueTask(function()
HK()
gaimokuai(3612050,"野蜂")
end) end,
},{"小叮当",
function() enqueueTask(function()
HK()
gaimokuai(3612040,"小叮当")
end) end,
},{"滑翔翼",
function() enqueueTask(function()
HK()
gaimokuai(12020,"滑翔翼")
end) end,
},
}),
RG.buts({
{"加农炮",
function() enqueueTask(function()
HK()
gaimokuai(12030,"加农炮")
end) end,
},{"灯箱",
function() enqueueTask(function()
HK()
gaimokuai(12040,"灯箱")
end) end,
},{"电子目镜",
function() enqueueTask(function()
HK()
gaimokuai(3412020,"电子目镜")
end) end,
},
}),
RG.buts({
{"定风翼",
function() enqueueTask(function()
HK()
gaimokuai(3412030,"定风翼")
end) end,
},{"前扰流板",
function() enqueueTask(function()
HK()
gaimokuai(3412010,"前扰流板")
end) end,
},{"小型前扰流板",
function() enqueueTask(function()
HK()
gaimokuai(12050,"小型前扰流板")
end) end,
},
}),
RG.buts({
{"尾翼-支架",
function() enqueueTask(function()
HK()
gaimokuai(12060,"尾翼-支架")
end) end,
},{"尾翼-梁翼",
function() enqueueTask(function()
HK()
gaimokuai(12070,"尾翼-梁翼")
end) end,
},{"尾翼-风翼",
function() enqueueTask(function()
HK()
gaimokuai(12080,"尾翼-风翼")
end) end,
},
}),
RG.buts({
{"火枪手",
function() enqueueTask(function()
HK()
gaimokuai(3612060,"火枪手")
end) end,
},
}),
}),
RG.line(),
RG.button("自定义改模块",
function() runAsyncTask(function()
unifiedModifyDialog()
end)
end),
RG.line(),
RG.button("查看修改记录",
function() runAsyncTask(function()
showCurrentStatus()
end)
end),
RG.line(),
RG.button("恢复解锁(避免闪退)",
function() runAsyncTask(function()
huifusuoyou()
end)
end),
RG.line(),
RG.button("查看所有已知模块ID",
function() runAsyncTask(function()
showAllKnownModules()
end)
end),
RG.check({"改装后记得恢复,避免闪退",}),
RG.line(),
}),
RG.box({"改核心", 
RG.button("设置核心",
function() enqueueTask(function()
HK()
guaihexinModifyDialog()
end) end),
RG.line(),
RG.button("执行修改(永久有效)",
function() enqueueTask(function()
HK()
gaiheModification()
end) end),
RG.line(), 
RG.button("恢复永久核心",
function() enqueueTask(function()
HK()
restoreCore()
end) end),
RG.line(), 
RG.button("显示当前选择",
function() enqueueTask(function()
HK()
showCurrentSelection()
end) end),
RG.line(), 
RG.button("查看已知核心模块",
function() enqueueTask(function()
HK()
showAllCoreModules()
end) end),
}),
RG.box({"改核心(备用)", 
RG.button("设置核心",
function() enqueueTask(function()
HK()
yongjiougaihexinxunzhe()
end) end),
RG.line(),
RG.button("执行修改(永久有效)",
function() enqueueTask(function()
HK()
yongjiougaihexin(1)
end) end),
RG.line(), 
RG.button("恢复永久核心",
function() enqueueTask(function()
HK()
yongjiougaihexin(0)
end) end),
}),
RG.box({"改核心 2.0", 
RG.button("初始化核心地址",
function() enqueueTask(function()
HK()
setcoreint()
end) end),
RG.line(),
RG.button("选择核心",
function() enqueueTask(function()
HK()
setcore()
end) end),
RG.line(),
RG.button("执行修改核心",
function() enqueueTask(function()
HK()
uestocore()
end) end),
RG.line(), 
RG.button("恢复核心",
function() enqueueTask(function()
HK()
rescore()
end) end),
}),
}),
RG.line(),
RG.box({"悬浮窗快捷键",
RG.box({"战斗类",
RG.switch("秒杀范围",
function() luajava.newThread(function()
HK()
打开页面("秒杀范围")
end):start() end,
function()
关闭页面("秒杀范围")
end
),
RG.switch("秒杀小范围",
function() luajava.newThread(function()
HK()
打开页面("秒杀小范围")
end):start() end,
function()
关闭页面("秒杀小范围")
end
),
RG.switch("车体范围",
function() luajava.newThread(function()
HK()
打开页面("车体范围")
end):start() end,
function()
关闭页面("车体范围")
end
),
RG.switch("车体小范围",
function() luajava.newThread(function()
HK()
打开页面("车体范围")
end):start() end,
function()
关闭页面("车体范围")
end
),
RG.switch("后坐力(上抬)",
function() luajava.newThread(function()
打开页面("后坐力(上抬)")
end):start() end,
function()
关闭页面("后坐力(上抬)")
end
),
RG.switch("后坐力",
function() luajava.newThread(function()
打开页面("后坐力")
end):start() end,
function()
关闭页面("后坐力")
end
),
RG.switch("机枪后坐",
function() luajava.newThread(function()
打开页面("机枪后坐")
end):start() end,
function()
关闭页面("机枪后坐")
end
),
RG.switch("离线",
function() luajava.newThread(function()
打开页面("离线")
end):start() end,
function()
关闭页面("离线")
end
),
RG.switch("离线Pro",
function() luajava.newThread(function()
打开页面("离线Pro")
end):start() end,
function()
关闭页面("离线Pro")
end
),
RG.switch("机枪离线",
function() luajava.newThread(function()
打开页面("机枪离线")
end):start() end,
function()
关闭页面("机枪离线")
end
),
RG.switch("全局加速",
function() luajava.newThread(function()
打开页面("全局加速")
end):start() end,
function()
关闭页面("全局加速")
end
),
RG.switch("弱网",
function() luajava.newThread(function()
打开页面("弱网")
end):start() end,
function()
关闭页面("弱网")
end
),
RG.switch("停止发包",
function() luajava.newThread(function()
打开页面("停止发包")
end):start() end,
function()
关闭页面("停止发包")
end
),
RG.switch("破隐",
function() luajava.newThread(function()
打开页面("破隐")
end):start() end,
function()
关闭页面("破隐")
end
),
RG.switch("视角",
function() luajava.newThread(function()
打开页面("视角")
end):start() end,
function()
关闭页面("视角")
end
),
RG.switch("视角[广角]",
function() luajava.newThread(function()
打开页面("视角[广角]")
end):start() end,
function()
关闭页面("视角[广角]")
end
),
RG.switch("视角[旧]",
function() luajava.newThread(function()
打开页面("视角[旧]")
end):start() end,
function()
关闭页面("视角[旧]")
end
),
}),
RG.box({"娱乐类",
RG.switch("大力神加速",
function() luajava.newThread(function()
打开页面("大力神加速")
end):start() end,
function()
关闭页面("大力神加速")
end
),
RG.switch("核心加速",
function() luajava.newThread(function()
打开页面("核心加速")
end):start() end,
function()
关闭页面("核心加速")
end
),
RG.switch("核心防水",
function() luajava.newThread(function()
打开页面("核心防水")
end):start() end,
function()
关闭页面("核心防水")
end
),
RG.switch("防闪光弹",
function() luajava.newThread(function()
打开页面("防闪光弹")
end):start() end,
function()
关闭页面("防闪光弹")
end
),
RG.switch("删除地图",
function() luajava.newThread(function()
打开页面("删除地图")
end):start() end,
function()
关闭页面("删除地图")
end
),
RG.switch("应急",
function() luajava.newThread(function()
HK()
打开页面("应急")
end):start() end,
function()
关闭页面("应急")
end
),
RG.switch("不倒翁",
function() luajava.newThread(function()
打开页面("不倒翁")
end):start() end,
function()
关闭页面("不倒翁")
end
),
}),
RG.box({"快速弱网",
RG.switch("初始化快速弱网",
function() luajava.newThread(function()
打开页面("初始快速弱网")
end):start() end,
function()
关闭页面("初始快速弱网")
end
),
RG.switch("快速弱网",
function() luajava.newThread(function()
打开页面("快速弱网")
end):start() end,
function()
关闭页面("快速弱网")
end
),
}),
RG.button("关闭所有快捷键悬浮窗", 
function() luajava.newThread(function()
关闭所有快捷键悬浮窗()
end):start() end),
}),
RG.line(),
RG.box({
'快捷音乐',
RG.radio2({
 "部分音乐",
{"你看到的我DJ/你看到的我",
function() runAsyncTask(function() 
 提示("你看到的我DJ/你看到的我")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/HQYMFrmQ_%E4%BD%A0%E7%9C%8B%E5%88%B0%E7%9A%84%E6%88%91%20%20DJ%E7%89%88%20%20-%20%E9%BB%84%E5%8B%87%20%E4%BB%BB%E4%B9%A6%E6%80%80_%E5%90%88%E5%B9%B6.wav?attname=%E4%BD%A0%E7%9C%8B%E5%88%B0%E7%9A%84%E6%88%91%20%20DJ%E7%89%88%20%20-%20%E9%BB%84%E5%8B%87%20%E4%BB%BB%E4%B9%A6%E6%80%80_%E5%90%88%E5%B9%B6.wav')
end)
end,
 }, {"See You Again (牢大)",
function() runAsyncTask(function() 
提示("See You Again (牢大)")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/21/9W65Efvk_See%20You%20Again%20-%20Wiz%20Khalifa%20Charlie%20Puth.flac?attname=See%20You%20Again%20-%20Wiz%20Khalifa%20Charlie%20Puth.flac")
end)
end,
}, {"Ferrari 🇺🇸腰射",
function() runAsyncTask(function()
 
提示("Ferrari 🇺🇸腰射")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/21/0pUfX4Gz_Ferrari%20-%20Bebe%20Rexha.flac?attname=Ferrari%20-%20Bebe%20Rexha.flac")
end)
end,
}, {"ALL MY PEOPLE",
function() runAsyncTask(function()
 
提示("ALL MY PEOPLE")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/21/0ybJEu31_All%20My%20People%20-%20Alexandra%20Stan.flac?attname=All%20My%20People%20-%20Alexandra%20Stan.flac")
end)
end,
}, {"METAMORPHOSIS",
function() runAsyncTask(function() 
提示("METAMORPHOSIS")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/21/NtVQNYhR_METAMORPHOSIS%20-%20INTERWORLD.flac?attname=METAMORPHOSIS%20-%20INTERWORLD.flac")
end)
end,
}, {"Sacred Play Secret Place",
function() runAsyncTask(function() 
提示("Sacred Play Secret Place")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/21/EO7l0v1u_Sacred%20Play%20Secret%20Place%20-%20Matryoshka.flac?attname=Sacred%20Play%20Secret%20Place%20-%20Matryoshka.flac")
end)
end,
}, {"LOVELY BASTARDS",
function() runAsyncTask(function() 
提示("LOVELY BASTARDS")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/21/9RsLf6tc_LOVELY%20BASTARDS%20-%20ZWE1HVNDXR%20yatashigang.flac?attname=LOVELY%20BASTARDS%20-%20ZWE1HVNDXR%20yatashigang.flac")
end)
end,
}, {"孤独终究会被圆满补偿",
function() runAsyncTask(function() 
提示("孤独终究会被圆满补偿")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/21/o6s2koSb_%E4%B9%90%E7%AC%91%E7%AC%91%20-%20%E5%AD%A4%E7%8B%AC%E7%BB%88%E7%A9%B6%E4%BC%9A%E8%A2%AB%E5%9C%86%E6%BB%A1%E8%A1%A5%E5%81%BF.mp3?attname=%E4%B9%90%E7%AC%91%E7%AC%91%20-%20%E5%AD%A4%E7%8B%AC%E7%BB%88%E7%A9%B6%E4%BC%9A%E8%A2%AB%E5%9C%86%E6%BB%A1%E8%A1%A5%E5%81%BF.mp3")
end)
end,
}, {"心做",
function() runAsyncTask(function() 
 提示("心做…")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/ZUdWEhLw_%E5%BF%83%E5%81%9A%EF%BC%88%E5%BF%AB%E6%89%8B%E7%83%AD%E9%97%A8%E5%8E%9F%E5%A3%B0%EF%BC%89%20-%20%E9%98%BF%E5%B8%83%20%E9%98%BF%E8%A1%A1_%E5%90%88%E5%B9%B6.wav?attname=%E5%BF%83%E5%81%9A%EF%BC%88%E5%BF%AB%E6%89%8B%E7%83%AD%E9%97%A8%E5%8E%9F%E5%A3%B0%EF%BC%89%20-%20%E9%98%BF%E5%B8%83%20%E9%98%BF%E8%A1%A1_%E5%90%88%E5%B9%B6.wav')
end)
end,
}, {"POOR/POOR2",
function() runAsyncTask(function() 
 提示("POOR/POOR2")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/Qo878yhD_POOR%20-%20gqtis_%E5%90%88%E5%B9%B6.wav?attname=POOR%20-%20gqtis_%E5%90%88%E5%B9%B6.wav')
end)
end,
}, {"Loneliness",
function() runAsyncTask(function() 
 提示("Loneliness")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/yGn48wZ7_Loneliness%20-%20LXRY%20PXNK%20CHMCL%20S%C3%98UP.flac?attname=Loneliness%20-%20LXRY%20PXNK%20CHMCL%20S%C3%98UP.flac')
end)
end,
}, {"Fear",
function() runAsyncTask(function() 
 提示("Fear")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/aSKeW9R1_Fear%20-%20FreshmanSound.flac?attname=Fear%20-%20FreshmanSound.flac')
end)
end,
}, {"leve(Backrooms)",
function() runAsyncTask(function() 
 提示("leve(Backrooms)")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/FuTqGzng_%E5%A4%9C%E6%9A%AE%E9%9D%92%20-%20Level%21%20%28Backrooms%29.flac?attname=%E5%A4%9C%E6%9A%AE%E9%9D%92%20-%20Level%21%20%28Backrooms%29.flac')
end)
end,
}, {"Sweet Dreams/sweet Dreams(Mixed)",
function() runAsyncTask(function() 
 提示("Sweet Dreams/Sweet Dreams(Mixed)")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/1HQn8Y6f_Sweet%20Dreams%20-%20Breathe%20Carolina%20Kaleena%20Zanders%20Dropgun_%E5%90%88%E5%B9%B6.wav?attname=Sweet%20Dreams%20-%20Breathe%20Carolina%20Kaleena%20Zanders%20Dropgun_%E5%90%88%E5%B9%B6.wav')
end)
end,
}, {"Drive Forever",
function() runAsyncTask(function() 
 提示("Drive Forever")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/FOMXKmzj_Drive%20Forever%20-%20T3nzu.flac?attname=Drive%20Forever%20-%20T3nzu.flac')
end)
end,
}, {"Move Your Body (RAIZHELL Remix)",
function() runAsyncTask(function() 
 提示("Move Your Body (RAIZHELL Remix)")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/wpKpqDOF_Move%20Your%20Body%20%20RAIZHELL%20Remix%20%20-%20%C3%96wnboss%20SEVEK%20RAIZHELL.flac?attname=Move%20Your%20Body%20%20RAIZHELL%20Remix%20%20-%20%C3%96wnboss%20SEVEK%20RAIZHELL.flac')
end)
end,
}, {"Midnight City",
function() runAsyncTask(function() 
 提示("Midnight City")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/FDs8bqPz_Midnight%20City%20-%20M83.flac?attname=Midnight%20City%20-%20M83.flac')
end)
end,
}, {"Kerosene Crystal Castles",
function() runAsyncTask(function() 
 提示("Kerosene Crystal Castles")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/22/jDYJ2zWa_Kerosene%20-%20Crystal%20Castles.flac?attname=Kerosene%20-%20Crystal%20Castles.flac')
end)
end,
}, {"Arabian Adventure Eugene",
function() runAsyncTask(function() 
 提示("Arabian Adventure Eugene")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/22/ww8cjYVv_Arabian%20Adventure%20-%20Eugene%20Star_%E5%90%88%E5%B9%B6.wav?attname=Arabian%20Adventure%20-%20Eugene%20Star_%E5%90%88%E5%B9%B6.wav')
end)
end,
}, {"Your New Home Gooseworx Evan Alderete",
function() runAsyncTask(function() 
 提示("Your New Home Gooseworx Evan Alderete")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/22/WzEwMyp1_Your%20New%20Home%20-%20Gooseworx%20Evan%20Alderete_%E5%90%88%E5%B9%B6.wav?attname=Your%20New%20Home%20-%20Gooseworx%20Evan%20Alderete_%E5%90%88%E5%B9%B6.wav')
end)
end,
}, {"O Come O Come Emmanuel",
function() runAsyncTask(function() 
 提示("O Come O Come Emmanuel")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/22/9MGleKeQ_O%20Come%20O%20Come%20Emmanuel%20-%20Tommee%20Profitt_%E5%90%88%E5%B9%B6.wav?attname=O%20Come%20O%20Come%20Emmanuel%20-%20Tommee%20Profitt_%E5%90%88%E5%B9%B6.wav')
end)
end,
}, {"Crystal castles Kerosene Slowed",
function() runAsyncTask(function() 
 提示("Crystal castles Kerosene Slowed")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/22/LkoCg3L5_Crystal%20castles%20Kerosene%20-%20Slowed%20-%20Cream%20Connor_%E5%90%88%E5%B9%B6.wav?attname=Crystal%20castles%20Kerosene%20-%20Slowed%20-%20Cream%20Connor_%E5%90%88%E5%B9%B6.wav')
end)
end,
}, {"Everywhere We Go",
function() runAsyncTask(function() 
 提示("Everywhere We Go")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/21/wMxmlPwW_Everywhere%20We%20Go%20-%20%E9%99%88%E5%86%A0%E5%B8%8C%20MC%E4%BB%81%20%E5%8E%A8%E6%88%BF%E4%BB%94%20%E5%BA%94%E9%87%87%E5%84%BF.flac?attname=Everywhere%20We%20Go%20-%20%E9%99%88%E5%86%A0%E5%B8%8C%20MC%E4%BB%81%20%E5%8E%A8%E6%88%BF%E4%BB%94%20%E5%BA%94%E9%87%87%E5%84%BF.flac')
end)
end,
}, {"ありがとう···",
function() runAsyncTask(function() 
提示("ありがとう···")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/mfyvzHL1_%E3%81%82%E3%82%8A%E3%81%8C%E3%81%A8%E3%81%86%C2%B7%C2%B7%C2%B7%20-%20KOKIA.flac?attname=%E3%81%82%E3%82%8A%E3%81%8C%E3%81%A8%E3%81%86%C2%B7%C2%B7%C2%B7%20-%20KOKIA.flac")
end)
end,
}, {"Paypnoe",
function() runAsyncTask(function() 
提示("Paypnoe")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/4KEMMKA7_Payphone%20-%20Maroon%205%20Wiz%20Khalifa.flac?attname=Payphone%20-%20Maroon%205%20Wiz%20Khalifa.flac")
end)
end,
}, {"지나갈테니",
function() runAsyncTask(function() 
提示("지나갈테니")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/a6M1wiOJ_EXO%20-%20%EC%A7%80%EB%82%98%EA%B0%88%20%ED%85%8C%EB%8B%88%20%28%E9%A1%BA%E5%85%B6%E8%87%AA%E7%84%B6%29%20%28Been%20Through%29.flac?attname=EXO%20-%20%EC%A7%80%EB%82%98%EA%B0%88%20%ED%85%8C%EB%8B%88%20%28%E9%A1%BA%E5%85%B6%E8%87%AA%E7%84%B6%29%20%28Been%20Through%29.flac")
end)
end,
}, {"我用什么把你留住",
function() runAsyncTask(function() 
提示("我用什么把你留住")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/wYknROnD_%E6%88%91%E7%94%A8%E4%BB%80%E4%B9%88%E6%8A%8A%E4%BD%A0%E7%95%99%E4%BD%8F%20-%20%E7%A6%8F%E7%A6%84%E5%AF%BFFloruitShow.flac?attname=%E6%88%91%E7%94%A8%E4%BB%80%E4%B9%88%E6%8A%8A%E4%BD%A0%E7%95%99%E4%BD%8F%20-%20%E7%A6%8F%E7%A6%84%E5%AF%BFFloruitShow.flac")
end)
end,
}, {"Sample this",
function() runAsyncTask(function() 
提示("Sample this")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/PKowKIPp_Sample%20this%20-%20RJ%20Pasin.flac?attname=Sample%20this%20-%20RJ%20Pasin.flac")
end)
end,
}, {"Take me hand",
function() runAsyncTask(function() 
提示("Take me hand")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/vqzxMgub_Take%20Me%20Hand%20-%20DAISHI%20DANCE%20C%C3%A9cile%20Corbel.flac?attname=Take%20Me%20Hand%20-%20DAISHI%20DANCE%20C%C3%A9cile%20Corbel.flac")
end)
end,
}, {"Butterflies",
function() runAsyncTask(function() 
提示("Butterflies")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/v103lxyY_Butterflies%20-%20nohidea..flac?attname=Butterflies%20-%20nohidea..flac")
end)
end,
}, {"it's 6pm hut I miss u already",
function() runAsyncTask(function() 
提示("it's 6pm hut I miss u already")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/HFqb4vAg_it%20s%206pm%20but%20I%20miss%20u%20already.%20-%20bbbluelee%20Furyl%20Siren.flac?attname=it%20s%206pm%20but%20I%20miss%20u%20already.%20-%20bbbluelee%20Furyl%20Siren.flac")
end)
end,
}, {"Time Stup",
function() runAsyncTask(function() 
提示("Time Stup")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/m6PwA8Uq_Time%20Stop%20-%20BLACKDD%20CYTEAM%20PICK%20%E7%9F%A5%E6%99%8F.flac?attname=Time%20Stop%20-%20BLACKDD%20CYTEAM%20PICK%20%E7%9F%A5%E6%99%8F.flac")
end)
end,
}, {"橙夏",
function() runAsyncTask(function() 
提示("橙夏")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/tsxpEuLG_%E6%A9%99%E5%A4%8F%20-%20MORROW.flac?attname=%E6%A9%99%E5%A4%8F%20-%20MORROW.flac")
end)
end,
}, {"The Right Path",
function() runAsyncTask(function() 
提示("The Right Path")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/KMwIehgq_The%20Right%20Path%20-%20Thomas%20Greenberg.flac?attname=The%20Right%20Path%20-%20Thomas%20Greenberg.flac")
end)
end,
}, {"凄美(凉)地",
function() runAsyncTask(function() 
提示("凄美地")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/CeEz5XuZ_%E5%87%84%E7%BE%8E%E5%9C%B0%20-%20%E9%83%AD%E9%A1%B6.flac?attname=%E5%87%84%E7%BE%8E%E5%9C%B0%20-%20%E9%83%AD%E9%A1%B6.flac")
end)
end,
}, {"日暮里",
function() runAsyncTask(function() 
提示("日暮里")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/U82E3r67_%E6%97%A5%E6%9A%AE%E9%87%8C%20-%20JINBAO.flac?attname=%E6%97%A5%E6%9A%AE%E9%87%8C%20-%20JINBAO.flac")
end)
end,
}, {"His Theme",
function() runAsyncTask(function() 
提示("His Theme")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/JHleLM6l_His%20Theme%20-%20Toby%20Fox.flac?attname=His%20Theme%20-%20Toby%20Fox.flac")
end)
end,
}, {"Windy Hill",
function() runAsyncTask(function() 
提示("Windy Hill")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/qNvcWVRi_Windy%20Hill%20-%20%E7%BE%BD%E8%82%BF.flac?attname=Windy%20Hill%20-%20%E7%BE%BD%E8%82%BF.flac")
end)
end,
}, {"Knight(骑士)",
function() runAsyncTask(function() 
提示("Knight(骑士)")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/22/CMg5k2yg_Knight%20%20%E9%AA%91%E5%A3%AB%20%20-%20Gentleman%20Ghani%20Radio%20Qora%20HJFM%20MAGA.flac?attname=Knight%20%20%E9%AA%91%E5%A3%AB%20%20-%20Gentleman%20Ghani%20Radio%20Qora%20HJFM%20MAGA.flac")
end)
end,
}, {"レクイエム",
function() runAsyncTask(function() 
提示("レクイエム")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/JSbFzJDL_%E3%83%AC%E3%82%AF%E3%82%A4%E3%82%A8%E3%83%A0%20-%20%E6%9F%8A%E5%A5%88%E7%BB%AA.flac?attname=%E3%83%AC%E3%82%AF%E3%82%A4%E3%82%A8%E3%83%A0%20-%20%E6%9F%8A%E5%A5%88%E7%BB%AA.flac")
end)
end,
}, {"The Grotto",
function() runAsyncTask(function() 
提示("The Grotto")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/kjCreHVx_The%20Grotto%20-%20Audiomachine.flac?attname=The%20Grotto%20-%20Audiomachine.flac")
end)
end,
}, {"Sunshine Girl",
function() runAsyncTask(function() 
提示("Sunshine Girl")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/fVj4JmCx_Sunshine%20Girl%20-%20moumoon.flac?attname=Sunshine%20Girl%20-%20moumoon.flac")
end)
end,
}, {"PDD",
function() runAsyncTask(function() 
提示("PDD")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/0BqPZInH_PDD%20-%20%E5%BE%90%E6%A2%A6%E5%9C%86.flac?attname=PDD%20-%20%E5%BE%90%E6%A2%A6%E5%9C%86.flac")
end)
end,
}, {"Lata",
function() runAsyncTask(function() 
提示("Lata")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/kFEko3t7_Lata%20-%20makcumbelov%20DEFOX.flac?attname=Lata%20-%20makcumbelov%20DEFOX.flac")
end)
end,
}, {"Ballin",
function() runAsyncTask(function() 
提示("Ballin")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/xQ58Sdle_Ballin%20%20-%20Mustard%20Roddy%20Ricch.flac?attname=Ballin%20%20-%20Mustard%20Roddy%20Ricch.flac")
end)
end,
}, {"最好的安排",
function() runAsyncTask(function() 
提示("最好的安排")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/7oBL3sas_%E6%9C%80%E5%A5%BD%E7%9A%84%E5%AE%89%E6%8E%92%20-%20%E6%9B%B2%E5%A9%89%E5%A9%B7.flac?attname=%E6%9C%80%E5%A5%BD%E7%9A%84%E5%AE%89%E6%8E%92%20-%20%E6%9B%B2%E5%A9%89%E5%A9%B7.flac")
end)
end,
}, {"不问ciaga(不问别离)",
function() runAsyncTask(function() 
提示("不问ciaga(不问别离)")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/g3Tn0M46_%E6%8C%87%E5%B0%96%E7%AC%91%20-%20%E4%B8%8D%E9%97%AEciaga%20%28%E4%B8%8D%E9%97%AE%E5%88%AB%E7%A6%BB%29.flac?attname=%E6%8C%87%E5%B0%96%E7%AC%91%20-%20%E4%B8%8D%E9%97%AEciaga%20%28%E4%B8%8D%E9%97%AE%E5%88%AB%E7%A6%BB%29.flac")
end)
end,
}, {"月亮之矢",
function() runAsyncTask(function() 
提示("月亮之矢")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/kYu0TNd2_%E6%9C%88%E4%BA%AE%E4%B9%8B%E7%9F%A2%20-%20%E5%AD%A4%E7%9F%A2%20%E8%99%9E%E5%A8%B1.flac?attname=%E6%9C%88%E4%BA%AE%E4%B9%8B%E7%9F%A2%20-%20%E5%AD%A4%E7%9F%A2%20%E8%99%9E%E5%A8%B1.flac")
end)
end,
}, {"天气之子.幻",
function() runAsyncTask(function() 
提示("天气之子.幻")
toggleMusic("http://oss2.e-43.com/uploads/2024/08/10/ezsxCjtg_%E5%A4%A9%E6%B0%94%E4%B9%8B%E5%AD%90_%E5%B9%BB%28BGM%29-99K%E9%87%91-235078537-2000.flac?attname=%E5%A4%A9%E6%B0%94%E4%B9%8B%E5%AD%90_%E5%B9%BB%28BGM%29-99K%E9%87%91-235078537-2000.flac")
end)
end,
}, {"偏爱",
function() runAsyncTask(function() 
提示("偏爱")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/2CS9PlqG_%E5%81%8F%E7%88%B1%20-%20%E5%BC%A0%E8%8A%B8%E4%BA%AC.flac?attname=%E5%81%8F%E7%88%B1%20-%20%E5%BC%A0%E8%8A%B8%E4%BA%AC.flac")
end)
end,
}, {"安和桥",
function() runAsyncTask(function() 
提示("安和桥")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/23/imEzXF67_%E5%AE%89%E5%92%8C%E6%A1%A5%20-%20%E5%AE%87%E8%A5%BF.flac?attname=%E5%AE%89%E5%92%8C%E6%A1%A5%20-%20%E5%AE%87%E8%A5%BF.flac")
end)
end,
}, {"The Sound Of Your Fear",
function() runAsyncTask(function() 
提示("The Sound Of Your Fear")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/24/W8FzUXEZ_The%20Sound%20Of%20Your%20Fear%20-%20Midi%20Blosso.flac?attname=The%20Sound%20Of%20Your%20Fear%20-%20Midi%20Blosso.flac")
end)
end,
}, {"Arabian Adventure",
function() runAsyncTask(function() 
提示("Arabian Adventure")
toggleMusic("http://oss2.e-43.com/uploads/2024/08/11/n1jgkHoF_Arabian_Adventure-Eugene_Star-364083379-2000.flac?attname=Arabian_Adventure-Eugene_Star-364083379-2000.flac")
end)
end,
}, {"Sea of Tranquility",
function() runAsyncTask(function() 
提示("Sea of Tranquility")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/24/4V7EOSa4_Sea%20of%20Tranquility%20-%20BeMax.flac?attname=Sea%20of%20Tranquility%20-%20BeMax.flac")
end)
end,
}, {"Suffocating",
function() runAsyncTask(function() 
提示("Suffocating")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/24/uNNI5sC3_Suffocating%20-%20%E7%BE%A4%E6%98%9F.flac?attname=Suffocating%20-%20%E7%BE%A4%E6%98%9F.flac")
end)
end,
}, {"说好的幸福呢",
function() runAsyncTask(function() 
提示("说好的幸福呢")
toggleMusic("http://oss2.e-43.com/uploads/2024/10/06/zmnd2lIF_%E8%AF%B4%E5%A5%BD%E7%9A%84%E5%B9%B8%E7%A6%8F%E5%91%A2-%E5%91%A8%E6%9D%B0%E4%BC%A6-440623-2000.flac?attname=%E8%AF%B4%E5%A5%BD%E7%9A%84%E5%B9%B8%E7%A6%8F%E5%91%A2-%E5%91%A8%E6%9D%B0%E4%BC%A6-440623-2000.flac")
end)
end,
}, {"我是如此相信",
function() runAsyncTask(function() 
提示("我是如此相信")
toggleMusic("http://oss2.e-43.com/uploads/2024/06/26/DjFBZBEj_%E5%91%A8%E6%9D%B0%E4%BC%A6%20-%20%E6%88%91%E6%98%AF%E5%A6%82%E6%AD%A4%E7%9B%B8%E4%BF%A1.flac?attname=%E5%91%A8%E6%9D%B0%E4%BC%A6%20-%20%E6%88%91%E6%98%AF%E5%A6%82%E6%AD%A4%E7%9B%B8%E4%BF%A1.flac")
end)
end,
}, {"暮色回响",
function() runAsyncTask(function() 
 提示("暮色回响")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/27/tCG604Jq_SVID_20240627_105841_1_%E8%A3%81%E5%89%AA_%E5%90%88%E5%B9%B6.wav?attname=SVID_20240627_105841_1_%E8%A3%81%E5%89%AA_%E5%90%88%E5%B9%B6.wav')
end)
end,
},{"Underground",
function() runAsyncTask(function() 
 提示("Underground")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/27/KJMg7wje_Underground%20-%20Lindsey%20Stirling.flac?attname=Underground%20-%20Lindsey%20Stirling.flac')
end)
end,
},{"Night Crusing",
function() runAsyncTask(function() 
 提示("Night Crusing")
toggleMusic('http://oss2.e-43.com/uploads/2024/06/29/0UgXqOru_Night%20Crusing%20%20But%20Slowed%20%20%20prod%20%E7%89%9B%E5%B0%BE%E6%86%B2%E8%BC%94%20%20-%20XyEscape.flac?attname=Night%20Crusing%20%20But%20Slowed%20%20%20prod%20%E7%89%9B%E5%B0%BE%E6%86%B2%E8%BC%94%20%20-%20XyEscape.flac')
end)
end,
},{"5:20AM",
function() runAsyncTask(function() 
 提示("5:20AM")
toggleMusic("http://oss2.e-43.com/uploads/2024/07/09/VHdUTXtd_5%2020AM%20-%20%E5%88%80%E9%85%B1.flac?attname=5%2020AM%20-%20%E5%88%80%E9%85%B1.flac")
end)
end,
},{"落入凡尘",
function() runAsyncTask(function() 
 提示("落入凡尘")
toggleMusic("http://oss2.e-43.com/uploads/2024/07/10/NSASelOw_%E9%BA%A6%E6%8C%AF%E9%B8%BF%20-%20%E9%9B%AA%E8%A7%81%C2%B7%E8%90%BD%E5%85%A5%E5%87%A1%E5%B0%98.flac?attname=%E9%BA%A6%E6%8C%AF%E9%B8%BF%20-%20%E9%9B%AA%E8%A7%81%C2%B7%E8%90%BD%E5%85%A5%E5%87%A1%E5%B0%98.flac")
end)
end,
},{"Counter Attack",
function() runAsyncTask(function() 
 提示("Counter Attack")
toggleMusic("http://oss2.e-43.com/uploads/2024/07/10/8rWJkN4y_Samuel%20Kim%20-%20Counter%20Attack-Mankind%20%28Sasha%20Version%29.flac?attname=Samuel%20Kim%20-%20Counter%20Attack-Mankind%20%28Sasha%20Version%29.flac")
end)
end,
},{"The Runner",
function() runAsyncTask(function() 
 提示("The Runner")
toggleMusic("http://oss2.e-43.com/uploads/2024/07/10/NKeOD20f_Yubik%20-%20The%20Runner.flac?attname=Yubik%20-%20The%20Runner.flac")
end)
end,
},{"LOSER/伴奏/原伴奏",
function() runAsyncTask(function() 
 提示("LOSER/伴奏/原伴奏")
toggleMusic("http://oss2.e-43.com/uploads/2024/08/06/SnQqhamG_%E7%B1%B3%E6%B4%A5%E7%8E%84%E5%B8%AB%20-%20LOSER_%E5%90%88%E5%B9%B6.wav?attname=%E7%B1%B3%E6%B4%A5%E7%8E%84%E5%B8%AB%20-%20LOSER_%E5%90%88%E5%B9%B6.wav")
end)
end,
},{"OAO Wake",
function() runAsyncTask(function() 
 提示("OAO Wake")
toggleMusic("http://oss2.e-43.com/uploads/2024/08/06/WI6DTzlo_OAO%20-%20Wake.flac?attname=OAO%20-%20Wake.flac")
end)
end,
},{"HMHK",
function() runAsyncTask(function() 
 提示("HMHK")
toggleMusic("http://oss2.e-43.com/uploads/2024/11/10/aTRsKNNv_HMHK%20-%20Lifestyle.mp3?attname=HMHK%20-%20Lifestyle.mp3")
end)
end,
},{"此去半生(青衣戏腔版)",
function() runAsyncTask(function() 
 提示("此生过半(戏曲版)")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/17/XXec9web_%E6%AD%A4%E5%8E%BB%E5%8D%8A%E7%94%9F%28%E9%9D%92%E8%A1%A3%E6%88%8F%E8%85%94%E7%89%88%29-%E4%BA%AC%E5%89%A7_%E5%90%B4%E6%98%8A-232505324-4000.flac?attname=%E6%AD%A4%E5%8E%BB%E5%8D%8A%E7%94%9F%28%E9%9D%92%E8%A1%A3%E6%88%8F%E8%85%94%E7%89%88%29-%E4%BA%AC%E5%89%A7_%E5%90%B4%E6%98%8A-232505324-4000.flac')
end)
end,
},{"Daylight DJ(梅菜扣肉)",
function() runAsyncTask(function() 
 提示("Daylight DJ(梅菜扣肉)")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/10/wC29Vynd_%E6%A2%85%E8%8F%9C%E6%89%A3%E8%82%89-%E8%BF%9C%E6%B0%B4%E4%B8%8D%E8%A7%A3%E8%BF%9B%E6%B8%B4-314863600-320.mp3?attname=%E6%A2%85%E8%8F%9C%E6%89%A3%E8%82%89-%E8%BF%9C%E6%B0%B4%E4%B8%8D%E8%A7%A3%E8%BF%9B%E6%B8%B4-314863600-320.mp3')
end)
end,
},{"AM WAY",
function() runAsyncTask(function() 
 提示("AM WAY")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/07/VoxGO8Jn_My%20Way-Veysigz.mp3?attname=My%20Way-Veysigz.mp3')
end)
end,
},{"nop",
function() runAsyncTask(function() 
 提示("nop")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/07/S8CJLbvK_nop-%E9%99%88%E8%B6%8A%E9%BE%99.mp3?attname=nop-%E9%99%88%E8%B6%8A%E9%BE%99.mp3')
end)
end,
},{"Watch",
function() runAsyncTask(function() 
 提示("Watch")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/Aj0SllSd_Watch_Me_Fly-Elliot_Brown-12776137-128.mp3?attname=Watch_Me_Fly-Elliot_Brown-12776137-128.mp3')
end)
end,
},{"Conundrum",
function() runAsyncTask(function() 
 提示("Conundrum")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/kG3wg94B_Conundrum-Audiomachine-386828076-100.ogg?attname=Conundrum-Audiomachine-386828076-100.ogg')
end)
end,
},{"我撕裂我的身体",
function() runAsyncTask(function() 
 提示("我撕裂我的身体")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/gii2fyaT_%E6%88%91%E6%92%95%E8%A3%82%E6%88%91%E7%9A%84%E8%BA%AB%E4%BD%93-MISTERK_Tphunk-261474489-2000.flac?attname=%E6%88%91%E6%92%95%E8%A3%82%E6%88%91%E7%9A%84%E8%BA%AB%E4%BD%93-MISTERK_Tphunk-261474489-2000.flac')
end)
end,
},{"蝴蝶步(PHONK)",
function() runAsyncTask(function() 
 提示("蝴蝶步(PHONK)")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/5xMjF3uK_%E8%9D%B4%E8%9D%B6%E6%AD%A5%28PHONK%29-GTR7-385765042-2000.flac?attname=%E8%9D%B4%E8%9D%B6%E6%AD%A5%28PHONK%29-GTR7-385765042-2000.flac')
end)
end,
},{"无仙",
function() runAsyncTask(function() 
 提示("无仙")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/SsUVGVDv_%E6%97%A0%E4%BB%99-Candy_Wind-68687199-2000.flac?attname=%E6%97%A0%E4%BB%99-Candy_Wind-68687199-2000.flac')
end)
end,
},{"Children",
function() runAsyncTask(function() 
 提示("Children")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/5EuPQggh_Children_Of_The_Dark-Mono_Inc_-28131788-128.mp3?attname=Children_Of_The_Dark-Mono_Inc_-28131788-128.mp3')
end)
end,
},{"China Rain",
function() runAsyncTask(function() 
 提示("China Rain")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/dEt1Ulu5_China-Rain-%E5%BE%90%E6%A2%A6%E5%9C%86-20275380-2000.flac?attname=China-Rain-%E5%BE%90%E6%A2%A6%E5%9C%86-20275380-2000.flac')
end)
end,
},{"color X",
function() runAsyncTask(function() 
 提示("color X")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/09/DNoyfYMd_color-X-%E5%BE%90%E6%A2%A6%E5%9C%86-23658968-2000.flac?attname=color-X-%E5%BE%90%E6%A2%A6%E5%9C%86-23658968-2000.flac')
end)
end,
},{"Sail",
function() runAsyncTask(function() 
 提示("Sail")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/09/TUaGA4XB_Sail-Awolnation_Aaron_R__Bruno-3380454-192.ogg?attname=Sail-Awolnation_Aaron_R__Bruno-3380454-192.ogg')
end)
end,
},{"广寒谣",
function() runAsyncTask(function() 
 提示("广寒谣")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/09/HUVvgYs6_%E5%B9%BF%E5%AF%92%E8%B0%A3-%E4%BC%8A%E6%A0%BC%E8%B5%9B%E5%90%AC_%E4%B8%8D%E9%9D%A0%E8%B0%B1%E7%BB%84%E5%90%88-83594003-2000.flac?attname=%E5%B9%BF%E5%AF%92%E8%B0%A3-%E4%BC%8A%E6%A0%BC%E8%B5%9B%E5%90%AC_%E4%B8%8D%E9%9D%A0%E8%B0%B1%E7%BB%84%E5%90%88-83594003-2000.flac')
end)
end,
},{"ID EDIT MIX",
function() runAsyncTask(function() 
 提示("ID EDIT MIX")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/kVkagibg_ID_EDIT_MIX-HINA-325465869-2000.flac?attname=ID_EDIT_MIX-HINA-325465869-2000.flac')
end)
end,
},{"My Confession",
function() runAsyncTask(function() 
 提示("My Confession")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/RE3mIV0Y_My_Confession-Mark_Stewart_Anderson-293262730-320.mp3?attname=My_Confession-Mark_Stewart_Anderson-293262730-320.mp3')
end)
end,
},{"Just Friends(Explicit)",
function() runAsyncTask(function() 
 提示("Just Friends(Explicit)")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/08/dXvTsSn2_Just_Friends(Explicit)-Hayden_James_Boy_Matthews-47019211-2000.flac?attname=Just_Friends%28Explicit%29-Hayden_James_Boy_Matthews-47019211-2000.flac')
end)
end,
},{"Death Is No More",
function() runAsyncTask(function() 
 提示("Death Is No More")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/30/aGGj38KC_Death_Is_No_More-BLESSED_MANE-164190940-2000.flac?attname=Death_Is_No_More-BLESSED_MANE-164190940-2000.flac')
end)
end,
},{"爱的虚伪(Remix)",
function() runAsyncTask(function() 
 提示("爱的虚伪(Remix)")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/30/9PmswuSR_%E7%88%B1%E7%9A%84%E8%99%9A%E4%BC%AA%28Remix%29-%E6%9B%B2%E8%82%96%E5%86%B0-304665249-128.mp3?attname=%E7%88%B1%E7%9A%84%E8%99%9A%E4%BC%AA%28Remix%29-%E6%9B%B2%E8%82%96%E5%86%B0-304665249-128.mp3')
end)
end,
},{"仙尊合集 AkinoYuno",
function() runAsyncTask(function() 
 提示("仙尊合集 AkinoYuno")
toggleMusic('http://oss2.e-43.com/uploads/2024/08/30/r2zqZbr2_%E4%BB%99%E5%B0%8A%E5%90%88%E9%9B%86-AkinoYuno-399249048-2000.flac?attname=%E4%BB%99%E5%B0%8A%E5%90%88%E9%9B%86-AkinoYuno-399249048-2000.flac')
end)
end,
},{"Chasing the Dragon",
function() runAsyncTask(function() 
 提示("Chasing the Dragon")
toggleMusic('http://oss2.e-43.com/uploads/2024/09/06/n1kF7WQB_Chasing_the_Dragon-Getsix-170518983-2000.flac?attname=Chasing_the_Dragon-Getsix-170518983-2000.flac')
end)
end,
},{"Shadow Lady",
function() runAsyncTask(function() 
 提示("Shadow Lady")
toggleMusic('http://oss2.e-43.com/uploads/2024/09/06/yCqWQFTR_Shadow_Lady-Portwave_Dmitriy_Protsenko-83806147-2000.flac?attname=Shadow_Lady-Portwave_Dmitriy_Protsenko-83806147-2000.flac')
end)
end,
},{"海琼斯小夜曲",
function() runAsyncTask(function() 
 提示("海琼斯小夜曲")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/03/6l0i21R8_%E6%B5%B7%E7%90%BC%E6%96%AF%E5%B0%8F%E5%A4%9C%E6%9B%B2-%E8%93%9D%E9%B1%BC_-184818461-128.mp3?attname=%E6%B5%B7%E7%90%BC%E6%96%AF%E5%B0%8F%E5%A4%9C%E6%9B%B2-%E8%93%9D%E9%B1%BC_-184818461-128.mp3')
end)
end,
},{"如果耳机有回音",
function() runAsyncTask(function() 
 提示("如果耳机有回音")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/03/h7wcVN28_%E5%A6%82%E6%9E%9C%E8%80%B3%E6%9C%BA%E6%9C%89%E5%9B%9E%E9%9F%B3-%E5%A5%B6%E7%89%87ouo-417821580-2000.flac?attname=%E5%A6%82%E6%9E%9C%E8%80%B3%E6%9C%BA%E6%9C%89%E5%9B%9E%E9%9F%B3-%E5%A5%B6%E7%89%87ouo-417821580-2000.flac')
end)
end,
},{"原野追逐",
function() runAsyncTask(function() 
 提示("原野追逐")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/03/Gm8GRUdn_%E5%8E%9F%E9%87%8E%E8%BF%BD%E9%80%90_%28%E4%B8%8D%E8%A6%81%E6%B8%A9%E5%92%8C%E8%B5%B0%E5%85%A5%E9%82%A3%E8%89%AF%E5%A4%9C%29-%E7%81%B5%E9%AD%82%E9%85%8D%E4%B9%90%E5%B8%88-372154679-2000.flac?attname=%E5%8E%9F%E9%87%8E%E8%BF%BD%E9%80%90_%28%E4%B8%8D%E8%A6%81%E6%B8%A9%E5%92%8C%E8%B5%B0%E5%85%A5%E9%82%A3%E8%89%AF%E5%A4%9C%29-%E7%81%B5%E9%AD%82%E9%85%8D%E4%B9%90%E5%B8%88-372154679-2000.flac')
end)
end,
},{"Cornfield Chase",
function() runAsyncTask(function() 
 提示("Cornfield Chase")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/03/vpzhhuzx_Cornfield_Chase%28%E7%BA%AF%E9%9F%B3%E4%B9%90%E7%89%88%29-Hans_Zimmer-6367860-2000.flac?attname=Cornfield_Chase%28%E7%BA%AF%E9%9F%B3%E4%B9%90%E7%89%88%29-Hans_Zimmer-6367860-2000.flac')
end)
end,
},{"doodle",
function() runAsyncTask(function() 
 提示("doodle")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/03/AGNtdiqt_doodle-Zachz_Winner-338938940-2000.flac?attname=doodle-Zachz_Winner-338938940-2000.flac')
end)
end,
},{"窒 Suffocating",
function() runAsyncTask(function() 
 提示("窒 Suffocating")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/10/cVXZQlHj_%E5%8F%88%E6%98%AF%E5%BF%AB%E4%B9%90%E7%9A%84%E4%B8%80%E5%A4%A9%20-%20%E3%80%8A%E7%AA%92%20Suffocating%E3%80%8B%E6%8B%BC%E9%9F%B3%E5%B8%88BGM&Lona.X%20%E5%B0%8F%E6%96%B0%EF%BC%9A%E7%BA%AF%E9%9F%B3%E4%B9%90%EF%BC%8C%E8%AF%B7%E6%AC%A3%E8%B5%8F.mp3?attname=%E5%8F%88%E6%98%AF%E5%BF%AB%E4%B9%90%E7%9A%84%E4%B8%80%E5%A4%A9%20-%20%E3%80%8A%E7%AA%92%20Suffocating%E3%80%8B%E6%8B%BC%E9%9F%B3%E5%B8%88BGM&Lona.X%20%E5%B0%8F%E6%96%B0%EF%BC%9A%E7%BA%AF%E9%9F%B3%E4%B9%90%EF%BC%8C%E8%AF%B7%E6%AC%A3%E8%B5%8F.mp3')
end)
end,
},{"Glichery Sea Of Problems (Explicit)",
function() runAsyncTask(function() 
 提示("Glichery Sea Of Problems (Explicit)")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/10/wPVuZECH_Glichery%20-%20Sea%20Of%20Problems%20%28Explicit%29.flac?attname=Glichery%20-%20Sea%20Of%20Problems%20%28Explicit%29.flac')
end)
end,
},{"防空警报...",
function() runAsyncTask(function() 
 提示("防空警报...")
toggleMusic('http://oss2.e-43.com/uploads/2024/12/01/S6Ty4Dyc_42865095.128.vcc.mp3?attname=42865095.128.vcc.mp3')
end)
end,
},{"星と僕らと",
function() runAsyncTask(function() 
 提示("星と僕らと")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/29/phXNP1Yx_%E6%98%9F%E3%81%A8%E5%83%95%E3%82%89%E3%81%A8_%28tofubeats_Remix%29-%E7%9B%AE%E9%BB%92%E5%B0%86%E5%8F%B8-63514193-2000.flac?attname=%E6%98%9F%E3%81%A8%E5%83%95%E3%82%89%E3%81%A8_%28tofubeats_Remix%29-%E7%9B%AE%E9%BB%92%E5%B0%86%E5%8F%B8-63514193-2000.flac')
end)
end,
},{"Cry For Me",
function() runAsyncTask(function() 
 提示("Cry For Me")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/29/JmeA5neJ_Cry_For_Me_(feat__Ami)-Michita_Ami-396482335-2000.flac?attname=Cry_For_Me_%28feat__Ami%29-Michita_Ami-396482335-2000.flac')
end)
end,
},{"EEYUH! x Fluxxwave",
function() runAsyncTask(function() 
 提示("EEYUH! x Fluxxwave")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/29/3dBX8T6L_EEYUH__x_Fluxxwave-Clovis_Reyes_Hr_Irokz-370941571-2000.flac?attname=EEYUH__x_Fluxxwave-Clovis_Reyes_Hr_Irokz-370941571-2000.flac')
end)
end,
},{"SCARSONG",
function() runAsyncTask(function() 
 提示("SCARSONG")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/29/jZKTyIwe_SCARSONG-flash8-51498270-320.mp3?attname=SCARSONG-flash8-51498270-320.mp3')
end)
end,
},{"X-GALACTICO",
function() runAsyncTask(function() 
 提示("X-GALACTICO")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/29/JJ25p3rm_X-GALACTICO.mp3?attname=X-GALACTICO.mp3')
end)
end,
},{"所有心事都放晴(新版)",
function() runAsyncTask(function() 
 提示("所有心事都放晴(新版)")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/29/DJdhyrAI_%E6%89%80%E6%9C%89%E5%BF%83%E4%BA%8B%E9%83%BD%E6%94%BE%E6%99%B4_%28%E6%96%B0%E7%89%88%29-%E6%97%A9%E6%99%9A%E6%99%9A-434771089-2000.flac?attname=%E6%89%80%E6%9C%89%E5%BF%83%E4%BA%8B%E9%83%BD%E6%94%BE%E6%99%B4_%28%E6%96%B0%E7%89%88%29-%E6%97%A9%E6%99%9A%E6%99%9A-434771089-2000.flac')
end)
end,
},{"所有心事都放晴(航天小曲DJ)",
function() runAsyncTask(function() 
 提示("所有心事都放晴(航天小曲DJ)")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/29/T4Yh840E_%E6%89%80%E6%9C%89%E5%BF%83%E4%BA%8B%E9%83%BD%E6%94%BE%E6%99%B4_%28%E8%88%AA%E5%A4%A9%E5%B0%8F%E6%9B%B2DJ%29-%E8%BD%A6%E5%8F%8BDJ%E5%A4%A7%E5%A4%A7-433694969-320.mp3?attname=%E6%89%80%E6%9C%89%E5%BF%83%E4%BA%8B%E9%83%BD%E6%94%BE%E6%99%B4_%28%E8%88%AA%E5%A4%A9%E5%B0%8F%E6%9B%B2DJ%29-%E8%BD%A6%E5%8F%8BDJ%E5%A4%A7%E5%A4%A7-433694969-320.mp3')
end)
end,
},{"所有心事都放晴-尤宏",
function() runAsyncTask(function() 
 提示("所有心事都放晴")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/29/jNIp2M2b_%E6%89%80%E6%9C%89%E5%BF%83%E4%BA%8B%E9%83%BD%E6%94%BE%E6%99%B4-%E5%B0%A4%E5%AE%8F-412688497-2000.flac?attname=%E6%89%80%E6%9C%89%E5%BF%83%E4%BA%8B%E9%83%BD%E6%94%BE%E6%99%B4-%E5%B0%A4%E5%AE%8F-412688497-2000.flac')
end)
end,
},{"但-草东没有派对",
function() runAsyncTask(function() 
 提示("但-草东没有派对")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/30/y61u8BAU_%E4%BD%86-%E8%8D%89%E4%B8%9C%E6%B2%A1%E6%9C%89%E6%B4%BE%E5%AF%B9-269038147-2000.flac?attname=%E4%BD%86-%E8%8D%89%E4%B8%9C%E6%B2%A1%E6%9C%89%E6%B4%BE%E5%AF%B9-269038147-2000.flac')
end)
end,
},{"烂泥-草东没有派对",
function() runAsyncTask(function() 
 提示("烂泥-草东没有派对")
toggleMusic('http://oss2.e-43.com/uploads/2025/03/21/qb1bZH2p_%E7%83%82%E6%B3%A5-%E8%8D%89%E4%B8%9C%E6%B2%A1%E6%9C%89%E6%B4%BE%E5%AF%B9-7065590-2000.flac?attname=%E7%83%82%E6%B3%A5-%E8%8D%89%E4%B8%9C%E6%B2%A1%E6%9C%89%E6%B4%BE%E5%AF%B9-7065590-2000.flac')
end)
end,
},{"莫名其妙的BGM",
function() runAsyncTask(function() 
 提示("莫名其妙的BGM")
toggleMusic('http://oss2.e-43.com/uploads/2024/11/30/1T7yubZc_%E8%8E%AB%E5%90%8D%E5%85%B6%E5%A6%99%E7%9A%84BGM-AEC-419737865-2000.flac?attname=%E8%8E%AB%E5%90%8D%E5%85%B6%E5%A6%99%E7%9A%84BGM-AEC-419737865-2000.flac')
end)
end,
},{"え！？やば、、、、",
function() runAsyncTask(function() 
 提示("え！？やば、、、、")
toggleMusic('http://oss2.e-43.com/uploads/2024/12/13/ECjpctKg_%E3%81%88%EF%BC%81%EF%BC%9F%E3%82%84%E3%81%B0%E3%80%81%E3%80%81%E3%80%81%E3%80%81-%E3%81%95%E3%82%93%E3%81%86%E3%81%95%E3%81%8E-266713696-2000.flac?attname=%E3%81%88%EF%BC%81%EF%BC%9F%E3%82%84%E3%81%B0%E3%80%81%E3%80%81%E3%80%81%E3%80%81-%E3%81%95%E3%82%93%E3%81%86%E3%81%95%E3%81%8E-266713696-2000.flac')
end)
end,
},{"lovely",
function() runAsyncTask(function() 
 提示("lovely")
toggleMusic('http://oss2.e-43.com/uploads/2025/03/21/zpBROSm8_lovely-Billie_Eilish_Khalid-41209455-2000.flac?attname=lovely-Billie_Eilish_Khalid-41209455-2000.flac')
end)
end,
},{"Savage-Bahari",
function() runAsyncTask(function() 
 提示("Savage-Bahari")
toggleMusic('http://oss2.e-43.com/uploads/2025/03/21/YH3iqm0u_Savage-Bahari-145232697-2000.flac?attname=Savage-Bahari-145232697-2000.flac')
end)
end,
},{"Towards the Light",
function() runAsyncTask(function() 
 提示("Towards the Light")
toggleMusic('http://oss2.e-43.com/uploads/2025/03/21/VGLaskQU_Towards_the_Light-Jacoo-155378832-2000.flac?attname=Towards_the_Light-Jacoo-155378832-2000.flac')
end)
end,
},{"End (Interlude)",
function() runAsyncTask(function() 
 提示("End (Interlude)")
toggleMusic('http://oss2.e-43.com/uploads/2025/03/21/V09glivF_End_(Interlude)-Sadako-160055990-192.ogg?attname=End_%28Interlude%29-Sadako-160055990-192.ogg')
end)
end,
},{"LOW (PHONK)",
function() runAsyncTask(function() 
 提示("LOW (PHONK)")
toggleMusic('http://oss2.e-43.com/uploads/2025/03/21/zjsBjK9A_LOW_%28PHONK%29-%E8%80%B3%E6%9C%B5%E8%B6%85%E5%B8%82-441796380-2000.flac?attname=LOW_%28PHONK%29-%E8%80%B3%E6%9C%B5%E8%B6%85%E5%B8%82-441796380-2000.flac')
end)
end,
},{"天真的橡皮 (DJ版)",
function() runAsyncTask(function() 
 提示("天真的橡皮 (DJ版)")
toggleMusic('http://oss2.e-43.com/uploads/2025/04/20/oCJLSwfP_%E5%A4%A9%E7%9C%9F%E7%9A%84%E6%A9%A1%E7%9A%AE_%28DJ%E7%89%88%29-%E7%99%BD%E6%B0%B4%E5%AF%92-366417693-100.ogg?attname=%E5%A4%A9%E7%9C%9F%E7%9A%84%E6%A9%A1%E7%9A%AE_%28DJ%E7%89%88%29-%E7%99%BD%E6%B0%B4%E5%AF%92-366417693-100.ogg')
end)
end,
},{"未闻花名",
function() runAsyncTask(function() 
 提示("未闻花名")
toggleMusic('http://oss2.e-43.com/uploads/2025/05/03/3mdJCfMU_secret_base_%EF%BD%9E%E5%90%9B%E3%81%8C%E3%81%8F%E3%82%8C%E3%81%9F%E3%82%82%E3%81%AE%EF%BD%9E_%2810_years_after_Ver_%29-%E8%8C%85%E9%87%8E%E6%84%9B%E8%A1%A3_%E6%88%B8%E6%9D%BE%E9%81%A5_%E6%97%A9%E8%A6%8B%E6%B2%99%E7%B9%94-169738803-2000.flac?attname=secret_base_%EF%BD%9E%E5%90%9B%E3%81%8C%E3%81%8F%E3%82%8C%E3%81%9F%E3%82%82%E3%81%AE%EF%BD%9E_%2810_years_after_Ver_%29-%E8%8C%85%E9%87%8E%E6%84%9B%E8%A1%A3_%E6%88%B8%E6%9D%BE%E9%81%A5_%E6%97%A9%E8%A6%8B%E6%B2%99%E7%B9%94-169738803-2000.flac')
end)
end,
},{"知我(剑来)/伴奏",
function() runAsyncTask(function() 
 提示("知我(剑来)/伴奏")
toggleMusic('http://oss2.e-43.com/uploads/2025/07/20/xWxtwMOu_%E5%9B%BD%E9%A3%8E%E5%A0%82%20%E5%93%A6%E6%BC%8F%20-%20%E7%9F%A5%E6%88%91_%E5%90%88%E5%B9%B6.wav?attname=%E5%9B%BD%E9%A3%8E%E5%A0%82%20%E5%93%A6%E6%BC%8F%20-%20%E7%9F%A5%E6%88%91_%E5%90%88%E5%B9%B6.wav')
end)
end,
},{"バケモノの唄(Inst.)",
function() runAsyncTask(function() 
 提示("バケモノの唄(Inst.)")
toggleMusic('http://oss2.e-43.com/uploads/2025/05/10/2upPNPe2_%E3%83%90%E3%82%B1%E3%83%A2%E3%83%8E%E3%81%AE%E5%94%84_%28Inst_%29-shino-273294608-2000.flac?attname=%E3%83%90%E3%82%B1%E3%83%A2%E3%83%8E%E3%81%AE%E5%94%84_%28Inst_%29-shino-273294608-2000.flac')
end)
end,
},{"Untitled Slowed",
function() runAsyncTask(function() 
 提示("Untitled Slowed")
toggleMusic('http://oss2.e-43.com/uploads/2025/05/17/nXUhaONK_Untitled_Slowed-CaugarLion-293840956-2000.flac?attname=Untitled_Slowed-CaugarLion-293840956-2000.flac')
end)
end,
},{"Baby, Don't Cry(人鱼的眼泪)",
function() runAsyncTask(function() 
 提示("Baby, Don't Cry(人鱼的眼泪)")
toggleMusic('http://oss2.e-43.com/uploads/2025/05/17/mACRjn5m_Baby_Don%27t_Cry_%28%E4%BA%BA%E9%B1%BC%E7%9A%84%E7%9C%BC%E6%B3%AA%29-EXO-10494677-2000.flac?attname=Baby_Don%27t_Cry_%28%E4%BA%BA%E9%B1%BC%E7%9A%84%E7%9C%BC%E6%B3%AA%29-EXO-10494677-2000.flac')
end)
end,
},{"Baby, Don't Cry(非原伴奏)",
function() runAsyncTask(function() 
 提示("Baby, Don't Cry(非原伴奏)")
toggleMusic('http://oss2.e-43.com/uploads/2025/05/17/S4HFyt7z_Baby_don%27t_Cry_%28%E4%BC%B4%E5%A5%8F%29-%E5%92%A9%E5%92%A9%E4%BE%9D-396657213-320.mp3?attname=Baby_don%27t_Cry_%28%E4%BC%B4%E5%A5%8F%29-%E5%92%A9%E5%92%A9%E4%BE%9D-396657213-320.mp3')
end)
end,
},{"Rise进行曲",
function() runAsyncTask(function() 
 提示("Rise进行曲")
toggleMusic('http://oss2.e-43.com/uploads/2025/05/23/erQgAiyn_Rise%E8%BF%9B%E8%A1%8C%E6%9B%B2-DJ%E5%95%8A%E6%99%BA-456292464-2000.flac?attname=Rise%E8%BF%9B%E8%A1%8C%E6%9B%B2-DJ%E5%95%8A%E6%99%BA-456292464-2000.flac')
end)
end,
},{"Savage (bitmastr remix)",
function() runAsyncTask(function() 
 提示("Savage (bitmastr remix)")
toggleMusic('http://oss2.e-43.com/uploads/2025/05/23/TRsFQdBv_Savage_(bitmastr_remix)-Bahari-153921378-2000.flac?attname=Savage_%28bitmastr_remix%29-Bahari-153921378-2000.flac')
end)
end,
},{"不愿回头",
function() runAsyncTask(function() 
 提示("不愿回头")
toggleMusic('http://oss2.e-43.com/uploads/2025/06/01/mvk93wb7_%E4%B8%8D%E6%84%BF%E5%9B%9E%E5%A4%B4-%E5%8D%97%E5%BE%81%E5%8C%97%E6%88%98NZBZ-7185615-2000.flac?attname=%E4%B8%8D%E6%84%BF%E5%9B%9E%E5%A4%B4-%E5%8D%97%E5%BE%81%E5%8C%97%E6%88%98NZBZ-7185615-2000.flac')
end)
end,
},{"不愿回头(原版伴奏)",
function() runAsyncTask(function() 
 提示("不愿回头(原版伴奏)")
toggleMusic('http://oss2.e-43.com/uploads/2025/06/01/OMES5bza_%E4%B8%8D%E6%84%BF%E5%9B%9E%E5%A4%B4_%28%E5%8E%9F%E7%89%88%E4%BC%B4%E5%A5%8F%29-%E5%8D%97%E5%BE%81%E5%8C%97%E6%88%98NZBZ-77405784-2000.flac?attname=%E4%B8%8D%E6%84%BF%E5%9B%9E%E5%A4%B4_%28%E5%8E%9F%E7%89%88%E4%BC%B4%E5%A5%8F%29-%E5%8D%97%E5%BE%81%E5%8C%97%E6%88%98NZBZ-77405784-2000.flac')
end)
end,
},{"東京上空",
function() runAsyncTask(function() 
 提示("東京上空")
toggleMusic('http://oss2.e-43.com/uploads/2025/07/31/n7oKJZ28_%E6%9D%B1%E4%BA%AC%E4%B8%8A%E7%A9%BA-RADWIMPS-246876791-2000.flac?attname=%E6%9D%B1%E4%BA%AC%E4%B8%8A%E7%A9%BA-RADWIMPS-246876791-2000.flac')
end)
end,
},{"PASSO BEM SOLTO",
function() runAsyncTask(function() 
 提示("PASSO BEM SOLTO")
toggleMusic('http://oss2.e-43.com/uploads/2025/07/31/w8Pm8tq8_PASSO%20BEM%20SOLTO-Atlxs&Emirhxn.mp3?attname=PASSO%20BEM%20SOLTO-Atlxs&Emirhxn.mp3')
end)
end,
},{"Crucified",
function() runAsyncTask(function() 
 提示("Crucified")
toggleMusic('http://oss2.e-43.com/uploads/2025/07/31/mmjpIIPD_Crucified-Army_Of_Lovers-2498871-128.mp3?attname=Crucified-Army_Of_Lovers-2498871-128.mp3')
end)
end,
},{"Automotivo Bayside 2.0",
function() runAsyncTask(function() 
 提示("Automotivo Bayside 2.0")
toggleMusic('http://oss2.e-43.com/uploads/2025/07/31/Ai64ewcH_Automotivo_Bayside_2_0-TOKYOPHILE-341654537-2000.flac?attname=Automotivo_Bayside_2_0-TOKYOPHILE-341654537-2000.flac')
end)
end,
},{"Eu Sento Gabu (BGM)",
function() runAsyncTask(function() 
 提示("Eu Sento Gabu (BGM)")
toggleMusic('http://oss2.e-43.com/uploads/2025/07/31/nY6ygI2O_Eu_Sento_Gabu_(BGM)-Don81-415392114-320.mp3?attname=Eu_Sento_Gabu_%28BGM%29-Don81-415392114-320.mp3')
end)
end,
},{"SPACE!",
function() runAsyncTask(function() 
 提示("SPACE!")
toggleMusic('http://oss2.e-43.com/uploads/2025/07/31/zp8LzM6d_SPACE_-NAOMI-365676628-2000.flac?attname=SPACE_-NAOMI-365676628-2000.flac')
end)
end,
},{"Hi",
function() runAsyncTask(function() 
 提示("Hi")
toggleMusic('http://oss2.e-43.com/uploads/2025/07/31/9fmZOb3f_Hi-TEMPOREX-452670062-2000.flac?attname=Hi-TEMPOREX-452670062-2000.flac')
end)
end,
},{"Six Forty Seven",
function() runAsyncTask(function() 
 提示("Six Forty Seven")
toggleMusic('http://oss2.e-43.com/uploads/2025/07/31/sh9l27Xt_Six_Forty_Seven-Instupendo-168236786-2000.flac?attname=Six_Forty_Seven-Instupendo-168236786-2000.flac')
end)
end,
},{"track1",
function() runAsyncTask(function() 
 提示("track1")
toggleMusic('http://oss2.e-43.com/uploads/2025/08/08/yqxyWndo_track1-%E9%93%83%E6%9C%A8%E5%B7%9D-452520290-2000.flac?attname=track1-%E9%93%83%E6%9C%A8%E5%B7%9D-452520290-2000.flac')
end)
end,
},{"hypnotic (super slowed)",
function() runAsyncTask(function() 
 提示("hypnotic (super slowed)")
toggleMusic('http://oss2.e-43.com/uploads/2025/08/08/rlTq90bf_hypnotic_(super_slowed)-ISQ-377641456-2000.flac?attname=hypnotic_%28super_slowed%29-ISQ-377641456-2000.flac')
end)
end,
}
}),
}),
RG.button("(暂停/继续)播放音乐",
function() runAsyncTask(function() 
    togglePause()
end) end
),
RG.button("(停止)播放音乐",
function() runAsyncTask(function() 
    stopMusic()
end) end
),
RG.line(),
RG.box({"闪退功能",---box示例 可以删掉
RG.button("进入虚幻世界",
function() enqueueTask(function()

HK()

gg.clearResults()
 gg.setRanges(16384)
 gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
 if gg.getResultCount() == 0 then
提示("进入失败")
else
 gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
 gg.getResults(10000)
 gg.editAll("2.1115616", gg.TYPE_FLOAT)
 提示("进入成功")
 gg.clearResults()
 end
 


end) end),
RG.button("回到现实(有后遗症",

function() enqueueTask(function()

HK()

gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("2.1115616", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("返回失败")
else
gg.searchNumber("2.1115616", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(10000)
gg.editAll("1", gg.TYPE_FLOAT)
提示("返回成功,会有后遗症")
gg.clearResults()
end
 


end) end),
RG.button("薄雾",
function() enqueueTask(function()

HK()

szwq='-0.55641'
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("0.00999999978", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("0.00999999978", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("-0.55641", gg.TYPE_FLOAT)
提示("薄雾")
gg.clearResults()
end) end),
RG.button("浓雾",
function() enqueueTask(function()

HK()

 szwq='999.346621' 
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("0.00999999978", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("0.00999999978", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("999.346621", gg.TYPE_FLOAT)
提示("浓雾")
gg.clearResults()
end) end),
RG.button("除雾",
function() enqueueTask(function()

HK()

szwq='0.000000000000000000000001'
 提示("清除天边的雾")
 gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("0.00999999978", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("0.00999999978", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("0.000000000000000000000001", gg.TYPE_FLOAT)
提示("除雾")
gg.clearResults()
end) end),
RG.button("恢复雾气",
function() enqueueTask(function()

HK()

 gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber(szwq, gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("0.00999999978", gg.TYPE_FLOAT)
提示("恢复完成")
gg.clearResults()
end) end),

RG.button("地图背景转换", 
function() enqueueTask(function()

HK()
 
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber("0.00999999978", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("0", gg.TYPE_FLOAT)
 提示("开启成功") 
gg.clearResults()



end) end),
}),
RG.line(),
RG.radio({
 "较实用功能",
{"破隐(自定义)",
function() enqueueTask(function()
HK()
破隐自定义()
end) end,
},{"破隐",
function() enqueueTask(function()
HK()
破隐()
end) end,
},{"海王盾变红色",
function() enqueueTask(function()
HK()
海王盾变红色()
end) end,
},{"海王盾变深红色",
function() enqueueTask(function()
HK()
海王盾变深红色()
end) end,
},{"海王盾变青与红色",
function() enqueueTask(function()
HK()
海王盾变青与红色()
end) end,
},{"地面透明",
function() enqueueTask(function()
HK()
地面透明()
end) end,
},
{"恢复以上功能",
function() enqueueTask(function()
HK()
恢复以上功能()
end) end,
},
{"隐藏UI",
function() enqueueTask(function()
HK()
隐藏UI()
end) end,
},
{"隐藏UI②",
function() enqueueTask(function()
HK()
隐藏UI2()
end) end,
},
{"恢复UI",
function() enqueueTask(function()
HK()
恢复UI()
end) end,
},
{"无法移动",
function() enqueueTask(function()
HK()
无法移动()
end) end,
},
{"恢复移动",
function() enqueueTask(function()
HK()
恢复移动()
end) end,
},
{"视角锁定",
function() enqueueTask(function()
HK()
视角锁定()
end) end,
},{"恢复视角",
function() enqueueTask(function()
HK()
恢复视角()
end) end,
},{"特效加速",
function() enqueueTask(function()
HK()
特效加速()
end) end ,
},{"特效减速",
function() enqueueTask(function()
HK()
特效减速()
end) end,
},{"恢复特效速度",
function() enqueueTask(function()
HK()
恢复特效速度()
end) end,
},{"钻地[可车体]" ,
function() enqueueTask(function()
HK()
钻地车体()
end) end,
},
{"钻地(悬空)[推荐解体]" ,
function() enqueueTask(function()
HK()
钻地悬空推荐解体()
end) end,
},{"脱离卡实体墙(解体用)" ,
function() enqueueTask(function()
HK()
脱离卡实体墙解体用()
end) end,
},
{"恢复钻地(解体用)" ,
function() enqueueTask(function()
HK()
恢复钻地解体用()
end) end,
},
{"全图毒人(直接版)开" ,
function() enqueueTask(function()
HK()
全图毒人直接版开()
end) end,
},
{"全图毒人(直接版)关" ,
function() enqueueTask(function()
HK()
全图毒人直接版关()
end) end,
},
{"毒人Promax开" ,
function() enqueueTask(function()
HK()
毒人Promax开()
end) end,
},{"毒人Promax关",
function() enqueueTask(function()
HK()
毒人Promax关()
end) end,
},{"远程拾取范围",
function() enqueueTask(function()
HK()
远程拾取范围()
end) end,
},{"弱网",
function() enqueueTask(function()
HK()
弱网()
end) end,
},{"恢复弱网",
function() enqueueTask(function()
HK()
恢复弱网()
end) end,
}, {"删除地图",
function() enqueueTask(function()
HK()
删除地图()
end) end,
},{"恢复删除地图",
function() enqueueTask(function()
HK()
恢复删除地图()
end) end,
},{"爬墙",
function() enqueueTask(function()
HK()
爬墙()
end) end,
},{"穿墙(推荐解体" ,
function() enqueueTask(function()
HK()
穿墙推荐解体()
end) end,
},{"自定义倾斜角度",
function() enqueueTask(function()
HK()
自定义倾斜角度()
end) end,
},{"不倒翁",
function() enqueueTask(function()
HK()
不倒翁()
end) end,
},{"反向不倒翁",
function() enqueueTask(function()
HK()
反向不倒翁()
end) end,
},{"转圈圈",
function() enqueueTask(function()
HK()
转圈圈()
end) end,
},{"自定义转圈圈",
function() enqueueTask(function()
HK()
自定义转圈圈()
end) end,
},{"恢复",
function() enqueueTask(function()
恢复娱乐功能()
end) end,
},
}),
RG.switch("手机连续振动",
function() luajava.newThread(function()
提示('开启')
zhendong=true
while zhendong==true do gg.sleep(300)--振动频率0.3秒 
vibra:vibrate(35) --振动强度(没试过100，自己逝，手机出问题别找我
end
end):start() end,
function()
提示('关闭')
zhendong=false
end
),
},
{--5
RG.check({"是否封号取决于你的演技",}),
RG.check({"功能在本质上没有改变,只是将效果缩小",}),
RG.check({"记得开防封",}),
RG.button("无后坐力",
function() enqueueTask(function()
HK()
search(1077149696,4,neicun)
py1(1071644672,4,-96)
py1(1202590843,4,-52)
xg3(0,64,236,true,true,"(自定义后坐力)")
end) end),
RG.button("恢复后坐",
function() enqueueTask(function()
HK()
search(1077149696,4,neicun)
py1(1071644672,4,-96)
py1(1202590843,4,-52)
xg1(100,64,236,false)
end) end),
RG.check({"范围伤害",}),
RG.box({"设置范围伤害",
RG.box1({"设置核心范围",
RG.switch("萌新范围",
function() luajava.newThread(function()
HK()
萌新范围开()
end):start() end,
function()
HK()
萌新范围关()
end
),
RG.switch("铠鼠范围",
function() luajava.newThread(function()
HK()
铠鼠范围开()
end):start() end,
function()
HK()
铠鼠范围关()
end
),
RG.switch("火萤范围",
function() luajava.newThread(function()
HK()
火萤范围开()
end):start() end,
function()
HK()
火萤范围关()
end
),
RG.switch("风声范围",
function() luajava.newThread(function()
HK()
风声范围开()
end):start() end,
function()
HK()
风声范围关()
end
),
RG.switch("大家伙范围",
function() luajava.newThread(function()
HK()
大家伙范围开()
end):start() end,
function()
HK()
大家伙范围关()
end
),
RG.switch("夜莺范围",
function() luajava.newThread(function()
HK()
夜莺范围开()
end):start() end,
function()
HK()
夜莺范围关()
end
),
RG.switch("网虫范围",
function() luajava.newThread(function()
HK()
网虫范围开()
end):start() end,
function()
HK()
网虫范围关()
end
),
RG.switch("幻灵范围",
function() luajava.newThread(function()
HK()
幻灵范围开()
end):start() end,
function()
HK()
幻灵范围关()
end
),
RG.switch("铁驭/赋能/序列范围",
function() luajava.newThread(function()
HK()
铁驭范围开()
end):start() end,
function()
HK()
铁驭范围关()
end
),
RG.button('一键开启核心范围',
function() luajava.newThread(function()
HK()
一键开启核心范围执行()
end):start() end),
RG.button('一键关闭核心范围',
function() luajava.newThread(function()
HK()
一键关闭核心范围执行()
end):start() end),
}),
RG.line(),
RG.check({"false/true",}),
RG.switch("是/否冻结以下范围修改",
function() luajava.newThread(function()
是否冻结切换(true)
提示("已切换为冻结范围")
end):start() end,
function()
是否冻结切换(false)
HA()
提示("已切换为非冻结范围")
end
),
RG.check({"关/开",}),
RG.switch("秒杀范围回拉",
function() luajava.newThread(function()
回拉值切换(true)
提示("已开启秒杀范围回拉")
end):start() end,
function()
回拉值切换(false)
提示("已关闭秒杀范围回拉")
end
),
RG.check({"浮点/二进制",}),
RG.switch("车体范围切换",
function() luajava.newThread(function()
msfwqh = true 
提示("已切换为二进制版本秒杀范围")
end):start() end,
function()
msfwqh = false 
提示("已切换为浮点版本秒杀范围")
end
),
RG.check({"关/开",}),
RG.switch("子弹无伤",
function() luajava.newThread(function()
HK()
子弹无伤开()
end):start() end,
function()
HK()
子弹无伤关()
end
),
RG.check({"关/开",}),
RG.switch("子弹打盾无伤",
function() luajava.newThread(function()
HK()
子弹打盾无伤开()
end):start() end,
function()
HK()
子弹打盾无伤关()
end
),
RG.check({"2级/1级",}),
RG.switch("模块增伤伤害等级",
function() luajava.newThread(function()
HK()
setDamageLevel(1)
end):start() end,
function()
HK()
setDamageLevel(2)
end
),
RG.line(),
RG.box1({"模块增伤",
RG.switch("上等兵",
function() enqueueTask(function()
HK()
zengshang(4020,1)
end) end,
function()
HK()
zengshang(4020,0)
end
),
RG.switch("午夜派对",
function() enqueueTask(function()
HK()
zengshang(4040,1)
end) end,
function()
HK()
zengshang(4040,0)
end
),
RG.switch("碧蓝使者",
function() enqueueTask(function()
HK()
zengshang(4140,1)
end) end,
function()
HK()
zengshang(4140,0)
end
),
RG.switch("穿云",
function() enqueueTask(function()
HK()
zengshang(3104010,1)
end) end,
function()
HK()
zengshang(3104010,0)
end
),
RG.switch("裂空",
function() enqueueTask(function()
HK()
zengshang(3704010,1)
end) end,
function()
HK()
zengshang(3704010,0)
end
),
RG.switch("球状闪电",
function() enqueueTask(function()
HK()
zengshang(3404010,1)
end) end,
function()
HK()
zengshang(3404010,0)
end
),
RG.switch("防空炮",
function() enqueueTask(function()
HK()
zengshang(3704020,1)
end) end,
function()
HK()
zengshang(3704020,0)
end
),
RG.switch("泡泡枪",
function() enqueueTask(function()
HK()
zengshang(3511010,1)
end) end,
function()
HK()
zengshang(3511010,0)
end
),
RG.switch("业火焚世",
function() enqueueTask(function()
HK()
zengshang(3304010,1)
end) end,
function()
HK()
zengshang(3304010,0)
end
),
RG.switch("自定义模块增伤",
function() enqueueTask(function()
HK()
local input = gg.prompt({'自定义模块增伤'}, {[1]='4020'})
if not input then return end
zidinyimokuaizenshang = tonumber(input[1])
if not zidinyimokuaizenshang then
zidinyimokuaizenshang = 4020
提示("输入无效，使用默认值4020")
end
zengshang(zidinyimokuaizenshang,1)
end) end,
function()
HK()
if zidinyimokuaizenshang then
zengshang(zidinyimokuaizenshang,0)
else
提示("请先使用自定义模块增伤功能")
end
end
),
RG.switch("自定义模块穿透",
function() enqueueTask(function()
HK()
local input = gg.prompt({'自定义模块穿透'}, {[1]='3304010'})
if not input then return end
zidinyimokuaicuantou = tonumber(input[1])
if not zidinyimokuaicuantou then
zidinyimokuaicuantou = 3304010
提示("输入无效，使用默认值3304010")
end
zengshang(zidinyimokuaicuantou,1)
end) end,
function()
HK()
if zidinyimokuaicuantou then
zengshang(zidinyimokuaicuantou,0)
else
提示("请先使用自定义模块穿透功能")
end
end
),
RG.button("查看模块ID",
function() runAsyncTask(function()
HK()
showAllKnownModules()
end) end),
}),
RG.line(),
RG.box1({"模块缴械",
RG.switch("腾跃缴械",
function() enqueueTask(function()
HK()
腾跃缴械开()
end) end,
function()
HK()
腾跃缴械关()
end
),
RG.switch("鹰驰缴械",
function() enqueueTask(function()
HK()
鹰驰缴械开()
end) end,
function()
HK()
鹰驰缴械关()
end
),
RG.switch("大力神缴械",
function() enqueueTask(function()
HK()
大力神缴械开()
end) end,
function()
HK()
大力神缴械关()
end
),
RG.switch("海王盾缴械",
function() enqueueTask(function()
HK()
海王盾缴械开()
end) end,
function()
HK()
海王盾缴械关()
end
),
RG.switch("重装魔方缴械",
function() enqueueTask(function()
HK()
重装魔方缴械开()
end) end,
function()
HK()
重装魔方缴械关()
end
),
RG.switch("天行者缴械",
function() enqueueTask(function()
HK()
天行者缴械开()
end) end,
function()
HK()
天行者缴械关()
end
),
RG.switch("午夜派对缴械",
function() enqueueTask(function()
HK()
午夜派对缴械开()
end) end,
function()
HK()
午夜派对缴械关()
end
),
RG.switch("穿云缴械",
function() enqueueTask(function()
HK()
穿云缴械开()
end) end,
function()
HK()
穿云缴械关()
end
),
RG.switch("穹弩缴械",
function() enqueueTask(function()
HK()
穹弩缴械开()
end) end,
function()
HK()
穹弩缴械关()
end
),
RG.switch("特斯拉的巨剑缴械",
function() enqueueTask(function()
HK()
特斯拉的巨剑缴械开()
end) end,
function()
HK()
特斯拉的巨剑缴械关()
end
),
RG.switch("小指头缴械",
function() enqueueTask(function()
HK()
小指头缴械开()
end) end,
function()
HK()
小指头缴械关()
end
),
RG.switch("业火焚世缴械",
function() enqueueTask(function()
HK()
业火焚世缴械开()
end) end,
function()
HK()
业火焚世缴械关()
end
),
RG.switch("寂静之声缴械",
function() enqueueTask(function()
HK()
寂静之声缴械开()
end) end,
function()
HK()
寂静之声缴械关()
end
),
RG.switch("苍穹守护缴械",
function() enqueueTask(function()
HK()
苍穹守护缴械开()
end) end,
function()
HK()
苍穹守护缴械关()
end
),
RG.switch("野蜂缴械",
function() enqueueTask(function()
HK()
野蜂缴械开()
end) end,
function()
HK()
野蜂缴械关()
end
)
}),
RG.line(),
RG.box1({"设置车体范围",
RG.switch("正常秒杀范围优化",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    正常秒杀范围优化()
else
    正常秒杀范围优化二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("正常秒杀范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    正常秒杀范围()
else
    正常秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("不挡秒杀范围(新)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    不挡秒杀范围新()
else
    不挡秒杀范围新二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("队友不挡高伤范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    队友不挡高伤范围()
else
    队友不挡高伤范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("执行迅速秒杀范围(新)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    执行迅速秒杀范围新()
else
    执行迅速秒杀范围新二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("频率优化秒杀范围(旧)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    频率优化秒杀范围旧()
else
    频率优化秒杀范围旧二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("频率优化秒杀范围(新)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    频率优化秒杀范围新()
else
    频率优化秒杀范围新二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("极小秒杀范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    极小秒杀范围()
else
    极小秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("迫击炮延迟发包(轰炸区)",
function() luajava.newThread(function()
HK()
paijipaofabao(true)
end):start() end,
function()
paijipaofabao(false)
end
),
RG.switch("子弹穿墙",
function() luajava.newThread(function()
HK()
提示('已开启')
子弹穿墙开()
end):start() end,
function()
HK()
提示('已关闭')
子弹穿墙关()
end
),
}),
RG.line(),
RG.box1({"设置车体旧范围",
RG.switch("不秒杀范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    不秒杀范围()
else
    不秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("自定义不秒杀范围",
function() luajava.newThread(function()
HK()
if msfwqh == false then
    自定义不秒杀范围()
else
    自定义不秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("子弹穿墙",
function() luajava.newThread(function()
HK()
提示('已开启')
子弹穿墙开()
end):start() end,
function()
HK()
提示('已关闭')
子弹穿墙关()
end
),
RG.check({"以下范围伤害可能容易闪退",}),
RG.switch("范围穿甲弹",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    范围穿甲弹()
else
    范围穿甲弹二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("自瞄炮范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
自瞄炮范围()
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("高伤",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    高伤()
else
    高伤二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
}),
}),
RG.line(),
RG.switch("不漂移加速",
function() enqueueTask(function()
HK()
不漂移加速()
提示("已开启") 
end) end,
function()
HK()
不漂移加速关闭()
提示("已关闭")
end
),
RG.switch("频率加速",
function() enqueueTask(function()
HK()
频率加速()
end) end,
function()
HK()
不漂移加速关闭()
提示("已关闭")
end
),
RG.switch("特殊加速",
function() enqueueTask(function()
HK()
特殊加速()
end) end,
function()
HK()
特殊加速关闭()
end
),
RG.switch("大力神加速",
function() enqueueTask(function()
HK()
大力神加速开()
end) end,
function()
HK()
大力神加速关()
end
),
RG.switch("灰屏共鸣",
function() enqueueTask(function()
HK()
灰屏共鸣()
end) end,
function()
HK()
灰屏共鸣关闭()
end
),
RG.switch("停止发包",
function() enqueueTask(function()
HK()
停止发包开()
end) end,
function()
HK()
停止发包关()
end
),
RG.switch("核心加速",
function() enqueueTask(function()
HK()
核心加速开()
xg1(999999999999999999999,16,140,false)
end) end,
function()
核心加速关()
end
),
RG.switch("核心加速自定义",
function() enqueueTask(function()
HK()
核心加速开()
xg3(999999999999999999999,16,140,false,true,"(自定义核心加速)")
end) end,
function()
核心加速关()
end
),
RG.switch("核心激活",
function() enqueueTask(function()
HK()
核心激活开()
end) end,
function()
HK()
核心激活关()
end
),
RG.switch("核心伪Y++",
function() enqueueTask(function()
HK()
核心伪Y加加开()
end) end,
function()
HK()
核心伪Y加加关()
end
),
RG.switch("萌新CD",
function() enqueueTask(function()
HK()
萌新CD开()
end) end,
function()
HK()
萌新CD关()
end
),
RG.switch("核心防水",
function() enqueueTask(function()
HK()
核心防水开()
end) end,
function()
HK()
核心防水关()
end
),
RG.switch("防闪耀星光",
function() enqueueTask(function()
HK()
防闪光弹开()
end) end,
function()
HK()
防闪光弹关()
end
),
RG.switch("海王盾绘制",
function() enqueueTask(function()
HK()
guanfangesp(1)
end) end,
function()
HK()
guanfangesp(0)
end
),
RG.switch("特殊视角",
function() enqueueTask(function()
HK()
特殊视角开()
end) end,
function()
HK()
特殊视角关()
end
),
RG.switch("相机坐标",
function() enqueueTask(function()
HK()
freezeCamera()
end) end,
function()
HK()
unfreezeCamera()
end
),
RG.switch("相机Y状态",
function() enqueueTask(function()
HK()
相机Y状态开()
end) end,
function()
HK()
相机Y状态关()
end
),
RG.switch("霜鸟锁定数量",
function() enqueueTask(function()
HK()
霜鸟锁定数量开()
end) end,
function()
HK()
霜鸟锁定数量关()
end
),
RG.line(),
RG.button("破隐",
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x459C50, 0x10, 0x18, 0x0}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 1145}})
end) end),
RG.button("破隐(自定义)",
function() enqueueTask(function()
HK()
local ttt = S_Pointer({"libclient.so:bss", "Cb"}, {0x459C50, 0x10, 0x18, 0x0}, true)
local cv = gg.getValues({{address = ttt, flags = lastOffsetValue}})[1].value
local displayOffset = rememberLastValue and lastOffsetValue or 16
local input = gg.prompt({
'输入值 [当前值:'..cv..']',
'偏移值 [当前值:'..displayOffset..']',
'记住上次输入值'
}, {
rememberLastValue and (lastModifiedValue or cv) or cv,
displayOffset,
rememberLastValue
}, {
'number', 'number', 'checkbox'
})
if input then
rememberLastValue = input[3]
local nv = tonumber(input[1]) or (rememberLastValue and lastModifiedValue) or cv
local offset = tonumber(input[2]) or (rememberLastValue and lastOffsetValue) or 16
if rememberLastValue then
lastModifiedValue = nv
lastOffsetValue = offset
end
gg.setValues({{address = ttt, flags = offset, value = nv}})
提示(("修改成功 → 值:%s 偏移:%d"..(rememberLastValue and " (已存)" or "")):format(nv, offset))
else
提示("已取消")
end
end) end),
RG.button("恢复破隐",
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x459C50, 0x10, 0x18, 0x0}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 2.0}})
end) end),
RG.line(), 
RG.box({"设置视角(硬核",---box示例 可以删掉
RG.button("极广角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(-10000, 16, 0, true)
end
end) end),
RG.button("超广角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(-6000.114514, 16, 0, true)
end
end) end),
RG.button("广角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(-4000, 16, 0, true)
end
end) end),
RG.button("微广角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(-400, 16, 0, true)
end
end) end),
RG.button("近角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(60, 16, 0, true)
end
end) end),
RG.button("超近角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(100, 16, 0, true)
end
end) end),
RG.button("核心视角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg1(80, 16, 0, true)
end
end) end),
RG.button("自定义视角", function() enqueueTask(function()
HK()
if SetSjWithOffset(-140) then
xg3(nil, 16, 0, true, "(自定义视角)")
end
end) end),
RG.button("自定义视角(广角)", function() enqueueTask(function()
HK()
if SetSjWithOffset(-92) then
xg3(nil, 16, 0, true, "(自定义视角[广角])")
end
end) end),
RG.button("自定义视角(旧)", function() enqueueTask(function()
HK()
if SetSjWithOffset(-40) then
xg3(nil, 16, 0, true, "(自定义视角(旧))")
end
end) end),
RG.button("恢复视角", function() enqueueTask(function()
HK()
local any = false
if SetSjWithOffset(-140) then
xg1(0, 16, 0, false)
any = true
end
if SetSjWithOffset(-92) then
xg1(1, 16, 0, false)
any = true
end
if SetSjWithOffset(-40) then
xg1(1, 16, 0, false)
any = true
end
if any then
_VisionBase = nil
_VisionOrig = {}
提示("视角已恢复，缓存已清除")
return
end
search("-1.2566370964050293", 16, neicun)
xg1(0, 16, -140, true)
xg1(1, 16, -92, true)
xg1(1, 16, -40, true)
gg.sleep(100)
xg1(0, 16, -140, false)
xg1(1, 16, -92, false)
xg1(1, 16, -40, false)
end) end),
}),
RG.line(),
RG.box({"设置光照",
RG.button("爆亮",
function() enqueueTask(function()
HK()
gz='999.96355'
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-1", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-1",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.editAll("999.96355", FLOAT)
提示("开启成功")
gg.clearResults()
end
end) end),
 RG.button("明亮",
function() enqueueTask(function()
HK()
gz='1899.96355'
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-1", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-1",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.editAll("1899.96355", FLOAT)
提示("开启成功")
gg.clearResults()
end
end) end), 
RG.button("阴暗",
function() enqueueTask(function()
HK()
gz='-1899.96355'
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-1", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-1",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100000)--设置修改前200个代码
gg.editAll("-1899.96355", FLOAT)
提示("开启成功")
gg.clearResults()
end
end) end),
RG.button("黑暗",
function() enqueueTask(function()
HK()
gz='-999.96355'
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-1", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-1",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100000)--设置修改前200个代码
gg.editAll("-999.96355", FLOAT)
提示("开启成功")
gg.clearResults()
end
end) end),
RG.button("恢复光照",
function() enqueueTask(function()
HK()
提示("正在恢复")
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber(gz,FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(12100)--修改前1200个代码
gg.editAll("-1", FLOAT)
提示("恢复完成")
end) end),
}),
RG.line(),
RG.box({"设置透视",
RG.button("地面透视",
function() enqueueTask(function()
HK()
toushi='31,165,001,600'
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('31,138,512,896',gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber('', gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,165,001,600',gg.TYPE_QWORD)
提示('开启成功')
end) end),
RG.button("地面透视 Pro",
function() enqueueTask(function()

HK()
 
toushi='31,215,001,600'
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('31,138,512,896',gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber('', gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,215,001,600',gg.TYPE_QWORD)
提示('开启成功')
 

--地面透视 Pro")
end) end),
RG.button("全透视",
function() enqueueTask(function()

HK()
 
toushi='31,215,001,900'
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('31,138,512,896',gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber('', gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,215,001,900',gg.TYPE_QWORD)
提示('开启成功')
end) end),
RG.button("透视+特效增大",
function() enqueueTask(function()

HK()
 
toushi='31,200,030,000'
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber('31,138,512,896',gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber('', gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,200,030,000',gg.TYPE_QWORD)
提示('开启成功')
end) end),
RG.button("恢复透视",
function() enqueueTask(function()

HK()

 提示("正在恢复") 
gg.clearResults()
gg.setRanges(neicun)
gg.searchNumber(toushi,gg.TYPE_QWORD,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll('31,138,512,896',gg.TYPE_QWORD)
提示("恢复完成")
 end) end), 
}), 
RG.line(),
RG.box({"天线功能",---box示例 可以删掉
RG.switch("添加模块天线",
function() runAsyncTask(function()

HK()

gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("-5", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("-5",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
提示("开启成功")
gg.editAll("114514", FLOAT)
gg.clearResults()
end
end) end,
function() runAsyncTask(function()

HK()

gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("114514", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("关闭失败")
else
gg.searchNumber("114514",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
提示("关闭成功")
gg.editAll("-5", FLOAT)
gg.clearResults()
end
end) end),
RG.button("添加特殊天线",
function() enqueueTask(function()

HK()

search(-943501312,4,neicun)
py1(2,4,-436)
py1(-257,4,-432)
py1(-943501312,4,-52)
py1(-943501312,4,-48)
py1(-943501312,4,-44)
py1(-943501312,4,-8)
py1(-943501312,4,-4)
py1(1203982336,4,4)
py1(1203982336,4,8)
py1(1203982336,4,12)
py1(112,4,556)
xg1(114514,16,-480,true)
 
 --添加特殊天线")
end) end),
RG.switch("添加萌新天线",
function() runAsyncTask(function()

HK()

gg.clearResults()
 gg.setRanges(neicun)
 gg.searchNumber("0.65025615692", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
 gg.getResults(100)
 gg.editAll("99.64384", gg.TYPE_FLOAT)
 提示("开启")
 gg.clearResults()
end) end,
function() runAsyncTask(function()

HK()

gg.clearResults()
 gg.setRanges(neicun)
 gg.searchNumber("99.64384", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
 gg.getResults(100)
 gg.editAll("0.65025615692", gg.TYPE_FLOAT)
 提示("关闭")
 gg.clearResults()
end) end),
}), 
RG.box({"设置速度显示数值",---box示例 可以删掉

RG.button("100000000",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(100000000,16,4,true)

 


end) end), 

RG.button("10",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(10,16,4,true)

 


end) end),

 RG.button("3",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(3,16,4,true)

 


end) end),


RG.button("-3",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(-3,16,4,true)

 


end) end),
RG.button("0",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(0,16,4,true)

 


end) end),

RG.button("恢复",
function() enqueueTask(function()

HK()

search(1889785610,4,neicun)
py1(1889785610,4,-24)
py1(1072693248,4,76)
xg1(0,16,4,true)

 


end) end),


}),
RG.line(),

},{
RG.check({" 32位功能",}),
RG.button("#一键变速升空范围#",
function() enqueueTask(function()

HK()
 
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(5059790,16,-8,true)
gg.sleep(700)
gg.setSpeed(3)
gg.sleep(4700)
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(5790,16,-8,false)
提示("请不要解体/修复")
gg.sleep(273)
fw1=true
while fw1==true do 
gg.sleep(1)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,56)
xg1(999,16,56,false)
xg1(999,16,52,false)
search(7.707281683632926E-41,16,neicun)
py1(7.1746481373430634E-43,16,-20)
py1(7.707281683632926E-41,16,-16)
py1(7.1746481373430634E-43,16,-4)
py1(7.707281683632926E-41,16,0)
py1(0.19999998807907104,16,40)
py1(2.7551769886168823E-40,16,144)
xg1(30.114514,16,56,false)--大小
xg1(0,16,60,false)
xg1(30.114514,16,52,false)--大小
end
end) end),
RG.button("灵体掉坑出不来 点这里",
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 16, value = 2099, freeze = true}})
gg.sleep(150)
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 16, value = 200, freeze = true}})
gg.sleep(150)
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 16, value = 2099}})
gg.sleep(150)
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 16, value = 200}})


end) end),
RG.button("∷恢复变速升空范围∷",
function() enqueueTask(function()

HK()
 

gg.sleep(2506)
gg.setSpeed(1)
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(4000,16,-8,false)

 end) end),
RG.button("全图毒人Promax(作者独用)",
function() enqueueTask(function()

HK()
 

X=[[
✨此脚本已开启如下功能✨
 Base64编码-[字符保护]————["✨Base64编码已开启✨"]
 Rc4源码加密-[对称保护]———["✨Rc4源码加密已开启✨"]
 Xor源码加密-[排列保护]———["✨Xor源码加密已开启✨"]
 验证拆卸工具-[防止拆卸]——["✨验证拆卸工具已开启✨"]
 表情混淆-[防止修复]——————["✨表情混淆已开启✨"]
 混淆转换-[混淆转换]——————["✨字符转换未开启✨"]
 源码汇编-[格式代码]——————["✨源码汇编已开启✨"]
 
 加密工具:吟霖加密
 加密强度综合评定: ★★★★☆
 加密时间:2024年06月22日13:54:48
--注: 加密强度判定条件为开启功能数量 仅供参考


 ꯭《꯭吟꯭霖꯭风꯭雪꯭》꯭ ꯭作꯭者꯭:꯭興꯭月꯭.꯭
 
 ꯭ ꯭ ꯭ ꯭ ꯭ ꯭-꯭-꯭ ꯭风꯭雪꯭压꯭我꯭两꯭三꯭年꯭꯭꯭꯭我꯭心꯭早꯭已꯭无꯭怨꯭言꯭.꯭/꯭
 ꯭ ꯭ ꯭ ꯭ ꯭ ꯭-꯭-꯭ ꯭三꯭言꯭两꯭语꯭并꯭我꯭心꯭ ꯭闭꯭口꯭不꯭提꯭是꯭曾꯭经꯭.꯭/꯭
 ꯭ ꯭ ꯭ ꯭ ꯭ ꯭-꯭-꯭ ꯭砥꯭砺꯭坚꯭韧꯭映꯭风꯭雪꯭꯭꯭悲꯭欢꯭离꯭合꯭皆꯭成꯭往꯭.꯭/꯭
 ꯭ ꯭ ꯭ ꯭ ꯭ ꯭-꯭- ꯭待꯭到꯭春꯭风꯭吹꯭又꯭暖꯭꯭꯭绽꯭放꯭笑꯭颜꯭迎꯭朝꯭阳꯭.꯭/꯭
 
 
喵~
ﾍ^ヽ､　 /⌒､　　_,_
　 |　　￣7　 (⌒r⌒7/
　 レ　　　＼_/￣＼_｣
＿/　　　　　　　 {
_ﾌ　●　　　　　　　ゝ
_人　　　ο　　●　 ナ
　 `ト､＿　　　　　メ
　　　 /　 ￣ ーィﾞ
　　 〈ﾟ･｡｡｡･ﾟ 　丶


꯭꯭꯭p꯭꯭꯭s꯭꯭꯭.꯭꯭꯭想꯭꯭꯭要꯭꯭꯭留꯭꯭꯭住꯭꯭꯭雪꯭꯭꯭花꯭꯭꯭꯭꯭꯭但꯭꯭꯭在꯭꯭꯭手꯭꯭꯭心꯭꯭꯭里꯭꯭꯭꯭꯭꯭她꯭꯭꯭只꯭꯭꯭会꯭꯭꯭融꯭꯭꯭化꯭꯭꯭的꯭꯭꯭更꯭꯭꯭快꯭꯭.꯭꯭꯭/꯭꯭꯭

 ꯭؁꯭F꯭i꯭n꯭a꯭l꯭ ꯭o꯭w꯭n꯭e꯭r꯭ ꯭o꯭f꯭ ꯭C꯭o꯭p꯭y꯭r꯭i꯭g꯭h꯭t꯭ ꯭©꯭ ꯭2꯭0꯭2꯭4꯭ ꯭b꯭y꯭.꯭興꯭꯭月꯭؁꯭
]]
loadYunLuaGroup("httpByQnqZUua3tXt02eF9j+eSfhM7u/rb2jvE7kKW2LUU9ri5bx2rZDPBr/lxdpdCKfc/yhKStX1Et/cpykabhu9CWSEtVsbKZrNtU/0lBpbEQ/hro3a2FQMPTE0lrrOkWMBaDzECAow6j/mqBdcUsEzh4Qn93mfyzvjC0NE9Du2lcF+i2ECVOSaZxvyH6wb8JmimHAsQr4CGUD6MDCe6afdVpXeyTbi08GJOnhZ61cPcxLMWsqq4io2Vy5mU6sITgKUBs36D1eY00+NpSbA2DP3eaXOphFwauc9P70dKsF4IY2Fzt3d/rvR/B8ESCH9VlGu5c2CsYirP2TH900umphMjGzsQG2OLVZQN51sGO6WnxwpyitwDRHUEGFo3QHnn3ZUzbEH1/aTTCYuzZzxiX9CYuPzClsi1MpcstwAFylenSHGRo3TRs/7SOXBV9obGzCsgAx1zDRgzGabpqakk3TkW1i49e6+cXNYVb4AGBb3biLktNgXFB3QMlUVWGgpHetsrB9NECKipwp6TfMip58ujhSdYbNiWrfQOJl02Ewqd42il2NJE+P+5ItNzQ+4JLs5HiXCn+yeUALqM+WhEezd9ZtwklvGfczGbEWDzAPks1cWnKvOHzWHixg5zZeiZxGGJiMXYkfOQcKsIBGbzs78o/D+vwcvYCyTy3zbsBCNanrmdF0rRZA3SBNBkcXjmXOmp9yNz6tpcT14WSJOPEgnYsszdlXgG+W4sYZcQdS2HDVZE303DBOO4NYfzU1UZvSMyo2vcOzvRwfHG2XRQJUI1Kup4uYMwQSh4PoXcDfZuc/3OLbz8oPnnF5ju8ZiHgCsa7YXAPew02QC4H2MDuDhJs5fmwKfyj2HHJzWSeq5sqWi9e/aviAIPhg75tzfbpNABakK2JkJjx9Ii/eLU8TvYDubCC2P91qyz+1vznwUzDqzfFdfA86hSO4M864CQeAaiPbpWquOrNL5CevNanKagX73mVGc0lSPHtAgvvmlyzu5yhZQu/JvoKYzC0ukycnV0wtOQzyVVWDKGAt0ZgIW/rpUBYnKgX6ZXxqn9lQ9KM8CyDtrTmo9tBPk3U44Pa1hoKGqhKHsDx5+4CxJ1PkGKO1UHBcYaC43HQzP8BewBH35hCaoNBgaXBWmcosfAdoNbiXYvfwXkppcV2yTDZnXe4dd9KIbdOCJs4AM1qRVxLeC94Or0amsDfUpLkjLg7n1oq6tFxNJP6al2Vdx2OYGDH78A8a8MV5PMx03kk1YMA4LcdMWikJ5JsqSk6sVzDdADCARR819Wixn1GzDzZzQPP8II/QosC0Br08TqsQXBzv0SrBd/Il/omYPHvebHq31Xm5qJ9pKkk1To9Yma2D/44sgsJEdIf0UCY93n0X+EJ/eMOJfDZwxAh1j3RE4W0tDf6pkSeqBI/mGTn6367p45pNE4rjbWr9nkC9oj3uyLvN2RYEVtnAkbWILT6D1jQcwG6rf6k0")
XYNB("🤗😇😡😌😳😋😅😤😀😒😉😕😚😠😡😃😜😨😏😋😉😲🤗😀😪😖😅😙😟😗😜🙄😐😥😄😉😣😭🤑😢😊🤯😉😳😣🤩😠😄🙄🙂😷😊😰😉😂😡😷😝😀😚😙😶😡😳😇😤🤗🤒😍😁😡🙁😞😩😫😳😶😱😟😳😅😛😶😂😱😲😋🤩😱😃😙😳😞🤩😙😋😏🙄😗😞😌😇🤓🤯😥😡🙄😓😘😭😰😆😌😟😣😉😖😂😗😀😤😔😫😭😀😕☺️😂🤔😣😰😪😎🤑😪😄😝🤨🤨☺️🙃🤨😨😡😪🤨😇😎🤑😠😪🙃😕😲😎😎😳😊😡😫😞😠🤗😙🙃😛😤🤩😋🤯😨😪😝😡😓😡😁😎🤣😉😆🤩😥🤒😘😘😝😜😳🤩😂😪😡😂😚🥵😶🙄😱🤐😜😓😏😆😡🙁😪😗😒🤩😒🤗😲😫🙂😄😲😄😄😄🤔🤐😘😤🤒🤑😱😀😎🤨🙂🤒😄😡😡🤑🥵🤯😒😉😇😄😝😀🤔😪😷😢😐🙄🤑😫😣🙂😏🤔😂☺️😊😫😩😉😊☺️🤨🙁😪😔😌😔😊☺️😚🤩😄😔😢😳😒☺️😜😒😁😩😁😍😏😜😝😙😒😱😜😕🤔🤐😥😱😂🙄😁😋🙃☺️😱😤😣😁🤨😨🤣😁😄🤐😒😥😍😍😱😅😫😟🥵😪😗🤗😤😣🤣😩🙂😢😣😗😢😴😖😨😥😏🤯😤🥵😃😏😴😓😔😝😛😷🤨🤓😥😄🤔🙃🤐😠😔😰😖😗😠🙁😎😭😇😫😖🥵😅😟😚😤😔😃😤😓🤐🤣😠😤🤔😙🤩😭🤑😣😁🥵🙄🤓😂🤨🤒😂😅😉🤣😪🙃😌😪😘🤓😠😁😌😐😠🤨😪🙂😂😓😓🤯😉😳😋😫😒😠😊😞😐😖🤔😩🤒😲🤔😡😪😅😁🙃😏😄😊😞😙😝😪☺️😷😴😚😂🤒😳😤😖🤔🙃😄😚🙁😱😨😫😪🙃😐😠😅🤑😏😭😪☺️😏😃🤓😨😆🙄🤗😆😄😲🤓😋😎😟😎🤐😩😋☺️😉😗🤩😜😐😀😂😢😋😐😉😂☺️😍😀😰🙁😷😜😳😕😗😗😉😃🙄😢😊😔😀😉😠😝😚😍😘🙂😚😉🤨🤒🥵☺️😇😷🤐😚😇😢😆😄😒🤗🤩😍😥😛😶😲😂😴😳😞😞😣😔😇🙃😟🤒😓😠😂🙁🤐🤗🤐😗😟😔😠😲😅🤓🤔😞🙁😁😜😎🤨😜😥😥🙁😩😗🤯😂🙂😣😖😫😚😠😙😨🤑🤒😶😄🤒😍🤩😳😰😂😜😗😕😂😗😜😒😚😝😀😄🙃🤯😂😕😜😂😡😪😨😀😝😅😩😴😖😶😶🤐😟😌🤗😗😏😭🤓😞🤔😳🤗🤐😰🤣🤔😝😣😄😇🤓🤣🤐😒😃🤒😟🙃😨😂😭😊😒😶😂😫😇😋😁😠😨🤔😢🤔😠😒😌🙄😞😐🥵😩😝🤯😨😞😄🤨😘😏😋😟🤯😁🤒😱😠😌😲😱🤯☺️🙄😏😀😔😣😳😁😁😅😭😪😩😟😁🥵😞🤔😠😨😤😇😏🤑🥵🤔🤩😚😖😫🥵😟😙😒😄🤩🤔😟😀😤😫😌😫😜😷😪😍😙🥵😏😳😒😒🤐😠😏😀😌🤯😓😘😃😷😕😷🤗😘😷😱😊🤩😀😍😍😠😐😒😠🙁😋😡😖😜😃🤣😨😟😜😌😗😢😐😜😖😤😆😠😙😚🤣😙😆😶🙄😳😟😶😝🤒😚😫😆🙄😂😓😂😅😚😭😲😁🤗😶😚😎😋😪🤣😋😓😍😥😆🤔😓😇😒☺️😃😨😴😶😥😨😣😒😀🤨😡😨😝😂😆🙁😘😪😡😩🤔😫😃😲🤑😱😶😙😳😅😂😭🙂😫😗😳😪😜🤯😷🤓🤑🤒😢🥵😫😙😶😌😚😭😶😝🤓😐😫🙁😅😌😝☺️😘😌😪😣😘🤨😴😥🤔🤑😥😒😃😙😗🤔😠😄😱😰😕😡😊😖😩😇🤗🤒😭😃🤐😎🤩🤓😎😇🤩🤣😂🤓🙃😗🤑😔😨🙁😎😥😷😆😩☺️🙃😠☺️🤩😪😉🙄😅😅😞😔😂🤨😆🤣😶😛😤😤😌🙁😎😍🤩🤑😂🤓😨😡🤗😏😌😖😜😶😎🤐😟😢🙂😘😅😚🤗😇😥😔😒😚😭😙😷🙁😡😎😃😷😌😘😕😗🤐😁😢😲🤓😱🤯🙂😐😢😎🙁🥵😀🤒🤒😐😟🤐😳😚😪🙄😎🤓😉😷😖😠😴🤑🤨😲😀😫😞😌😍😉😖😆😴🤣😚🙁😀😙😠😒😷😥🤯😋🤑😖😥😐😔😩😭😷🤨😟🤣🙄🙄🙁🙄😘😇😤😰😣😴😐😥😋😟😥😉😪😂😥🤨🤣😊😎😠😓😏😷😫😟😁😂😷😆😎😁😛😓😡😎😢😛🙂😟😨😪😴🙂😱🤔😆😊😰🤒😖😙🤣😀😆😉🤗😘😔😩😌😔😗😥😖😞😲😕😎😔🤑🤑😋😭🙁😔😘😘😚😋🤔😋🤣😉😱🙂🤒😎😐😫😓😗😒😥😰😄🤒😤🤒😎😙😚😨🤐🤐😞🥵😁😶😕😲🤩🤐😘😋😟☺️🤗😣😰😄😔🤔🤗😃😞😪😟😋😗😖😐😫🤨😤😚😰😃😌😃😂🤨😃🤣🙂😭😳🤐😓😆😛🤔😏😃😁🤐😱😝😰😛😫🤨😏😟😇😫😤😠🥵😄😃😞😲😐😶😐😭😩😆😲😭🙄🥵🙃😳😫😕😌😋😕🤑☺️🤒😅😤🙄😊😟🤨🙁😜🤐😄😫😫🤗😛😣🙂🤐😞😏🤓🤑😔😢🙁😰😔☺️🤣😣😱😗😳😛😙😃😳😥😩😪😷😘😎😟😍🤣🤩😖😎😕😋😚🤣😘🤩😣😲🤓😋🤣😉😩😗🙂😖🤐🤯☺️😝😆🤓😰🤩😨🤨😷😇😶😜😕😭🤒😏🤣🤩😎😜😕🙂🤩😟😎😋😗🤓🤩🤣😩😋😋😃😲🤗😙😠😅😱😩🤔😌😱😰🤗😐😤🤗🤣😲😘😐😕😣😪🤐😌😄😅😟😛😅🤯🙂😕☺️😎😲😷😊🤒😟😏😟😛😔🤗😊😪😣😢😱😱😗😏🙄😄😫😷🤐😶😋🤨😛😢🤑😃😴🙃😓🤣🙁😢😊😙😲😇😃🙂😢😃😗😭😗😣🤑😷😙😳😩😞😶😋😊😚😉😎😟😁😶😎😝😂😔😪😭😨😚😢😄😣😉🤣🤣😚😎😷☺️☺️😖😉😨😣😂🤔😪😂😂😊🙄😉😍😤😐😁😖😊😂😨😀😋😡😤😷😞🥵😢😇😲😁😓😞😟🤓😛😭😥😚😆🤐😥😐😨😥😥🤗😅😫😁😙🙁😡😱😌😱😡😳😭😖🙄😃🤓😴🥵🙃🤒😤😋😏😇🤨😃😚🤩😇😠😐😘🤒🤓😨😉😭😥😛😡😁😁😀😘🤩😇🤓😐😕😱😂😄😣😥🤗😄😆😅🙄😓😀😛😒😎😌😏😀😟🙁😥🤒😪🤑😄😎😙😨😫😙🤯😒😁☺️🤔☺️🤗😳😙🤒🙃😏😗🤒😂😱🙃😛🙄😖🤩😍🤯😁🤒😚☺️😨😍🤒🙁😄😔😇😡😁☺️😌🤓😳☺️😴😋🤩🤐😏😗😢😗😚😒😃😙😏🤨🤗😕😍😐😶😍😥😭🤒😭😎🙃😖😛😷😀😎🤯😜😕😊😚😐😷😟😭😀🙄😓😄😢😃🤩😝😪😃🤩😚🤩😲😊😶🤒😛🥵😲😗🤔😄😉😛😲😐😀🤨😩😂😍🤗😐😳🙁😉😗😚😗😕🤐😉🤒😫😱🙃😗😊😪😢😗☺️😕🤯🙂😅🤩🤔😎😠😰🤩😒🤓🤑😠😂🤑😩😌😣🥵🙃😘🤯☺️😉🤯😋😡😣🤔😃😩😉😩😍😥😓😤😐😀😞🤯🤨😟🙁🤯😊😠😏😪😠😄😭😕😪😝😴😉😢😚😝😗😨😙😶😨😴🙄😇😭😠😍😶😉🙃😴😨😜🙁😅🤒😃🙄🤣😂😍😕😥😒🤣😍🤐🙃😍😊😞😣😡😛😟😅😤😄😗🤓🙄😫😘😛🤩😢😝😠","b4843decea86933ed818f43ec2302fe6")
 end) end),
RG.button("拾取范围",
function() enqueueTask(function()

HK()
 

search(2.7551769886168823E-40,16,neicun)
py1(9.183409485952689E-41,16,48)
py1(9.183549615799121E-41,16,72)
py1(0.19999998807907104,16,104)
py1(3.7414668997472616E-43,16,108)
py1(4.203895392974451E-45,16,112)
py1(2.7551769886168823E-40,16,208)
xg1(9999999,16,120,false)
xg1(9999999,16,124,false)
xg1(9999999,16,116,false)

 end) end),
RG.line(),
RG.box({"风声加速(解体修复",
RG.radio({'加速',
{"开启加速",
function() enqueueTask(function()

HK()
py1(1.7999999523162842,16,-48)
py1(1.75,16,0)
xg1(9,64,-4,true)
end) end
},
}),
}),
RG.line(),
RG.box({"设置踏空",---box示例 可以删掉

RG.switch("车体踏空",
function() runAsyncTask(function()

HK()
 
search(1.9375,16,neicun)
py1(2.125,16,16)
xg1(3.75,16,304,true)
gg.sleep(500)
提示("请使用腾跃请解体修复")
editData(
{
{["memory"] = gg.REGION_C_ALLOC},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = 0,["offset"] =-0x1C, ["type"] = F,["freeze"] = true},
{["value"] = 0,["offset"] =-0x14, ["type"] = F,["freeze"] = true},
}
)
提示('开启成功')
end) end,
function() runAsyncTask(function()

HK()
 
search(1.9375,16,neicun)
py1(2.125,16,16)
xg1(1.9375,16,304,true)

 


end) end
),
}),
RG.line(),
RG.box({"全局变速",
RG.buts({
{"全局加速" ,
function() enqueueTask(function()

HK()
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("500", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("500",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("-99999999114514", FLOAT)
提示("开启成功")
gg.clearResults()
end
 


end) end
},
{"恢复全局" ,
function() enqueueTask(function()

HK()
 

gg.clearResults()
gg.searchNumber("-99999999114514",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("500", FLOAT)
提示("恢复")
gg.clearResults()

 


end) end
},
}),
}), 
RG.line(),
RG.box({"cd类(易闪退",---box示例 可以删掉
RG.button("萌新无CD",
function() enqueueTask(function()

HK()

search(1811205465,4,neicun)
py1(2047957257,4,36)
py1(1342253149,4,48)
xg1(0,16,8,true)


end) end),
 }),
RG.line(),
RG.box({"后坐类",---box示例 可以删掉
RG.button("高后坐",
function() enqueueTask(function()

HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(3,16,96,true)

 


end) end),
RG.button("反后坐",
function() enqueueTask(function()

HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(5000,16,-8,false)
xg1(-3,16,96,true)



end) end),
RG.button("自定义后坐",
function() enqueueTask(function()

HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg3(nil,16,96,true,"(自定义后坐力)")

 


end) end),
RG.button("恢复后坐",
function() enqueueTask(function()

HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(1,16,96,false)
end) end),
}),
RG.line(),
RG.box({"飞天类",---box示例 可以删掉
RG.button("极高空",
function() enqueueTask(function()

HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(5059790,16,-8,true)
end) end),
RG.button("高空",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(5250,16,-8,true)
end) end),
RG.button("低空",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(3000,16,-8,true)
end) end),
RG.button("地下",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(-1300,16,-8,true)
end) end),
RG.button("返回地面",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(3000,16,-8,false)
end) end),
}),
RG.line(),
RG.box({"范围类",---box示例 可
RG.radio({'范围',
{"核心范围" ,
function() luajava.newThread(function()
HK()
提示('范围已开启')
fw1=true
while fw1==true do 
gg.sleep(1)
search(3.605950117111206,16,neicun)
py1(4.161499977111816,16,4)------凯鼠
xg1(1000,16,0,false)
xg1(1000,16,4,false)
xg1(1000,16,-4,false)
search(4.73360013961792,16,neicun)
py1(4.791800022125244,16,4)------萌新
xg1(1000,16,0,false)
xg1(1000,16,-4,false)
search(9.900099754333496,16,neicun)
py1(4.437600135803223,16,-4)----网虫
xg1(999999,16,-4,false)
xg1(5,16,0,false)
xg1(999996,16,-8,false)
local qmnb = {
{["memory"] = neicun},
{["name"] = "夜莺"},
{["value"] = 1084453028, ["type"] = 4},
{["lv"] = 1084043454, ["offset"] = 4, ["type"] = 4},
{["lv"] = 1088645444, ["offset"] = 8, ["type"] = 4},
}
local qmxg = {
{["value"] = 1203982208, ["offset"] = 0, ["type"] = 4},
{["value"] = 1203982208, ["offset"] = 4, ["type"] = 4},
}
xqmnb(qmnb)
local qmnb = {
{["memory"] = neicun},
{["name"] = "大家伙"},
{["value"] = 6.202899932861328, ["type"] = 16},
{["lv"] = 7.257599830627441, ["offset"] = 4, ["type"] = 16},
{["lv"] = 11.9798002243042, ["offset"] = 8, ["type"] = 16},
}
local qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 99999, ["offset"] = 4, ["type"] = 16},
}
xqmnb(qmnb)
local qmnb = {
{["memory"] = neicun},
{["name"] = "火萤"},
{["value"] = 1086003452, ["type"] = 4},
{["lv"] = 1079392810, ["offset"] = 4, ["type"] = 4},
{["lv"] = 1087383378, ["offset"] = 8, ["type"] = 4},
}
local qmxg = {
{["value"] = 999999, ["offset"] = 0, ["type"] = 16},
{["value"] = 999999, ["offset"] = 4, ["type"] = 16},
}
xqmnb(qmnb)
local qmnb=
{
{['memory']=neicun},
{['name']='铁驭范围1'},
{['value']=5.85529994965, ['type']=16},
--{['lv']=5.85529994965,['offset']=0, ['type']=16},
{['lv']=5.16239976883,['offset']=4, ['type']=16},
{['lv']=5.23250007629,['offset']=8, ['type']=16},
}
local qmxg=
{
{['value']=255.85529994965,['offset']=0,['type']=16},
{['value']=255.16239976883,['offset']=4,['type']=16},
{['value']=255.23250007629,['offset']=8,['type']=16},
}
xqmnb(qmnb,qmxg)
local qmnb = 
{
{['memory'] = neicun},
{['name'] = '铁驭范围2'},
{['value'] = 5.85529994965, ['type'] = 16},
{['lv'] = 5.16239976883, ['offset'] = 4, ['type'] = 16},
{['lv'] = 5.23250007629, ['offset'] = 8, ['type'] = 16},
}
local qmxg = 
{
{['value'] = 255.85529994965, ['offset'] = 0, ['type'] = 16},
{['value'] = 255.16239976883, ['offset'] = 4, ['type'] = 16},
{['value'] = 255.23250007629, ['offset'] = 8, ['type'] = 16},
}
xqmnb(qmnb, qmxg)
local qmnb = {
{["memory"] = neicun},
{["name"] = "风声"},
{["value"] = 4.8165998458862305, ["type"] = 16},
{["lv"] = 2.997499942779541, ["offset"] = 4, ["type"] = 16},
{["lv"] = 5.773600101470947, ["offset"] = 8, ["type"] = 16},
}
local qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 99999, ["offset"] = 4, ["type"] = 16},
}
xqmnb(qmnb)
local qmnb = {
{["memory"] = neicun},
{["name"] = "幻灵"},
{["value"] = 5.154799938201904, ["type"] = 16},
{["lv"] = 4.906000137329102, ["offset"] = 4, ["type"] = 16},
{["lv"] = 4.9253997802734375, ["offset"] = 8, ["type"] = 16},
}
local qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 99999, ["offset"] = 8, ["type"] = 16},
}
xqmnb(qmnb)
end
end):start() end
}, 
{"队友不挡高伤范围" ,
function() luajava.newThread(function()
HK()
提示('范围已开启')
fw1=true
while fw1==true do 
gg.sleep(1)
search(7.707281683632926E-41,16,neicun)
py1(7.1746481373430634E-43,16,4)
py1(7.1746481373430634E-43,16,20)
py1(0.0,16,36)
py1(1.0,16,40)
py1(4.5,16,76)
xg1(9999,16,72,false)
xg1(0,16,76,false)
xg1(9999,16,68,false)
gg.sleep(500)
search(7.1746481373430634E-43,16,neicun)
py1(7.1746481373430634E-43,16,20)
py1(0.0,16,36)
py1(1.0,16,40)
py1(4.5,16,76)
xg1(9999,16,72,false)
xg1(0,16,76,false)
xg1(9999,16,68,false)
gg.sleep(500)
end
end):start() end
}, 
{"铁驭/赋能/序列范围(优化版)" ,
function() luajava.newThread(function()
HK()
提示('范围已开启')
local qmnb=
{
{['memory']=neicun},
{['name']='铁驭/赋能/序列范围'},
{['value']=5.855299949645996, ['type']=16},
{['lv']=5.162399768829346,['offset']=4, ['type']=16},
{['lv']=5.232500076293945,['offset']=8, ['type']=16},
}
local qmxg=
{
{['value']=255.855299949645996,['offset']=0,['type']=16},
{['value']=255.162399768829346,['offset']=4,['type']=16},
{['value']=255.232500076293945,['offset']=8,['type']=16},
}
xqmnb(qmnb,qmxg)
local qmnb = 
{
{['memory'] = neicun},
{['name'] = '铁驭范围'},
{['value'] = 5.85529994965, ['type'] = 16},
{['lv'] = 5.16239976883, ['offset'] = 4, ['type'] = 16},
{['lv'] = 5.23250007629, ['offset'] = 8, ['type'] = 16},
}
local qmxg = 
{
{['value'] = 255.85529994965, ['offset'] = 0, ['type'] = 16},
{['value'] = 255.16239976883, ['offset'] = 4, ['type'] = 16},
{['value'] = 255.23250007629, ['offset'] = 8, ['type'] = 16},
}
xqmnb(qmnb, qmxg)
end):start() end
}, 
{"普通秒杀范围" ,
function() luajava.newThread(function()
HK()
提示('范围已开启')
fw1=true
while fw1==true do 
gg.sleep(1)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,56)
xg1(9999,16,56,false)
xg1(9999,16,52,false)
gg.sleep(500)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,56)
xg1(9999,16,56,false)
xg1(9999,16,52,false)
gg.sleep(500)
end
end):start() end
}, 
{"秒杀+核心" ,
function() luajava.newThread(function()
HK()
提示('范围已开启')
fw1=true
while fw1==true do 
gg.sleep(1)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,56)
xg1(99999,16,56,false)
xg1(99999,16,52,false)
search(3.605950117111206,16,neicun)
py1(4.161499977111816,16,4)------凯鼠
xg1(1000,16,0,false)
xg1(1000,16,4,false)
xg1(1000,16,-4,false)
search(4.73360013961792,16,neicun)
py1(4.791800022125244,16,4)------萌新
xg1(1000,16,0,false)
xg1(1000,16,-4,false)
search(9.900099754333496,16,neicun)
py1(4.437600135803223,16,-4)----网虫
xg1(999999,16,-4,false)
xg1(5,16,0,false)
xg1(999996,16,-8,false)
local qmnb = {
{["memory"] = neicun},
{["name"] = "夜莺"},
{["value"] = 1084453028, ["type"] = 4},
{["lv"] = 1084043454, ["offset"] = 4, ["type"] = 4},
{["lv"] = 1088645444, ["offset"] = 8, ["type"] = 4},
}
local qmxg = {
{["value"] = 1203982208, ["offset"] = 0, ["type"] = 4},
{["value"] = 1203982208, ["offset"] = 4, ["type"] = 4},
}
xqmnb(qmnb)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,56)
xg1(99999,16,56,false)
xg1(99999,16,52,false) 
local qmnb = {
{["memory"] = neicun},
{["name"] = "大家伙"},
{["value"] = 6.202899932861328, ["type"] = 16},
{["lv"] = 7.257599830627441, ["offset"] = 4, ["type"] = 16},
{["lv"] = 11.9798002243042, ["offset"] = 8, ["type"] = 16},
}
local qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 99999, ["offset"] = 4, ["type"] = 16},
}
xqmnb(qmnb)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,56)
xg1(99999,16,56,false)
xg1(99999,16,52,false) 
local qmnb = {
{["memory"] = neicun},
{["name"] = "火萤"},
{["value"] = 1086003452, ["type"] = 4},
{["lv"] = 1079392810, ["offset"] = 4, ["type"] = 4},
{["lv"] = 1087383378, ["offset"] = 8, ["type"] = 4},
}
local qmxg = {
{["value"] = 999999, ["offset"] = 0, ["type"] = 16},
{["value"] = 999999, ["offset"] = 4, ["type"] = 16},
}
xqmnb(qmnb)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,56)
xg1(99999,16,56,false)
xg1(99999,16,52,false) 
local qmnb=
{
{['memory']=neicun},
{['name']='铁驭范围1'},
{['value']=5.85529994965, ['type']=16},
--{['lv']=5.85529994965,['offset']=0, ['type']=16},
{['lv']=5.16239976883,['offset']=4, ['type']=16},
{['lv']=5.23250007629,['offset']=8, ['type']=16},
}
local qmxg=
{
{['value']=255.85529994965,['offset']=0,['type']=16},
{['value']=255.16239976883,['offset']=4,['type']=16},
{['value']=255.23250007629,['offset']=8,['type']=16},
}
xqmnb(qmnb,qmxg)
local qmnb = 
{
{['memory'] = neicun},
{['name'] = '铁驭范围2'},
{['value'] = 5.85529994965, ['type'] = 16},
{['lv'] = 5.16239976883, ['offset'] = 4, ['type'] = 16},
{['lv'] = 5.23250007629, ['offset'] = 8, ['type'] = 16},
}
local qmxg = 
{
{['value'] = 255.85529994965, ['offset'] = 0, ['type'] = 16},
{['value'] = 255.16239976883, ['offset'] = 4, ['type'] = 16},
{['value'] = 255.23250007629, ['offset'] = 8, ['type'] = 16},
}
xqmnb(qmnb, qmxg)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,56)
xg1(99999,16,56,false)
xg1(99999,16,52,false)
local qmnb = {
{["memory"] = neicun},
{["name"] = "风声"},
{["value"] = 4.8165998458862305, ["type"] = 16},
{["lv"] = 2.997499942779541, ["offset"] = 4, ["type"] = 16},
{["lv"] = 5.773600101470947, ["offset"] = 8, ["type"] = 16},
}
local qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 99999, ["offset"] = 4, ["type"] = 16},
}
xqmnb(qmnb)
search(7.707281683632926E-41,16,neicun)
py1(0.0,16,12)
py1(0.0,16,16)
py1(0.0,16,20)
py1(1.0,16,24)
py1(0.0,16,28)
py1(0.0,16,32)
py1(0.0,16,36)
py1(4.5,16,56)
xg1(99999,16,56,false)
xg1(99999,16,52,false)
local qmnb = {
{["memory"] = neicun},
{["name"] = "幻灵"},
{["value"] = 5.154799938201904, ["type"] = 16},
{["lv"] = 4.906000137329102, ["offset"] = 4, ["type"] = 16},
{["lv"] = 4.9253997802734375, ["offset"] = 8, ["type"] = 16},
}
local qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 99999, ["offset"] = 8, ["type"] = 16},
}
xqmnb(qmnb)
end
end):start() end
}, 
}),
RG.button("停止循环" ,
function() luajava.newThread(function()
fw1=false
提示('停止')
end):start() end),
}),
RG.line(),
RG.box({"设置全局加速",
RG.buts({
{"全局加速" ,
function() enqueueTask(function()
HK()
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("500", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("500",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("-99999999114514", FLOAT)
提示("开启成功")
gg.clearResults()
end
end) end
},
{"恢复全局" ,
function() enqueueTask(function()
HK()
gg.clearResults()
gg.searchNumber("-99999999114514",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(200)--设置修改前200个代码
gg.editAll("500", FLOAT)
提示("恢复")
gg.clearResults()
end) end
}, 
}),
}),
RG.line(),
RG.box({"设置函数变速",
RG.text("root/虚拟机+部分渠道重装能用"),
RG.buts({
{"1倍" ,
function() enqueueTask(function()
HK()
提示('开启成功')
gg.setSpeed(1)
end) end
}, 
{"3倍" ,
function() enqueueTask(function()
HK()
提示('开启成功')
gg.setSpeed(3)
end) end
}, 
{"5倍",
function() enqueueTask(function()
HK()
提示('开启成功')
gg.setSpeed(5)
end) end},
}),
}),
RG.line(),
RG.box({"透视类",---box示例 可以删掉
RG.buts({
{"地面透视" ,
function() enqueueTask(function()
HK()
search(-2.3880816325146387E-38,16,neicun)
py1(-2.3880816325146387E-38,16,0)
py1(4.096384754264585E-34,16,4)
py1(5.739718509874451E-42,16,8)
xg1(1145,16,-48,false)
end) end
}, 
{"恢复透视" ,
function() enqueueTask(function()
HK()
search(-2.3880816325146387E-38,16,neicun)
py1(-2.3880816325146387E-38,16,0)
py1(4.096384754264585E-34,16,4)
py1(5.739718509874451E-42,16,8)
xg1(2,16,-48,false)
end) end
},
}),
}),
RG.box({"美化功能",
RG.switch("白茫茫",
function() runAsyncTask(function()
HK()
search(1.376037413354514E-13,16,16384)
py1(7.363217267682128E-33,16,-8)
py1(3.1831572511175476E-23,16,-4)
py1(1.376037413354514E-13,16,0)
py1(6.207762156805484E-33,16,4)
xg1(1.399997,64,392,false)
end)
end,
function() runAsyncTask(function()
HK()
search(3.1831572511175476E-23,16,16384)
py1(7.363217267682128E-33,16,-4)
py1(3.1831572511175476E-23,16,0)
py1(1.376037413354514E-13,16,4)
xg1(99999999,64,396,false)
end)
end
),
RG.switch("黑灯瞎火",
function() runAsyncTask(function()
HK()
search(3.1831572511175476E-23,16,16384)
py1(7.363217267682128E-33,16,-4)
py1(3.1831572511175476E-23,16,0)
py1(1.376037413354514E-13,16,4)
xg1(0,64,396,false)
end)
end,
function() runAsyncTask(function()
HK()
search(3.1831572511175476E-23,16,16384)
py1(7.363217267682128E-33,16,-4)
py1(3.1831572511175476E-23,16,0)
py1(1.376037413354514E-13,16,4)
xg1(99999999,64,396,false)
end)
end
),
RG.switch("绿色世界",
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("2",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(1200)--设置修改前200个代码
gg.editAll("3.468814637", FLOAT)
提示("开启成功")
gg.clearResults()
end)
end,
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("3.468814637",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(1200)--设置修改前200个代码
gg.editAll("2", FLOAT)
提示("恢复成功")
gg.clearResults()
end)
end
),
}),
RG.box({"坐标操纵台",
RG.button("x轴++" ,
function() enqueueTask(function()

HK()

提示("正在加载")
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 1500, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
end) end
),
RG.button("x轴--" ,
function() enqueueTask(function()

HK()

提示("正在加载")
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = -1500, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
end) end
),
RG.button("y轴++" ,
function() enqueueTask(function()

HK()

提示("正在加载")
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 1500, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
end) end
),
RG.button("y轴--" ,
function() enqueueTask(function()

HK()

提示("正在加载")
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = -1500, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
end) end
),
RG.button("z轴++" ,
function() enqueueTask(function()

HK()

提示("正在加载")
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 1500, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
end) end
),
RG.button("z轴--" ,
function() enqueueTask(function()

HK()

提示("正在加载")
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = -1500, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
end) end
),
RG.button("*恢复*" ,
function() enqueueTask(function()

HK()

提示("正在恢复")
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0, freeze = true}})
gg.sleep(50)
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x90}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x94}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x98}
local ttt = S_Pointer(t, tt)
gg.addListItems({{address = ttt, flags = 16, value = 0}})
end) end
),

}),
newcheck({nil,
{"不倒翁",
function() enqueueTask(function()

HK()
 
editData(
{
{["memory"] = gg.REGION_C_ALLOC},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = 0,["offset"] =-0x1C, ["type"] = F,["freeze"] = true},
{["value"] = 0,["offset"] =-0x14, ["type"] = F,["freeze"] = true},
}
)
end) end,
 },
 {"反向不倒翁",

function() enqueueTask(function()

HK()
 
editData(
{
{["memory"] = gg.REGION_C_ALLOC},
{["name"] = ""},
{["value"] = 17039364, ["type"] = D},
{["lv"] = 1111752704,["offset"] =0x44, ["type"] = D},
},
{
{["value"] = -1,["offset"] =-0x1C, ["type"] = F,["freeze"] = true},
{["value"] = -1,["offset"] =-0x14, ["type"] = F,["freeze"] = true},
}
)
 end) end,
 },
}),
newradio({nil,
{"开启穿墙",

function() enqueueTask(function()

HK()
 
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x284, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x284, 0x1008, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x194, 0x1F4, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x388, 0x0, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})
end) end,
 },
 {"恢复穿墙",

function() enqueueTask(function()

HK()
 
local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x284, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x284, 0x1008, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x194, 0x1F4, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x724, 0x8, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})

local t = {"libclient.so:bss", "Cb"}
local tt = {0xD81098, 0x388, 0x0, 0x6C}
local ttt = S_Pointer(t, tt)
gg.setValues({{address = ttt, flags = 4, value = 0}})
end) end,
 },
}),

RG.box({"锁核心",
RG.button("初始化锁核",
function() enqueueTask(function()
HK()
cleanHS3()
gg.sleep(300)
HS3()
end) end),
RG.box1({"选择玩家",---box示例 可以删掉/
RG.button("玩家1",
function() enqueueTask(function()
HK()
wj1tp()
end) end),
RG.button("玩家2",
function() enqueueTask(function()
HK()
wj2tp()
end) end),
RG.button("玩家3",
function() enqueueTask(function()
HK()
wj3tp()
end) end),
RG.button("玩家4",
function() enqueueTask(function()
HK()
wj4tp()
end) end),
RG.button("玩家5",
function() enqueueTask(function()
HK()
wj5tp()
end) end),
}),
RG.button("查看实体坐标数据储存",
function() enqueueTask(function()
manageEntities()
end) end),
RG.button("清理锁核储存数据",
function() enqueueTask(function()
HK()
cleanHS3()
end) end),
}),
RG.check({"其它功能",
}),
RG.box({"娱乐功能",
RG.button("打不到人",
function() enqueueTask(function()
HK()
search(17039361,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039361,4,0)
xg1(500,16,168,true)
xg1(500,16,172,true)
xg1(500,16,164,true)
end) end),
RG.button("转圈",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(257,4,-36)
py1(17039364,4,0)
xg1(9999,16,56,true)
end) end),
RG.button("一键自杀",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-360)
py1(257,4,-356)
py1(16777215,4,-40)
py1(257,4,-36)
xg1(-114514,16,-8,true)
gg.sleep(1000)
xg1(3000,16,-8,false)

end) end),
RG.switch("音量爆炸",
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("32767",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("32767",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
gg.getResults(999999)
gg.editAll("99999999",gg.TYPE_FLOAT)
提示("开启成功")
gg.clearResults()
end
end)
end,
function()runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("99999999",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
if gg.getResultCount() == 0 then
提示("关闭失败")
else
gg.searchNumber("99999999",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
gg.getResults(999999)
gg.editAll("32767",gg.TYPE_FLOAT)
提示("关闭成功")
gg.clearResults()
end
end)
end
),
RG.switch("视角锁定",
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("0.03",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("0.03",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
gg.getResults(999999)
gg.editAll("114514",gg.TYPE_FLOAT)
提示("开启成功")
gg.clearResults()
end
end)
end,
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("关闭失败")
else
gg.searchNumber("114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(999999)
gg.editAll("0.03", gg.TYPE_FLOAT)
提示("关闭成功")
gg.clearResults()
end
end)
end
),
RG.switch("UI隐藏",
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("0.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("0.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("114515", gg.TYPE_FLOAT)
提示("开启成功")
gg.clearResults()
end
end)
end,
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("114515", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("关闭失败")
else
gg.searchNumber("114515", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0.1", gg.TYPE_FLOAT)
提示("关闭成功")
gg.clearResults()
end
end)
end
),
RG.switch("左右横跳",
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("0.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("0.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("-1", gg.TYPE_FLOAT)
提示("开启成功")
gg.clearResults()
end
end)
end,
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("55", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("关闭失败")
else
gg.searchNumber("55", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100)
gg.editAll("0.1", gg.TYPE_FLOAT)
提示("关闭成功")
gg.clearResults()
end
end)
end
),
RG.switch("虚幻世界(闪退)",
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("开启失败")
else
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(10000)
gg.editAll("2", gg.TYPE_FLOAT)
提示("开启成功")
gg.clearResults()
end
end)
end,
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("关闭失败")
else
gg.searchNumber("2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(10000)
gg.editAll("1", gg.TYPE_FLOAT)
提示("关闭成功")
gg.clearResults()
end
end)
end
),
RG.switch("特效加速",
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("1", gg.TYPE_FLOAT)
gg.clearResults()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("特效加速失败")
else
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(85)
gg.editAll("250.114514", gg.TYPE_FLOAT)
提示("特效加速成功")
gg.clearResults()
end
end)
end,
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("250.114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("恢复失败，实在不行换画质")
else
gg.searchNumber("250.114514", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("1", gg.TYPE_FLOAT)
提示("恢复成功")
gg.clearResults()
end
end)
end
),
RG.switch("特效减速",
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("1", gg.TYPE_FLOAT)
gg.clearResults()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("特效减速失败")
else
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(85)
gg.editAll("0.0031", gg.TYPE_FLOAT)
提示("特效减速成功")
gg.clearResults()
end 
end)
end,
function() runAsyncTask(function()
HK()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("0.0031", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("恢复失败，实在不行换画质")
else
gg.searchNumber("0.0031", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(99999)
gg.editAll("1", gg.TYPE_FLOAT)
提示("恢复成功")
gg.clearResults()
end
end)
end
),
}),
RG.check({"以下为传送功能",
}),
RG.box({"超级风暴",
RG.buts({
{"大业殿",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(730,16,-8,true)--y
xg1(500,16,-4,true)
xg1(-3517,16,-12,true)
gg.sleep(500)
xg1(730,16,-8,false)--y
xg1(500,16,-4,false)
xg1(-3517,16,-12,false)
end) end,
},
{"可汗石头",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(0,16,-8,true)
xg1(-14571,16,-4,true)
xg1(-4057,16,-12,true)
gg.sleep(500)
xg1(0,16,-8,false)
xg1(-14571,16,-4,false)
xg1(-4057,16,-12,false)
end) end,
},
{"玉皇宫",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(17720,16,-8,true)
xg1(1700,16,-4,true)
xg1(9320,16,-12,true)
gg.sleep(500)
xg1(1380,16,-8,false)--y
xg1(-11745,16,-4,false)
xg1(9276,16,-12,false)
end) end,
},
}),
RG.buts({
{"菩提枫",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(-200,16,-8,true)
xg1(-2028,16,-4,true)
xg1(9627,16,-12,true)
gg.sleep(500)
xg1(-200,16,-8,false)
xg1(-2028,16,-4,false)
xg1(9627,16,-12,false)
end) end,
},
{"北岸高架",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1600,16,-8,true)--y
xg1(9825,16,-4,true)
xg1(11275,16,-12,true)
gg.sleep(500)
xg1(1600,16,-8,false)--y
xg1(9825,16,-4,false)
xg1(11275,16,-12,false)
end) end,
},
{"长滩房子",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)  
xg1(-429,16,-8,true)
xg1(-11405.460,16,-4,true)
xg1(-1871.13,16,-12,true)
gg.sleep(500)
xg1(-429,16,-8,false)
xg1(-11405.460,16,-4,false)
xg1(-1871.13,16,-12,false)
end) end,
},
}),
RG.buts({
{"太平门房子",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(410,16,-8,true)--y
xg1(-5424,16,-4,true)
xg1(-13166,16,-12,true)
gg.sleep(500)
xg1(410,16,-8,false)--y
xg1(-5424,16,-4,false)
xg1(-13166,16,-12,false)
end) end,
},
{"大草原",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(3600,16,-8,true)--y
xg1(7046.460,16,-4,true)
xg1(-10906,16,-12,true)
gg.sleep(500)
xg1(3600,16,-8,false)--y
xg1(7046.460,16,-4,false)
xg1(-10906,16,-12,false)
end) end,
},
{"荷塘房子",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(500,16,-8,true)--y
xg1(-25.4606,16,-4,true)
xg1(-11460,16,-12,true)
gg.sleep(500)
xg1(500,16,-8,false)--y
xg1(-25.4606,16,-4,false)
xg1(-11460,16,-12,false)
end) end,
},
}),
RG.buts({
{"菩提枫房子",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(-420,16,-8,true)--y
xg1(806.46063,16,-4,true)
xg1(10701,16,-12,true)
gg.sleep(500)
xg1(-420,16,-8,false)--y
xg1(806.46063,16,-4,false)
xg1(10701,16,-12,false)
end) end,
},
{"美食街车",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(-500,16,-8,true)
xg1(-9261.46063232531875,16,-4,true)
xg1(5181.13671875,16,-12,true)
gg.sleep(500)
xg1(-500,16,-8,false)
xg1(-9261.46063232531875,16,-4,false)
xg1(5181.13671875,16,-12,false)
end) end,
},
{"北岸木头",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(-228,16,-8,true)--y
xg1(11391.460,16,-4,true)
xg1(9863,16,-12,true)
gg.sleep(500)
xg1(-228,16,-8,false)--y
xg1(11391.460,16,-4,false)
xg1(9863,16,-12,false)
end) end,
},
}),
RG.buts({
{"天鹤山房子",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1400,16,-8,true)--y
xg1(5651.46,16,-4,true)
xg1(204,16,-12,true)
gg.sleep(500)
xg1(1400,16,-8,false)--y
xg1(5651.46,16,-4,false)
xg1(204,16,-12,false)
end) end,
}, 
{"可汗中心",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(455,16,-8,true)--y
xg1(-11707.46,16,-4,true)
xg1(-10474,16,-12,true)
gg.sleep(500)
xg1(455,16,-8,false)--y
xg1(-11707.46,16,-4,false)
xg1(-10474,16,-12,false)
end) end,
},
{"地龟山石头",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(516.3,16,-8,true)--y
xg1(-4983.4606,16,-4,true)
xg1(-6715,16,-12,true)
gg.sleep(500)
xg1(516.3,16,-8,false)--y
xg1(-4983.4606,16,-4,false)
xg1(-6715,16,-12,false)
end) end,
}, 
}),
}), 
RG.box({"单人风暴",
RG.buts({
{"中心枢纽",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(3031,16,-8,true)
xg1(791,16,-4,true)
xg1(-297,16,-12,true)
gg.sleep(500)
py1(16777215,4,-36)
py1(257,4,-32)
py1(17039364,4,0)
xg1(3031,16,-8,false)
xg1(791,16,-4,false)
xg1(-297,16,-12,false)
end) end,
},
{"灰色工厂",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(999,16,-8,true)
xg1(-5324,16,-4,true)
xg1(-1950,16,-12,true)
gg.sleep(500)
xg1(999,16,-8,false)
xg1(-5324,16,-4,false)
xg1(-1950,16,-12,false)
end) end,
},
{"守望台",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1594,16,-8,true)
xg1(-5739,16,-4,true)
xg1(2004,16,-12,true)
gg.sleep(500)
xg1(1594,16,-8,false)
xg1(-5739,16,-4,false)
xg1(2004,16,-12,false)
end) end,
},
}),
RG.buts({
{"零号仓库",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(50,16,-8,true)
xg1(6712,16,-4,true)
xg1(-5863,16,-12,true)
gg.sleep(500)
py1(16777215,4,-36)
py1(257,4,-32)
py1(17039364,4,0)
xg1(50,16,-8,false)
xg1(6712,16,-4,false)
xg1(-5863,16,-12,false)
end) end,
},
{"小试验场",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(575,16,-8,true)--y
xg1(-4525.46063,16,-4,true)
xg1(-2259,16,-12,true)
gg.sleep(500)
xg1(575,16,-8,false)--y
xg1(-4525.46063,16,-4,false)
xg1(-2259,16,-12,false)
end) end,
},
{"灰工集装箱",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(102,16,-8,true)--y
xg1(-2474.4606,16,-4,true)
xg1(-6128,16,-12,true)
gg.sleep(500)
xg1(102,16,-8,false)--y
xg1(-2474.4606,16,-4,false)
xg1(-6128,16,-12,false)
end) end,
},
})
}),
RG.box({"乱斗",
RG.buts({
{"空投点1",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(799,16,-8,true)--y
xg1(2932.199,16,-4,true)
xg1(-4221,16,-12,true)
gg.sleep(500)
xg1(799,16,-8,false)--y
xg1(2932.199,16,-4,false)
xg1(-4221,16,-12,false)
end) end,
},
{"空投点2",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1500,16,-8,true)--y
xg1(-5937.941,16,-4,true)
xg1(3917,16,-12,true)
gg.sleep(500)
xg1(1500,16,-8,false)--y
xg1(-5937.941,16,-4,false)
xg1(3917,16,-12,false)
end) end,
},
})
}),
RG.box({"单点占领",
RG.buts({
{"远征进点",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(200,16,-8,true)--y
xg1(-401.941,16,-4,true)--z
xg1(-1599,16,-12,true)--x
gg.sleep(500)
xg1(200,16,-8,false)--y
xg1(-401.941,16,-4,false)--z
xg1(-1599,16,-12,false)--x
end) end,
},
{"远征高台1",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(633,16,-8,true)--y
xg1(-254,16,-4,true)
xg1(-603,16,-12,true)
gg.sleep(500)
xg1(633,16,-8,false)--y
xg1(-254,16,-4,false)
xg1(-603,16,-12,false)
end) end,
},
{"远征高台2",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(509,16,-8,true)--y
xg1(0.75161904,16,-4,true)
xg1(-3474,16,-12,true)
gg.sleep(500)
xg1(509,16,-8,false)--y
xg1(0.75161904,16,-4,false)
xg1(-3474,16,-12,false)
end) end,
},
}),
RG.buts({
{"红石进点",function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(350,16,-8,true)--y
xg1(-1185.941,16,-4,true)--z
xg1(-799,16,-12,true)--x
gg.sleep(500)
xg1(350,16,-8,false)--y
xg1(-1185.941,16,-4,false)--z
xg1(-799,16,-12,false)--x
end) end,
},
{"红石高台1",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1394,16,-8,true)--y
xg1(218,16,-4,true)
xg1(3164,16,-12,true)
gg.sleep(500)
xg1(1394,16,-8,false)--y
xg1(218,16,-4,false)
xg1(3164,16,-12,false)
end) end,
},
{"红石高台2",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(470,16,-8,true)--y
xg1(77.41,16,-4,true)
xg1(-1738,16,-12,true)
gg.sleep(500)
xg1(470,16,-8,false)--y
xg1(77.41,16,-4,false)
xg1(-1738,16,-12,false)
end) end,
},
}),
RG.buts({{"盖亚进点",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(10,16,-8,true)--y
xg1(-482.941,16,-4,true)--z
xg1(-1188,16,-12,true)--x
gg.sleep(500)
xg1(10,16,-8,false)--y
xg1(-482,16,-4,false)--z
xg1(-1188,16,-12,false)--x
end) end,
},
{"盖亚高台1",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(390,16,-8,true)--y
xg1(-235.941,16,-4,true)
xg1(-2510,16,-12,true)
gg.sleep(500)
xg1(390,16,-8,false)--y
xg1(-235.941,16,-4,false)
xg1(-2510,16,-12,false)
end) end,
},
{"盖亚高台2",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1400,16,-8,true)--y
xg1(5651.46,16,-4,true)
xg1(204,16,-12,true)
gg.sleep(500)
xg1(1400,16,-8,false)--y
xg1(5651.46,16,-4,false)
xg1(204,16,-12,false)
end) end,
},
})
}), 
RG.box({"多点占领",
RG.buts({
{"暗黑星云进点1",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(5745,16,-8,true)--y
xg1(-303,16,-4,true)
xg1(-239,16,-12,true)
gg.sleep(500)
xg1(5745,16,-8,false)--y
xg1(-303,16,-4,false)
xg1(-239,16,-12,false)
end) end,
},
{"暗黑星云进点2",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(8018,16,-8,true)--y
xg1(7150,16,-4,true)
xg1(-255,16,-12,true)
gg.sleep(500)
xg1(8018,16,-8,false)--y
xg1(7150,16,-4,false)
xg1(-255,16,-12,false)
end) end,
},
{"暗黑星云辅助位",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(4073,16,-8,true)--y
xg1(10309,16,-4,true)
xg1(-16878,16,-12,true)
gg.sleep(500)
xg1(4073,16,-8,false)--y
xg1(10309,16,-4,false)
xg1(-16878,16,-12,false)
end) end,
},
}),
RG.buts({
{"陨星基地进点1",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1000,16,-8,true)--y
xg1(-1404,16,-4,true)
xg1(1389,16,-12,true)
gg.sleep(500)
xg1(1000,16,-8,false)--y
xg1(-1404,16,-4,false)
xg1(1389,16,-12,false)
end) end,
}, 
{"陨星基地进点2",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(100,16,-8,true)--y
xg1(1626,16,-4,true)
xg1(2071,16,-12,true)
gg.sleep(500)
xg1(100,16,-8,false)--y
xg1(1626,16,-4,false)
xg1(2071,16,-12,false)
end) end,
}, 
{"陨星基地进点3",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(202,16,-8,true)--y
xg1(234,16,-4,true)
xg1(-2906,16,-12,true)
gg.sleep(500)
xg1(202,16,-8,false)--y
xg1(234,16,-4,false)
xg1(-2906,16,-12,false)
end) end,
},
}),
RG.buts({
{"乐园进点1",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(190,16,-8,true)--y
xg1(103,16,-4,true)
xg1(-1509,16,-12,true)
gg.sleep(500)
xg1(190,16,-8,false)--y
xg1(103,16,-4,false)
xg1(-1509,16,-12,false)
end) end,
},
{"乐园进点2",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(99,16,-8,true)--y
xg1(2116,16,-4,true)
xg1(281,16,-12,true)
gg.sleep(500)
xg1(99,16,-8,false)--y
xg1(2116,16,-4,false)
xg1(281,16,-12,false)
end) end,
},
{"乐园进点3",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(98,16,-8,true)--y
xg1(-2125,16,-4,true)
xg1(1834,16,-12,true)
gg.sleep(500)
xg1(98,16,-8,false)--y
xg1(-2125,16,-4,false)
xg1(1834,16,-12,false)
end) end,
},
})
}),
RG.box({"无限擂台",
RG.buts({
{"中心",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(130,16,-8,true)--y
xg1(28,16,-4,true)
xg1(227,16,-12,true)
gg.sleep(500)
xg1(130,16,-8,false)--y
xg1(28,16,-4,false)
xg1(227,16,-12,false)
end) end,
},
{"高台1",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(803,16,-8,true)--y
xg1(-2245.1,16,-4,true)
xg1(272,16,-12,true)
gg.sleep(500)
xg1(803,16,-8,false)--y
xg1(-2245.1,16,-4,false)
xg1(272,16,-12,false)
end) end,
},
{"高台2",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(803,16,-8,true)--y
xg1(1185,16,-4,true)
xg1(-1718,16,-12,true)
gg.sleep(500)
xg1(803,16,-8,false)--y
xg1(1185,16,-4,false)
xg1(-1718,16,-12,false)
end) end,
}, 
}),
RG.buts({
{"高台3",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1400,16,-8,true)--y
xg1(5651.46,16,-4,true)
xg1(204,16,-12,true)
gg.sleep(500)
xg1(803,16,-8,false)--y
xg1(1169,16,-4,false)
xg1(2253,16,-12,false)
end) end,
},
{ "地下小空间",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(-95.5,16,-8,true)--y
xg1(-1452.46,16,-4,true)
xg1(1185,16,-12,true)
gg.sleep(500)
xg1(-45.5,16,-8,false)--y
xg1(-1452.46,16,-4,false)
xg1(1185,16,-12,false)
end) end,
},
{"柱子里",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(10,16,-8,false)--y
xg1(547,16,-4,false)
xg1(-616,16,-12,false)
gg.sleep(500)
xg1(10,16,-8,false)--y
xg1(547,16,-4,false)
xg1(-616,16,-12,false)
end) end,
},
}),
RG.buts({
{"斜坡旁(建议解体",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(-90,16,-8,true)--y
xg1(1028,16,-4,true)
xg1(789,16,-12,true)
gg.sleep(500)
xg1(-90,16,-8,false)--y
xg1(1028,16,-4,false)
xg1(789,16,-12,false)
end) end,
},
})
}),
RG.box({"试验场",
RG.buts({
{"雷达",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1546,16,-8,true)
xg1(1649.94140625,16,-4,true)
xg1(-3236.765625,16,-12,true)
gg.sleep(500)
xg1(1546,16,-8,false)
xg1(1649.94140625,16,-4,false)
xg1(-3236.765625,16,-12,false)
end) end,
},
{"车库",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(-50,16,-8,true)--y
xg1(2280,16,-4,true)
xg1(-4875,16,-12,true)
gg.sleep(500)
xg1(-50,16,-8,false)--y
xg1(2280,16,-4,false)
xg1(-4875,16,-12,false)
end) end,
},
{"禁闭小屋",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(427,16,-8,true)
xg1(986.94140625,16,-4,true)
xg1(-2060.765625,16,-12,true)
gg.sleep(500)
xg1(427,16,-8,false)
xg1(986.94140625,16,-4,false)
xg1(-2060.765625,16,-12,false)
end) end,
},
}),
RG.buts({
{"雷达旁",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(1210,16,-8,true)--y
xg1(426,16,-4,true)
xg1(-2630,16,-12,true)
gg.sleep(500)
xg1(1210,16,-8,false)--y
xg1(426,16,-4,false)
xg1(-2630,16,-12,false)
end) end,
},
{"发射仓",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(220,16,-8,true)--y
xg1(-4458,16,-4,true)
xg1(-825,16,-12,true)
gg.sleep(500)
xg1(220,16,-8,false)--y
xg1(-4458,16,-4,false)
xg1(-825,16,-12,false)
end) end,
},
{"大圆环",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(578,16,-8,true)--y
xg1(-2255,16,-4,true)
xg1(2614,16,-12,true)
gg.sleep(500)
xg1(578,16,-8,false)--y
xg1(-2255,16,-4,false)
xg1(2614,16,-12,false)
end) end,
},
}),
RG.buts({
{"猫爬架",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(448.6,16,-8,true)--y
xg1(-2007,16,-4,true)
xg1(1435,16,-12,true)
gg.sleep(500)
xg1(448.6,16,-8,false)--y
xg1(-2007,16,-4,false)
xg1(1435,16,-12,false)
end) end,
},
{"地图右上角斜坡",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(10,16,-8,true)--y
xg1(1156,16,-4,true)
xg1(1357,16,-12,true)
gg.sleep(100)
xg1(3,16,-8,false)--y
xg1(1156,16,-4,false)
xg1(1357,16,-12,false)
end) end,
}, 
})
}),
RG.check({"注意:进入游戏约7秒后传送才可以使用",}), 
RG.box1({"教程模式", 
RG.box({"建造模式新手教程",
RG.buts({
{"建造规则",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(4,16,-8,false)--y
xg1(752.199,16,-4,false)
xg1(-102,16,-12,false)
gg.sleep(500)
xg1(4,16,-8,false)--y
xg1(752.199,16,-4,false)
xg1(-102,16,-12,false)
gg.sleep(100)
xg1(244,16,-8,true)--y
xg1(2509,16,-4,true)
xg1(-109,16,-12,true)
gg.sleep(500)
xg1(244,16,-8,false)--y
xg1(2509,16,-4,false)
xg1(-109,16,-12,false)
end) end,
},
{"摧毁规则",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(8,16,-8,true)--y
xg1(-867.941,16,-4,true)
xg1(-112,16,-12,true)
gg.sleep(100)
xg1(8,16,-8,true)--y
xg1(-867.941,16,-4,true)
xg1(-112,16,-12,true)
gg.sleep(100)
xg1(5,16,-8,false)--y
xg1(727,16,-4,false)
xg1(-106,16,-12,false)
gg.sleep(100)
xg1(5,16,-8,false)--y
xg1(727,16,-4,false)
xg1(-106,16,-12,false)
end) end,
},
})
}),
RG.box({"占点模式新手教程",
RG.buts({
{"快速进点",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-40)
py1(257,4,-36)
py1(17039364,4,0)
xg1(-13,16,-8,false)--y
xg1(-14.199,16,-4,false)
xg1(-1652,16,-12,false)
gg.sleep(500)
xg1(-13,16,-8,false)--y
xg1(-14.199,16,-4,false)
xg1(-1652,16,-12,false)
end) end
},
})
})
}),
},{
RG.check({"仿变速灵体专区",}),
RG.check({"占点/猎场 使用",}),
RG.check({"",}),
RG.buts({
{"开启变速灵体" ,
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x453CBC}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 200}})
提示("开启成功")

end) end
}, 
{"恢复灵体" ,
function() enqueueTask(function()
HK()
local t = {"libclient.so:bss", "Cb"}
local tt = {0x453CBC}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 30}})
提示("恢复成功,恢复灵体时间会很长")
end) end
},
{"灵体掉坑出不来用" ,
function() enqueueTask(function()
HK()
gg.clearResults()
search(17039360,4,neicun)
py1(17039360,4,416)
xg1(-3,16,48,true)
sleep(1600)
xg1(1,16,48,false)
end) end
},
}),
RG.buts({
{"开启变速灵体②" ,
function() enqueueTask(function()
HK()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("30",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
gg.searchNumber("30",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
gg.getResults(114514)
gg.editAll("50.114514",gg.TYPE_FLOAT)
gg.clearResults()
提示("开启成功")
end) end
}, 
{"恢复灵体②" ,
function() enqueueTask(function()

HK()
gg.clearResults()
gg.setRanges(16)
gg.searchNumber("50.114514",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
gg.searchNumber("50.114514",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
gg.getResults(114514)
gg.editAll("30",gg.TYPE_FLOAT)
gg.clearResults()
提示("恢复成功,请刷新画质")
end) end
},
{"灵体掉坑出不来用②" ,
function() enqueueTask(function()
HK()
wuzhongli(1, 0)
xg1(-3,16,0,true)
gg.sleep(1600)
xg1(1,16,0,false)
gravityAddr = nil
end) end
},
}),
RG.line(),
RG.box({"一键组合技",
newcheck({nil,
{"飞天灵体" ,
function() enqueueTask(function()
HK()
gg.clearResults()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(567311400,16,-8,true)
gg.sleep(3009)
local t = {"libclient.so:bss", "Cb"}
local tt = {0x453CBC}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 200}})
gg.sleep(3109)
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(4000,16,-8,false)
提示("请不要解体/修复")
end) end
}, 
{"飞天灵体\n+反后坐" ,
function() enqueueTask(function()

HK()
gg.clearResults()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5671311400,16,-8,true)--真身高度
search(1077149696,4,neicun)
py1(1071644672,4,-96)
py1(1202590843,4,-52)
xg1(0,64,236,true)--枪口无上抬
gg.sleep(3009)
local t = {"libclient.so:bss", "Cb"}
local tt = {0x453CBC}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 200}})--灵体
gg.sleep(3109)
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(4000,16,-8,false)--回地面
xg1(-95.14,16,96,true)--反后坐
提示("请不要解体/修复")
end) end
}, 
{"飞天灵体\n+全局变速" ,
function() enqueueTask(function()

HK()
gg.clearResults()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(567311400,16,-8,true)
gg.sleep(3009)
local t = {"libclient.so:bss", "Cb"}
local tt = {0x453CBC}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 200}})
gg.sleep(3109)
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(4000,16,-8,false)--回地面
gg.sleep(900)
提示("开启成功")
gg.clearResults()
	gg.setRanges(gg.REGION_CODE_APP)
	gg.searchNumber("500", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
	if gg.getResultCount() == 0 then
		提示("开启失败")
		else
		gg.searchNumber("500",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
	gg.getResults(200)--设置修改前200个代码
		gg.editAll("-9999999999929194514", FLOAT)
		提示("全局变速开启成功")
		gg.clearResults()
	end
提示("请不要解体/修复")
gg.clearResults()
search(17039364,4,neicun)
	py1(16777215,4,-36)
	py1(257,4,-32)
	xg1(567311400,16,-8,true)
gg.sleep(3009)
	local t = {"libclient.so:bss", "Cb"}
local tt = {0x453CBC}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 200}})
gg.sleep(3109)
search(17039364,4,neicun)
	py1(16777215,4,-36)
	py1(257,4,-32)
	xg1(4000,16,-8,false)--回地面
gg.sleep(900)
提示("开启成功")
gg.clearResults()
	gg.setRanges(gg.REGION_CODE_APP)
	gg.searchNumber("500", FLOAT, false, gg.SIGN_EQUAL, 0, -1)
	if gg.getResultCount() == 0 then
		提示("开启失败")
		else
		gg.searchNumber("500",FLOAT , false, gg.SIGN_EQUAL, 0, -1)
	gg.getResults(200)--设置修改前200个代码
		gg.editAll("-9999999999929194514", FLOAT)
		提示("全局变速开启成功")
		gg.clearResults()
	end
提示("请不要解体/修复")
end) end
}, 
{"擂台使\n用灵体",
function() enqueueTask(function()

HK()
提示("真身传送至高台柱子里")
gg.clearResults()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(20,16,-8,false)--y
xg1(547,16,-4,false)
xg1(-616,16,-12,false)
gg.sleep(500)
xg1(20,16,-8,false)--y
xg1(547,16,-4,false)
xg1(-616,16,-12,false)
gg.sleep(1109)
提示("开启灵体功能")
local t = {"libclient.so:bss", "Cb"}
local tt = {0x453CBC}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 200}})
gg.sleep(7709)
提示("灵体被传送出来")
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5000,16,-8,false)
提示("请不要解体/修复")
gg.sleep(1)
提示("真身传送至高台柱子里")
gg.clearResults()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(20,16,-8,false)--y
xg1(547,16,-4,false)
xg1(-616,16,-12,false)
gg.sleep(500)
xg1(20,16,-8,false)--y
xg1(547,16,-4,false)
xg1(-616,16,-12,false)
gg.sleep(1109)
提示("开启灵体功能")
local t = {"libclient.so:bss", "Cb"}
local tt = {0x453CBC}
local ttt = S_Pointer(t, tt, true)
gg.setValues({{address = ttt, flags = 16, value = 200}})
gg.sleep(7709)
提示("灵体被传送出来")
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5000,16,-8,false)

end) end},
})
}),

RG.check({"以下功能搭配灵体使用",}),
RG.check({"范围伤害",}),
RG.box({"设置范围伤害",
RG.box1({"设置核心范围",
RG.switch("萌新范围",
function() luajava.newThread(function()
HK()
萌新范围开()
end):start() end,
function()
HK()
萌新范围关()
end
),
RG.switch("铠鼠范围",
function() luajava.newThread(function()
HK()
铠鼠范围开()
end):start() end,
function()
HK()
铠鼠范围关()
end
),
RG.switch("火萤范围",
function() luajava.newThread(function()
HK()
火萤范围开()
end):start() end,
function()
HK()
火萤范围关()
end
),
RG.switch("风声范围",
function() luajava.newThread(function()
HK()
风声范围开()
end):start() end,
function()
HK()
风声范围关()
end
),
RG.switch("大家伙范围",
function() luajava.newThread(function()
HK()
大家伙范围开()
end):start() end,
function()
HK()
大家伙范围关()
end
),
RG.switch("夜莺范围",
function() luajava.newThread(function()
HK()
夜莺范围开()
end):start() end,
function()
HK()
夜莺范围关()
end
),
RG.switch("网虫范围",
function() luajava.newThread(function()
HK()
网虫范围开()
end):start() end,
function()
HK()
网虫范围关()
end
),
RG.switch("幻灵范围",
function() luajava.newThread(function()
HK()
幻灵范围开()
end):start() end,
function()
HK()
幻灵范围关()
end
),
RG.switch("铁驭/赋能/序列范围",
function() luajava.newThread(function()
HK()
铁驭范围开()
end):start() end,
function()
HK()
铁驭范围关()
end
),
RG.button('一键开启核心范围',
function() luajava.newThread(function()
HK()
一键开启核心范围执行()
end):start() end),
RG.button('一键关闭核心范围',
function() luajava.newThread(function()
HK()
一键关闭核心范围执行()
end):start() end),
}),
RG.line(),
RG.check({"false/true",}),
RG.switch("是/否冻结以下范围修改",
function() luajava.newThread(function()
是否冻结切换(true)
提示("已切换为冻结范围")
end):start() end,
function()
是否冻结切换(false)
HA()
提示("已切换为非冻结范围")
end
),
RG.check({"关/开",}),
RG.switch("秒杀范围回拉",
function() luajava.newThread(function()
回拉值切换(true)
提示("已开启秒杀范围回拉")
end):start() end,
function()
回拉值切换(false)
提示("已关闭秒杀范围回拉")
end
),
RG.check({"浮点/二进制",}),
RG.switch("车体范围切换",
function() luajava.newThread(function()
msfwqh = true 
提示("已切换为二进制版本秒杀范围")
end):start() end,
function()
msfwqh = false 
提示("已切换为浮点版本秒杀范围")
end
),
RG.check({"关/开",}),
RG.switch("子弹无伤",
function() luajava.newThread(function()
HK()
子弹无伤开()
end):start() end,
function()
HK()
子弹无伤关()
end
),
RG.check({"关/开",}),
RG.switch("子弹打盾无伤",
function() luajava.newThread(function()
HK()
子弹打盾无伤开()
end):start() end,
function()
HK()
子弹打盾无伤关()
end
),
RG.check({"2级/1级",}),
RG.switch("模块增伤伤害等级",
function() luajava.newThread(function()
HK()
setDamageLevel(1)
end):start() end,
function()
HK()
setDamageLevel(2)
end
),
RG.line(),
RG.box1({"模块增伤",
RG.switch("上等兵",
function() enqueueTask(function()
HK()
zengshang(4020,1)
end) end,
function()
HK()
zengshang(4020,0)
end
),
RG.switch("午夜派对",
function() enqueueTask(function()
HK()
zengshang(4040,1)
end) end,
function()
HK()
zengshang(4040,0)
end
),
RG.switch("碧蓝使者",
function() enqueueTask(function()
HK()
zengshang(4140,1)
end) end,
function()
HK()
zengshang(4140,0)
end
),
RG.switch("穿云",
function() enqueueTask(function()
HK()
zengshang(3104010,1)
end) end,
function()
HK()
zengshang(3104010,0)
end
),
RG.switch("裂空",
function() enqueueTask(function()
HK()
zengshang(3704010,1)
end) end,
function()
HK()
zengshang(3704010,0)
end
),
RG.switch("球状闪电",
function() enqueueTask(function()
HK()
zengshang(3404010,1)
end) end,
function()
HK()
zengshang(3404010,0)
end
),
RG.switch("防空炮",
function() enqueueTask(function()
HK()
zengshang(3704020,1)
end) end,
function()
HK()
zengshang(3704020,0)
end
),
RG.switch("泡泡枪",
function() enqueueTask(function()
HK()
zengshang(3511010,1)
end) end,
function()
HK()
zengshang(3511010,0)
end
),
RG.switch("业火焚世",
function() enqueueTask(function()
HK()
zengshang(3304010,1)
end) end,
function()
HK()
zengshang(3304010,0)
end
),
RG.switch("自定义模块增伤",
function() enqueueTask(function()
HK()
local input = gg.prompt({'自定义模块增伤'}, {[1]='4020'})
if not input then return end
zidinyimokuaizenshang = tonumber(input[1])
if not zidinyimokuaizenshang then
zidinyimokuaizenshang = 4020
提示("输入无效，使用默认值4020")
end
zengshang(zidinyimokuaizenshang,1)
end) end,
function()
HK()
if zidinyimokuaizenshang then
zengshang(zidinyimokuaizenshang,0)
else
提示("请先使用自定义模块增伤功能")
end
end
),
RG.switch("自定义模块穿透",
function() enqueueTask(function()
HK()
local input = gg.prompt({'自定义模块穿透'}, {[1]='3304010'})
if not input then return end
zidinyimokuaicuantou = tonumber(input[1])
if not zidinyimokuaicuantou then
zidinyimokuaicuantou = 3304010
提示("输入无效，使用默认值3304010")
end
zengshang(zidinyimokuaicuantou,1)
end) end,
function()
HK()
if zidinyimokuaicuantou then
zengshang(zidinyimokuaicuantou,0)
else
提示("请先使用自定义模块穿透功能")
end
end
),
RG.button("查看模块ID",
function() runAsyncTask(function()
HK()
showAllKnownModules()
end) end),
}),
RG.line(),
RG.box1({"模块缴械",
RG.switch("腾跃缴械",
function() enqueueTask(function()
HK()
腾跃缴械开()
end) end,
function()
HK()
腾跃缴械关()
end
),
RG.switch("鹰驰缴械",
function() enqueueTask(function()
HK()
鹰驰缴械开()
end) end,
function()
HK()
鹰驰缴械关()
end
),
RG.switch("大力神缴械",
function() enqueueTask(function()
HK()
大力神缴械开()
end) end,
function()
HK()
大力神缴械关()
end
),
RG.switch("海王盾缴械",
function() enqueueTask(function()
HK()
海王盾缴械开()
end) end,
function()
HK()
海王盾缴械关()
end
),
RG.switch("重装魔方缴械",
function() enqueueTask(function()
HK()
重装魔方缴械开()
end) end,
function()
HK()
重装魔方缴械关()
end
),
RG.switch("天行者缴械",
function() enqueueTask(function()
HK()
天行者缴械开()
end) end,
function()
HK()
天行者缴械关()
end
),
RG.switch("午夜派对缴械",
function() enqueueTask(function()
HK()
午夜派对缴械开()
end) end,
function()
HK()
午夜派对缴械关()
end
),
RG.switch("穿云缴械",
function() enqueueTask(function()
HK()
穿云缴械开()
end) end,
function()
HK()
穿云缴械关()
end
),
RG.switch("穹弩缴械",
function() enqueueTask(function()
HK()
穹弩缴械开()
end) end,
function()
HK()
穹弩缴械关()
end
),
RG.switch("特斯拉的巨剑缴械",
function() enqueueTask(function()
HK()
特斯拉的巨剑缴械开()
end) end,
function()
HK()
特斯拉的巨剑缴械关()
end
),
RG.switch("小指头缴械",
function() enqueueTask(function()
HK()
小指头缴械开()
end) end,
function()
HK()
小指头缴械关()
end
),
RG.switch("业火焚世缴械",
function() enqueueTask(function()
HK()
业火焚世缴械开()
end) end,
function()
HK()
业火焚世缴械关()
end
),
RG.switch("寂静之声缴械",
function() enqueueTask(function()
HK()
寂静之声缴械开()
end) end,
function()
HK()
寂静之声缴械关()
end
),
RG.switch("苍穹守护缴械",
function() enqueueTask(function()
HK()
苍穹守护缴械开()
end) end,
function()
HK()
苍穹守护缴械关()
end
),
RG.switch("野蜂缴械",
function() enqueueTask(function()
HK()
野蜂缴械开()
end) end,
function()
HK()
野蜂缴械关()
end
)
}),
RG.line(),
RG.box1({"设置车体范围",
RG.switch("正常秒杀范围优化",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    正常秒杀范围优化()
else
    正常秒杀范围优化二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("正常秒杀范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    正常秒杀范围()
else
    正常秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("不挡秒杀范围(新)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    不挡秒杀范围新()
else
    不挡秒杀范围新二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("队友不挡高伤范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    队友不挡高伤范围()
else
    队友不挡高伤范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("执行迅速秒杀范围(新)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    执行迅速秒杀范围新()
else
    执行迅速秒杀范围新二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("频率优化秒杀范围(旧)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    频率优化秒杀范围旧()
else
    频率优化秒杀范围旧二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("频率优化秒杀范围(新)",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    频率优化秒杀范围新()
else
    频率优化秒杀范围新二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("极小秒杀范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    极小秒杀范围()
else
    极小秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("迫击炮延迟发包(轰炸区)",
function() luajava.newThread(function()
HK()
paijipaofabao(true)
end):start() end,
function()
paijipaofabao(false)
end
),
RG.switch("子弹穿墙",
function() luajava.newThread(function()
HK()
提示('已开启')
子弹穿墙开()
end):start() end,
function()
HK()
提示('已关闭')
子弹穿墙关()
end
),
}),
RG.line(),
RG.box1({"设置车体旧范围",
RG.switch("不秒杀范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    不秒杀范围()
else
    不秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("自定义不秒杀范围",
function() luajava.newThread(function()
HK()
if msfwqh == false then
    自定义不秒杀范围()
else
    自定义不秒杀范围二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("子弹穿墙",
function() luajava.newThread(function()
HK()
提示('已开启')
子弹穿墙开()
end):start() end,
function()
HK()
提示('已关闭')
子弹穿墙关()
end
),
RG.check({"以下范围伤害可能容易闪退",}),
RG.switch("范围穿甲弹",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    范围穿甲弹()
else
    范围穿甲弹二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("自瞄炮范围",
function() luajava.newThread(function()
HK()
提示('范围已开启')
自瞄炮范围()
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
RG.switch("高伤",
function() luajava.newThread(function()
HK()
提示('范围已开启')
if msfwqh == false then
    高伤()
else
    高伤二进制()
end
end):start() end,
function()
fw1=false
提示("已停止所有范围循环")
end
),
}),
}),
RG.line(),
RG.box({"设置后坐",
RG.radio({"",
{"反后坐(会穿墙)" ,
function() enqueueTask(function()
HK()
提示("传送至高空并开启后坐")
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5000,16,-8,false)
xg1(-3.5,16,96,true) 
end) end
}, 
{"反后坐plus" ,
function() enqueueTask(function()
HK()
提示("传送至高空并开启后坐")
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5000,16,-8,false)
xg1(-9,16,96,true) 
end) end
}, 
{"无重力反后坐" ,
function() enqueueTask(function()
HK()
提示("传送至高空并开启后坐")
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(5000,16,-8,false)
xg1(-35,16,96,true) 
end) end
}, 
{"高后坐",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(3.5,16,96,true) 
end) end},
{"高后坐plus",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(9,16,96,true) 
end) end},
{"机枪后坐",
function() enqueueTask(function()
HK()
gg.clearResults()
local info = gg.getTargetInfo()
if info.x64 then
提示("64位机枪后坐力正在开启")
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg1(-9,16,24,false)
else
提示("32位机枪后坐力正在开启")
gg.searchNumber("1.9375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(1000)
for i, v in ipairs(results) do
    v.address = v.address + 0x14
end
gg.loadResults(results)
gg.refineNumber("1.12103877e-44", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results2 = gg.getResults(1000)
for i, v in ipairs(results2) do
    v.address = v.address + 0x18
end
gg.loadResults(results2)
gg.refineNumber("89,128.9609375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results3 = gg.getResults(1000)
for i, v in ipairs(results3) do
    v.address = v.address + 0x24
end
gg.loadResults(results3)

gg.editAll("-9", gg.TYPE_FLOAT)
提示("已开启反向后坐力")
gg.clearResults()
end
end) end},
{"自定义机枪后坐",
function() enqueueTask(function()
HK()
gg.clearResults()
local info = gg.getTargetInfo()
if info.x64 then
提示("64位机枪后坐力正在开启")
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg3(-9,16,24,false,"(自定义机枪后坐)")
else
提示("32位机枪后坐力正在开启")
gg.refineNumber("89,128.9609375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local finalResults = gg.getResults(1000)
local currentValue = finalResults[1] and finalResults[1].value or "未知"
local pt = "当前值:" .. tostring(currentValue) .. " | 输入新值(推荐:-9)"
local i = gg.prompt({pt, "记住"}, {"-9", false}, {"number", "checkbox"})
if not i then
提示("已取消")
gg.clearResults()
return
end
local inputValue = i[1]
if not inputValue or not inputValue:match("^%-?%d+%.?%d*$") then
提示("输入错误,已取消")
gg.clearResults()
return
end
for j, v in ipairs(finalResults) do
v.address = v.address + 0x24
end
gg.loadResults(finalResults)
gg.editAll(inputValue, gg.TYPE_FLOAT)
提示("共修改 " .. #finalResults .. " 个数据 → " .. inputValue)
gg.clearResults()
end
end) end},
{"自定义后坐",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg3(nil,16,96,true,"(自定义后坐力)")
end) end},
{"机枪离线",
function() enqueueTask(function()
HK()
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg3(-1,4,24,false,true,"(机枪离线)")
end) end},
{"恢复以上",
function() enqueueTask(function()
HK()
search(17039364,4,neicun)
py1(16777215,4,-36)
py1(257,4,-32)
xg1(0.007352941203862429,16,96,false)
gg.clearResults()
local info = gg.getTargetInfo()
if info.x64 then
提示("64位机枪后坐力正在关闭")
search(3.1015625,16,neicun)
py1(1.8125,16,-48)
py1(2.125,16,48)
xg1(1081466880,4,24,false)
xg1(3.841796875,16,24,false)
else
提示("32位机枪后坐力正在关闭")
gg.searchNumber("1.9375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(1000)
for i, v in ipairs(results) do
    v.address = v.address + 0x14
end
gg.loadResults(results)
gg.refineNumber("1.12103877e-44", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results2 = gg.getResults(1000)
for i, v in ipairs(results2) do
    v.address = v.address + 0x18
end
gg.loadResults(results2)
gg.refineNumber("89,128.9609375", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
local results3 = gg.getResults(1000)
for i, v in ipairs(results3) do
    v.address = v.address + 0x24
end
gg.loadResults(results3)
gg.editAll("3.841796875", gg.TYPE_FLOAT)
提示("已关闭反向后坐力")
gg.clearResults()
end
end) end},
})
}),
RG.line(),
},{
RG.button("强制取消循环功能", 
function() luajava.newThread(function()
HK()
fw1=false
end):start() end),
RG.button("取消所有冻结", 
function() luajava.newThread(function()
gg.clearResults()
gg.clearList()
end):start() end),
RG.button("📜更新日志📜" ,
function() luajava.newThread(function()
gg.alert('v1.0舍弃原辅助Pentago Pro，更名为RG 作者Q号:936039811，更新不闪退的核心范围\nv1.1新增每次使用功能后会显示所使用的功能,优化UI\nv1.2修复UI隐藏按钮消失的bug，改良核心范围\nv1.3再次改良核心范围，运行变得更快，增加开屏动画，新增切换32位模式并添加些许功能，新增队友不挡范围\nv1.4新增破隐，新增全局加速，转圈圈功能无需解体，新增设置光照，新增天线功能，改善不挡范围，清除了每次执行功能时弹出的绘制文字\nv1.5新增惯性加速，新增瞬移不稳定加速，新增其它外挂(其它的所有外挂均有改动)，改善天罚功能\nv1.6新增无视车型秒杀范围\nv1.7修复无视车型秒杀范围的副作用，新增不挡秒杀范围，调整开启反后坐后上升的高度，32位模式中新增些许功能\nv1.8新增不挡核心秒杀范围，新增灵魂出窍\nv1.9循环范围区新增功能\n2.0修复全局变速，修复设置光照，修复设置天线，新增仿gg变速自瞄炮，增加些许天罚功能，新增拖拽感，新增灵魂出窍，新增设置视角，新增取消冻结\n2.1新增(全图毒(刀)人)，新增设置视角，删去一些无用的功能，新增冻结核心范围(在局内开启，概率闪退，若没有闪退并显示加载完成则说明以后的每一局都有效)，改善设置光照，循环范围栏新增功能，新增试验场传送，\nv2.2美化UI，更新函数变速，更新极高空飞行，更新无重力反后坐，删除正常范围\nv2.3将冻结核心范围改回并添加了内存设置，32位版本更新诸多内容\nv2.4删除冻结核心范围，新增核心秒杀范围，新增穿墙，美化toast，优化传送，优化爬墙\nv2.5修复地龟山石头的传送坐标，硬核加速区新增功能，新增固定位置，\nv2.6新增透视功能,新增设置高度基址，优化锁核初始化的速度，优化坐标功能，新增获取自身坐标\nv2.7优化恢复光照的速度，新增自定义光照，优化恢复透视的速度，新增设置拖拽感，新增需解体功能，新增音效延迟功能\nv2.8更新地图功能，更新核心范围(几乎全核心\nv2.9自身车体倾斜，新增特殊天线，新增速度数值设置\nv3.0修复核心范围\nv3.1优化核心范围(仅需开启一次即可全局有效)\nv3.2更新全图毒人\nv3.3更新超级毒人\nv3.4更新刀人/全局离线/全局闪退\nv3.5更新核心加速([仅解体能用]靠近实体不失效版本)\nv3.6游戏更新硬核加速(偏移修改失效)(基址仍然可用)\nv3.7更新大力神加速\nv3.8更新新核心范围32位\nv3.9修复记录坐标传送(增加更多可记录坐标)\nv4.0增加环绕玩家\nv4.1修复32位核心范围\nv4.2修复大力神加速(由于游戏的问题,部分在游戏局内开启失败后请退回到大厅并大退重启游戏,这样可以解决无法开启的问题)')
end):start() end),
RG.box({"功能介绍手册",
RG.button("功能介绍-----战斗区" ,
function() luajava.newThread(function()
gg.alert('战斗区:\n⊙设置加速【使用功能后解体修复即可获得对应的加速】\n⊙设置单次/循环范围【将除自己外所有人的核心体积放大,可以更轻易地打到(要注意,若开启循环范围后还想开启其他功能,需停止循环】\n⊙设置后坐【使用高后坐功能后,武器的后坐力将会增强.使用反后坐功能后,武器的后坐力将会增强并且变为反向(但会穿墙,所以才会先传送至高空)】\n⊙设置高度【使用功能后,自身将会传送至对应高度并冻结在对应高度】\n⊙锁核心【使用锁核心功能需先初始化锁核(也许需要40秒左右),随后便可以选择锁核玩家(选择玩家后将会把自身传送至对应玩家的核心上) 每局游戏结束后需清除锁核残留】')
end):start() end),
RG.button("功能介绍-----坐标区" ,
function() luajava.newThread(function()
gg.alert('坐标区:\n⊙自定义坐标传送【输入X、Y、Z轴并点击确定后即可传送到对应的坐标】\n⊙各模式传送功能【使用后即可传送至对应地点】')
end):start() end),
RG.button("功能介绍-----娱乐区" ,
function() luajava.newThread(function()
gg.alert('娱乐区:\n⊙隐藏UI【使用功能后会将所有的UI及按键隐藏,但因为某些特性,停止移动后会四处弹射,所以不要停止移动】\n⊙无法移动【使用功能后,车体将无法移动,可以通过推进器等模块进行前进】\n⊙天罚加速【使用功能后,天罚的速度将会越来越快】\n⊙冻结天罚【使用功能后,天罚将会冻结在某个坐标上】\n⊙视角锁定【使用功能后,自身的朝向将会固定】\n⊙特效加速【将所有特效及动作加速】\n⊙特效减速【将所有特效及动作减速,但自身朝向会固定】\n⊙转圈圈【自身旋转】\n⊙无重力【自身失去重力并向上漂浮】')
end):start() end),
RG.button("功能介绍-----其它区" ,
function() luajava.newThread(function()
gg.alert('其它区:\n⊙进入虚幻世界【使用功能后,地图崩坏,自身、队友、敌人将会消失,会有杂音】\n⊙薄雾【使用功能后会产生淡蓝色的薄雾】\n⊙浓雾【使用功能后,会产生淡蓝色的浓雾】\n⊙除雾【使用功能后,会将天边的武器遮挡去除】\n⊙不倒翁【使用功能后,自身将垂直于地面】\n⊙反向不倒翁【使用功能后,自身将将翻转过来并垂直于地面】\n⊙爬墙【使用功能后,自身靠近某些建筑物下方时会传送到其建筑物上方(部分地图无效)】')
end):start() end),
RG.button("功能介绍-----休闲区" ,
function() luajava.newThread(function()
gg.alert('休闲区:\n⊙音乐搜索【输入想要找到音乐即可播放】\n⊙AI聊天【输入想要说的话,AI将会答复你的话】\n⊙看视频【点击按钮后,过段时间会弹出选择视频界面(每次刷新的视频都不一样),选择后即可观看】')
end):start() end),
}),
RG.box({"❓帮助❓",
 RG.button("后坐/传送/加速等失效" ,
function() luajava.newThread(function()
gg.alert('刚出战、刚切换画质、周围有其他玩家(敌人/队友)、炮台、分身时，有关自身移动的功能将会失效 等待几秒便可使用(周围要没有其他的 玩家、炮台、分身)，其判定距离大概是3～4个建筑块')
end):start() end),
}),
RG.button("加入QQ群" ,
function() luajava.newThread(function()
local function showPrompt()
local qun = '646882797'
local link = "https://qm.qq.com/q/xlo6Lm2ZbO"
local choice = gg.alert('群:646882797', '取消', '加入Q群', '浏览器加群')
if choice == 2 then
if qq and qq.joinGroup then
提示("正在跳转到QQ加群页面，请稍候…")
qq.joinGroup(qun)
else
提示("加群功能不可用")
end
elseif choice == 3 then
local browserChoice = gg.alert("群:646882797", "取消", "点击将跳转默认浏览器", "返回")
if browserChoice == 2 then
app.openUrl(link)
elseif browserChoice == 3 then
提示("返回")
showPrompt()
elseif browserChoice == 1 then
提示("已取消操作")
end
elseif choice == 1 then
提示("已取消操作")
end
end
showPrompt()
end):start() end),
RG.button("🗑️清理任务列表🗑️", 
function() luajava.newThread(function()
clearTaskQueue()
gg.sleep(100)
clearTaskQueue()
gg.sleep(100)
clearTaskQueue()
end):start() end),
RG.button("⚙️自动选择进程⚙️" ,
function() runAsyncTask(function()
local function getZzszProcesses()
    local info = gg.getTargetInfo()
    if info and info.packageName then
        local app = require("app")
        local name = app.getName(info.packageName)
        if name and string.find(string.lower(name), "重装上阵") then
            return {{
                name = name,
                package = info.packageName
            }}
        end
    end

    local app = require("app")
    local processList = app.runList() or {}
    local result = {}
    local targetName = "重装上阵"

    local maxCheck = math.min(#processList, 30)
    for i = 1, maxCheck do
        local pkg = tostring(processList[i])
        if gg.isPackageInstalled(pkg) then
            local name = app.getName(pkg)
            if name and string.find(string.lower(name), targetName) then
                table.insert(result, {
                    name = name,
                    package = pkg
                })
            end
        end
    end

    table.sort(result, function(a, b)
        return a.package < b.package
    end)

    return result
end

function autoSetMemoryRange()
    gg.clearResults()
    gg.setRanges(4) -- Ca
    gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)

    if gg.getResultCount() == 0 then
        gg.clearResults()
        gg.setRanges(-2080896) -- O
        gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)

        if gg.getResultCount() == 0 then
            提示("内存已自动设为A")
            neicun = 32
            gg.sleep(100)
            return 32
        else
            提示("内存已自动设为O")
            neicun = -2080896
            gg.sleep(100)
            return -2080896
        end
    else
        提示("内存已自动设为Ca")
        neicun = 4
        gg.sleep(100)
        return 4
    end
end

function xxhq()
    提示("正在搜索重装上阵进程...")

    local processes = getZzszProcesses()
    if #processes == 0 then
        gg.alert("未找到重装上阵游戏进程\n请确保游戏已运行")
        return false
    end

    local selected = processes[1]
    提示("自动选中: " .. selected.name)

    local success = pcall(function()
        gg.setProcess(selected.package)
    end)
    if not success then
        gg.alert("切换到进程失败")
        return false
    end

    local info = gg.getTargetInfo()
    local processName = info and info.activities and info.activities[1].label or selected.name
    local processBits = info and info.x64 and "64位" or "32位"
    local memoryRange = autoSetMemoryRange()

    local memoryText = ""
    if memoryRange == 4 then
        neicun = 4
        gg.sleep(100)
        memoryText = "Ca(4)"
    elseif memoryRange == 32 then
        neicun = 32
        gg.sleep(100)
        memoryText = "A(32)"
    elseif memoryRange == -2080896 then
        neicun = -2080896
        gg.sleep(100)
        memoryText = "O(-2080896)"
    else
        memoryText = tostring(memoryRange)
    end

    local time = os.date("%Y年%m月%d日 %H:%M:%S")
    local infoMsg = string.format(
        "当前时间: %s\n进程名称: %s\n包名: %s\n进程位数: %s\n内存范围: %s",
        time, processName, selected.package, processBits, memoryText
    )
    gg.alert(infoMsg)

    gg.setRanges(memoryRange)
    return true
end

xxhq()
end)
end),
RG.button("🔍选择进程🔍" ,
function() runAsyncTask(function()
提示("请选择进程")

gg.setProcessX()
gg.sleep(3000)
gg.clearResults()
gg.setRanges(4)
gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
gg.clearResults()
gg.setRanges(-2080896)
gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
if gg.getResultCount() == 0 then
提示("内存已自动设为A")
neicun=32
else
提示("内存已自动设为O")
neicun=-2080896
end
else
提示("内存已自动设为Ca")
neicun=4
end
end)
end),
RG.button("用户协议",
function() luajava.newThread(function()
gg.alert("感谢您选择使用我们的软件\n在使用该软件之前请仔细阅读以下说明内容并确保您遵守法律法规和道德规范。\n1. 软件适用范围：本软件仅供参考学习之用。用户需要自行承担使用该软件可能带来的风险和责任，包括但不限于游戏账号封禁等。请用户合法合理使用本软件并遵守相关游戏或平台的规定。\n2. 免责声明：由于外挂软件的使用可能涉及侵权、犯罪等行为，开发者对于使用者的行为不承担任何法律责任。如有反法律法规之行为，开发者将不为其承担任何法律责任。\n3. 功能介绍：该软件提供一些额外的辅助功能以提升用户在所需领域的学习效果，但并不具备自主完成任务的能力。用户在使用软件的过程中需要灵活运用学习资源并结合自身的实际情况进行学习。\n4. 安全保障：我们严格遵守国家法律法规的规定，采取各种安全措施确保软件的安全性。然而，由于互联网环境的不确定性和非法黑客的存在，我们无法完全保证软件的绝对安全性。用户在下载、安装和使用软件时应自行承担风险。\n5. 法律合规：用户在使用本软件时需自行承担遵守当地法律法规的责任。任何非法使用行为都是用户人的行为，与本软件的开发者无关。如果用户违反国家法律法规的规定，软件开发者将主动配合相关部门进行调查并提供用户违法犯罪的证据。\n请您仔细阅读并遵守以上使用说明。如有任何问题或建议，请随时联系我们的客服团队，我们将尽力您提供帮助与支持。\n继续使用则表示同意以上条款\n感谢您的支持与合作")
end):start() end),
RG.box({'内存设置',
RG.radio({"内存设置",
{"🔶Ca内存 ",
function() luajava.newThread(function() 
neicun = 4
提示("内存已设置Ca") 
end):start() end
},
{"🔶A内存 ",
function() luajava.newThread(function() 
neicun = 32
提示("内存已设置A")
end):start() end
},{"🔶O内存",
function() luajava.newThread(function() 
neicun = -2080896
提示("内存已设置O")
end):start() end
}
})
}),
RG.box({"菜单背景",
RG.radio({"菜单背景",
{"自定义背景色",
function()
local colorInput = gg.prompt({"请输入颜色码"},{"#00000000"},{"text"})
if colorInput and colorInput[1] then
local color = colorInput[1]
color = color:gsub("%s+", ""):upper()
color = color:gsub("^0X", "#")
if not color:match("^#") then
color = "#" .. color
end
local hexOnly = color:gsub("[^0-9A-F]", "")
if #hexOnly == 6 then
color = "#" .. hexOnly
luajava.runUiThread(function()
设置背景颜色(color)
saveBackgroundColor(color)
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
提示("背景颜色已设置为: "..color)
elseif #hexOnly == 8 then
color = "#" .. hexOnly
luajava.runUiThread(function()
设置背景颜色(color)
saveBackgroundColor(color)
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
提示("背景颜色已设置为: "..color)
elseif #hexOnly == 3 then
local r = hexOnly:sub(1,1):rep(2)
local g = hexOnly:sub(2,2):rep(2)
local b = hexOnly:sub(3,3):rep(2)
color = "#" .. r .. g .. b
luajava.runUiThread(function()
设置背景颜色(color)
saveBackgroundColor(color)
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
提示("背景颜色已设置为: "..color)
elseif #hexOnly == 4 then
local a = hexOnly:sub(1,1):rep(2)
local r = hexOnly:sub(2,2):rep(2)
local g = hexOnly:sub(3,3):rep(2)
local b = hexOnly:sub(4,4):rep(2)
color = "#" .. a .. r .. g .. b
luajava.runUiThread(function()
设置背景颜色(color)
saveBackgroundColor(color)
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
提示("背景颜色已设置为: "..color)
else
提示("长度错误! 需要:\n3位: RGB\n4位: ARGB\n6位: RRGGBB\n8位: AARRGGBB")
end
else
提示("未输入颜色代码")
end
end
},
{"灰色",
function()
luajava.runUiThread(function()
设置背景颜色("#808080")
saveBackgroundColor("#808080")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"透明",
function()
luajava.runUiThread(function()
设置背景颜色("#00000000")
saveBackgroundColor("#00000000")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"红色",
function()
luajava.runUiThread(function()
设置背景颜色("#FF0000")
saveBackgroundColor("#FF0000")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
}, 
{"深紫色",
function()
luajava.runUiThread(function()
设置背景颜色("#871F78")
saveBackgroundColor("#871F78")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"鹤红色",
function()
luajava.runUiThread(function()
设置背景颜色("#8E236B")
saveBackgroundColor("#8E236B")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"石英色",
function()
luajava.runUiThread(function()
设置背景颜色("#D9D9F3")
saveBackgroundColor("#D9D9F3")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"绿色",
function()
luajava.runUiThread(function()
设置背景颜色("#00FF00")
saveBackgroundColor("#00FF00")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"深石板蓝",
function()
luajava.runUiThread(function()
设置背景颜色("#6B238E")
saveBackgroundColor("#6B238E")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"中海蓝色",
function()
luajava.runUiThread(function()
设置背景颜色("#32CD99")
saveBackgroundColor("#32CD99")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"深铅灰色",
function()
luajava.runUiThread(function()
设置背景颜色("#2F4F4F")
saveBackgroundColor("#2F4F4F")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"鲑鱼色",
function()
luajava.runUiThread(function()
设置背景颜色("#6F4242")
saveBackgroundColor("#6F4242")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"深棕褐色",
function()
luajava.runUiThread(function()
设置背景颜色("#97694F")
saveBackgroundColor("#97694F")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"黑色",
function()
luajava.runUiThread(function()
设置背景颜色("#000000")
saveBackgroundColor("#000000")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"巧克力色",
function()
luajava.runUiThread(function()
设置背景颜色("#5C3317")
saveBackgroundColor("#5C3317")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"火砖色",
function()
luajava.runUiThread(function()
设置背景颜色("#8E2323")
saveBackgroundColor("#8E2323")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"中绿松石色",
function()
luajava.runUiThread(function()
设置背景颜色("#70DBDB")
saveBackgroundColor("#70DBDB")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
},
{"艳粉红色",
function()
luajava.runUiThread(function()
设置背景颜色("#FF1CAE")
saveBackgroundColor("#FF1CAE")
if AS.optionStates["启动时自动开启上次的选项"] then
AS.triggerSave()
end
end)
end
}, 
}),
}), 
RG.line(),
RG.check({"关闭/启用",}),
RG.switch("进程崩溃脚本保活(脚本防崩溃)",
function() luajava.newThread(function()
startCrashProtection()
end):start() end,
function()
stopCrashProtection()
end
),
RG.button("查看防崩溃运行状态", 
function() luajava.newThread(function()
showProtectionStatus()
end):start() end),
RG.line(),
RG.check({ "开/关" }),
RG.switch("启动脚本时播放音乐", music_off, music_on),
RG.line(),
RG.check({ "恢复/暂停" }),
RG.switch("暂停所选进程", pause_off, pause_on),
RG.line(),
RG.check({ "隐藏/显示" }),
RG.switch("修改器悬浮窗显示", float_off, float_on),
RG.line(),
RG.check({ "关闭/启用" }),
RG.switch("语音播报开关", voice_off, voice_on),
RG.line(),
RG.check({ "alert/信息提示方式" }),
RG.switch("清理任务列表提示切换", clear_off, clear_on),
RG.line(),
RG.check({ "gg.diyToast/gg.toast" }),
RG.switch("信息提示方式切换", toast_off, toast_on),
RG.line(),
RG.check({ "true/false" }),
RG.switch("拾取范围冻结切换", pickup_off, pickup_on),
RG.line(),
RG.check({ "关闭/启用" }),
RG.switch("坐标类自动初始化", coord_off, coord_on),
RG.line(),
RG.check({ "关闭/启用" }),
RG.switch("切换非冻结时自动清除冻结", clearfreeze_off, clearfreeze_on),
RG.line(),
RG.check({ "false/true" }),
RG.switch("坐标异常回溯时冻结坐标", pullFreeze_off, pullFreeze_on),
RG.line(),
RG.check({ "启用/关闭" }),
RG.switch("启动时自动开启上次的选项", auto_off, auto_on),
RG.line(),
RG.button("自启动选项记录", 
function() luajava.newThread(function()
查看保存状态()
end):start() end),
RG.line(),
RG.button("退出辅助", 
function() luajava.newThread(function()
关闭所有快捷键悬浮窗()
window : removeView(floatWindow )
luajava.setFloatingWindowHide(false )
bloc("end")
end):start() end)
}
})
jm1 : setBackground(slcta )
gg.setVisible(false)
luajava.setFloatingWindowHide(true)
gg.sleep(200)
kongzhi_jishi("重置")
loadBackgroundColor()
AS.restore()
writeLog(">>> 脚本初始化完成")
---bloc不要动 动了脚本功能会失效
bloc = luajava.getBlock()
bloc("join")
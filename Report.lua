

_addon.name = 'Report'
_addon.author = 'Cliff'
_addon.version = '1.0'
_addon.date = '1.23.2025'
_addon.commands = {'rep'}

require('logger')
require('coroutine')
require('mylibs/utils')
require('mylibs/caster')
require('mylibs/buffs')

res = require('resources')

function isMob(id)
    m = windower.ffxi.get_mob_by_id(id)
    if m and m['spawn_type']==16 and m['hpp'] >0 then
        return true
    end
    return false
end

require('actions')

DangersV3 = {
	-- Degei, Aita
    ['フレミングキック'] = {ann='》》》 弱点：湾曲 湾曲 湾曲 水 水 水 《《《 <call8>'},
    ['アイシーグラスプ'] = {ann='》》》 弱点：核熱 核熱 核熱 火 火 火 《《《 <call8>'},
    ['エローディングフレッシュ'] = {ann='》》》 弱点：分解 分解 分解 風 風 風 《《《 <call8>v'},
    ['ファルミナススマッシュ'] = {ann='》》》 弱点：重力 重力 重力 土 土 土 《《《 <call8>'},
    ['フラッシュフラッド'] = {ann='》》》 弱点：分解 分解 分解 雷 雷 雷 《《《 <call8>'},
    -- ['ヴィヴィセクション'] = {ann='弱点属性：？、次のＷＳを待っている'},
	
	-- Leshonn, Gartell
    ['シュリーキングゲイル'] = {ann='》》》 弱点：重力 重力 重力 土 土 土 《《《 <call8>'},
    ['アンジュレティングショックウェーブ'] = {ann='》》》 弱点：湾曲 湾曲 湾曲 氷 氷 氷 《《《 <call8>'},
	
	-- Mboze
    ['アップルート'] = {ann='》》》 四連携Go go go 《《《 <call8>'},
	
	-- Kalunga
    ['ブリスターローア'] = {ann='》》》 四連携Go go go 《《《 <call8>'},
    -- ['ブラーゼンラッシュ'] = {ann='》》》 ゴギラが怒っている！！迴避 please 《《《 <call7>; wait 45; input /p 息怒了...?'},
	
	-- Gogmagog
    -- ['マイティストライク'] = {ann='》》》 無頭ナイトが怒っている！！迴避 please 《《《 <call7>; wait 30; input /p 息怒了...?'},
	
	-- Ngai
    ['カルカリアンヴァーヴ'] = {ann='水陣 Zisurru が発生した、MNKさんｗｓ撃って！！！<call7>'},
	
	-- Cloud of Darkness
    ['プリモーディアルサージ'] = {ann='》》》 物理か魔法を吸収するモード 《《《 <call8>'},
}

start_categories = S{
    'weaponskill_begin',
    'casting_begin',
    'spell_begin',
}
end_categories = S{
    'weaponskill_finish',
    'spell_finish',
    'mob_tp_finish',
}

function action_handler(act)
    local actionpacket = ActionPacket.new(act)
    local category = actionpacket:get_category_string()
    -- if category ~= "melee" then
-- log(category)
-- end
    if not (start_categories:contains(category) or end_categories:contains(category)) or act.param == 0 then
        return
    end

    local actor = actionpacket:get_id()
    local target = actionpacket:get_targets()()
    local action = target:get_actions()()
    local message_id = action:get_message_id()
    local add_effect = action:get_add_effect()
    local param, resource, action_id, interruption, conclusion = action:get_spell()
    local ttar = windower.ffxi.get_mob_by_target('t')

    if ttar and actor == ttar.id and isMob(actor) and res[resource][action_id] then
        player = windower.ffxi.get_mob_by_id(actor).name
        ability = res[resource][action_id].name
        if start_categories:contains(category) and message_id~=0 then
            -- text.ws = ability
            if DangersV3[ability] then
                if DangersV3[ability].ann then
                    -- windower.send_command(windower.to_shift_jis('input /p '..ability..'!!!! '..DangersV3[ability].ann))
                    windower.send_command(windower.to_shift_jis('input /p '..DangersV3[ability].ann))
                end
            end
            -- if ability == '自爆' then
                -- windower.send_command(windower.to_shift_jis('input /ma "スタン" <bt>'))
            -- end
            -- log(player..' using('..message_id..') '..ability..'('..action_id..') '..category)
        else
            -- log(player..' used('..message_id..') '..ability..'('..action_id..') '..category)
        end
    end
end

ActionPacket.open_listener(action_handler)

windower.register_event('load', function()
end)

windower.register_event('addon command', function (command, ...)
	command = command and command:lower()
	local args = T{...}

	if command == 'test' then
        for key, data in pairs(DangersV3) do
			if key == 'フレミングキック' then
				-- windower.send_command(windower.to_shift_jis('input /p '..key..'!!!! '..data.ann))
				windower.send_command(windower.to_shift_jis('input /p '..data.ann))
			end
		end
	end
end)
--欧贝里斯克的巨神兵
function c18000002.initial_effect(c)
	--summon with 3 tribute
	local e1 = Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c18000002.ttcon)
	e1:SetOperation(c18000002.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c18000002.setcon)
	c:RegisterEffect(e2)

	--summon
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)

	--cannot change control
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e4)

	--cannot be effect destroy
	local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)

	--cannot be target
	local e6 = Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)

	--to grave
	local e7 = Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(18000002, 0))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCondition(c18000002.tgcon)
	e7:SetTarget(c18000002.tgtg)
	e7:SetOperation(c18000002.tgop)
	c:RegisterEffect(e7)

	--battle target
	local e8 = Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0, LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e8:SetCondition(c18000002.atcon)
	e8:SetValue(c18000002.atlimit)
	c:RegisterEffect(e8)

	--attack all
	local e9 = Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(18000002, 1))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e9:SetCost(c18000002.specost)
	e9:SetOperation(c18000002.attallop)
	c:RegisterEffect(e9)

	--attack value max
	local e10 = Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(18000002, 2))
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_MZONE)
	e10:SetHintTiming(0, TIMING_DRAW_PHASE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e10:SetCost(c18000002.specost)
	e10:SetOperation(c18000002.attmaxop)
	c:RegisterEffect(e10)
end

function c18000002.ttcon(e, c)
	if c == nil then return true end
	return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > -3 and Duel.GetTributeCount(c) >= 3
end

function c18000002.ttop(e, tp, eg, ep, ev, re, r, rp, c)
	local g = Duel.SelectTribute(tp, c, 3, 3)
	c:SetMaterial(g)
	Duel.Release(g, REASON_SUMMON+REASON_MATERIAL)
end

function c18000002.setcon(e, c)
	if not c then return true end
	return false
end

function c18000002.tgcon(e, tp, eg, ep, ev, re, r, rp)
	return bit.band(e:GetHandler():GetSummonType(), SUMMON_TYPE_SPECIAL) == SUMMON_TYPE_SPECIAL
end

function c18000002.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, e:GetHandler(), 1, 0, 0)
end

function c18000002.tgop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c, REASON_EFFECT)
	end
end

function c18000002.atcon(e, tp, eg, ep, ev, re, r, rp)
	return bit.band(e:GetHandler():GetSummonType(), SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and e:GetHandler():IsDefensePos()
end

function c18000002.atlimit(e, c)
	return c:GetCode()~=17081521
end

function c18000002.specost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp, nil, 2, e:GetHandler()) end
	local g = Duel.SelectReleaseGroup(tp, nil, 2, 2, e:GetHandler())
	Duel.Release(g, REASON_COST)
end

function c18000002.attallop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	--direct
	local e2 = Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(18000002, 3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c18000002.diratcon)
	e2:SetOperation(c18000002.diratop)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)
end

function c18000002.diratcon(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
	return g:GetCount() == 0-- and e:GetHandler():IsChainAttackable()
end

function c18000002.diratop(e, tp, eg, ep, ev, re, r, rp)
	Duel.ChainAttack()
end

function c18000002.attmaxop(e, tp, eg, ep, ev, re, r, rp)
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0x7FFFFFFF)--2147483647)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
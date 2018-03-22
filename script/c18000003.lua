--欧西里斯的天空龙
function c18000003.initial_effect(c)
	--summon with 3 tribute
	local e1 = Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c18000003.ttcon)
	e1:SetOperation(c18000003.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c18000003.setcon)
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

	--atk/def
	local e7 = Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c18000003.adval)
	c:RegisterEffect(e7)
	local e8 = e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)

	--to grave
	local e9 = Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(18000003, 0))
	e9:SetCategory(CATEGORY_TOGRAVE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetCondition(c18000003.tgcon)
	e9:SetTarget(c18000003.tgtg)
	e9:SetOperation(c18000003.tgop)
	c:RegisterEffect(e9)

	--replace effect destroy
	local e10 = Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(LOCATION_MZONE, 0)
	e10:SetCode(EFFECT_DESTROY_REPLACE)
	e10:SetTarget(c18000003.reptg)
	e10:SetValue(c18000003.repval)
	e10:SetOperation(c18000003.repop)
	c:RegisterEffect(e10)

	--atkdown
	local e11 = Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(18000003, 2))
	e11:SetCategory(CATEGORY_ATKCHANGE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetCondition(c18000003.atkdcon)
	e11:SetTarget(c18000003.atkdtg)
	e11:SetOperation(c18000003.atkdop)
	c:RegisterEffect(e11)
	local e12 = e11:Clone()
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e12)
	local e13 = e11:Clone()
	e13:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e13)
end

function c18000003.ttcon(e, c)
	if c == nil then return true end
	return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > -3 and Duel.GetTributeCount(c) >= 3
end

function c18000003.ttop(e, tp, eg, ep, ev, re, r, rp, c)
	local g = Duel.SelectTribute(tp, c, 3, 3)
	c:SetMaterial(g)
	Duel.Release(g, REASON_SUMMON+REASON_MATERIAL)
end

function c18000003.setcon(e, c)
	if not c then return true end
	return false
end

function c18000003.adval(e, c)
	return Duel.GetFieldGroupCount(c:GetControler(), LOCATION_HAND, 0)*1000
end

function c18000003.tgcon(e, tp, eg, ep, ev, re, r, rp)
	return bit.band(e:GetHandler():GetSummonType(), SUMMON_TYPE_SPECIAL) == SUMMON_TYPE_SPECIAL
end

function c18000003.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, e:GetHandler(), 1, 0, 0)
end

function c18000003.tgop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c, REASON_EFFECT)
	end
end

function c18000003.filter(c, tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

function c18000003.reptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		 and eg:IsExists(c18000003.filter, 1, nil) end
	return bit.band(e:GetHandler():GetSummonType(), SUMMON_TYPE_SPECIAL) == SUMMON_TYPE_SPECIAL and Duel.SelectYesNo(tp, aux.Stringid(18000003, 1))
end

function c18000003.repval(e, c, tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

function c18000003.repop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Destroy(e:GetHandler(), REASON_EFFECT+REASON_REPLACE)
end

function c18000003.atkfilter(c, e, tp)
	return c:IsControler(tp) and (c:IsPosition(POS_FACEUP_ATTACK) or c:IsPosition(POS_FACEUP_DEFENSE)) and (not e or c:IsRelateToEffect(e))
end

function c18000003.atkdcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(c18000003.atkfilter, 1, nil, nil, 1-tp)
end

function c18000003.atkdtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end

function c18000003.atkdop(e, tp, eg, ep, ev, re, r, rp)
	local g = eg:Filter(c18000003.atkfilter, nil, e, 1-tp)
	local dg = Group.CreateGroup()
	local c = e:GetHandler()
	local tc = g:GetFirst()
	while tc do
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			local preatk = tc:GetAttack()
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-2000)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			if preatk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
			tc = g:GetNext()
		elseif tc:IsPosition(POS_FACEUP_DEFENSE) then
			local preatk = tc:GetDefense()
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(-2000)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			if preatk~=0 and tc:GetDefense()==0 then dg:AddCard(tc) end
			tc = g:GetNext()
		end
	end
	Duel.Destroy(dg, REASON_RULE)
end
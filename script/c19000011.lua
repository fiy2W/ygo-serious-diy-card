--奥利哈刚之气
function c19000011.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c19000011.con)
	e1:SetCountLimit(1,19000011+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)

	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c19000011.selfdes)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19000011, 0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0, LOCATION_MZONE)
	e3:SetCondition(c19000011.descon)
	e3:SetCost(c19000011.descost)
	e3:SetOperation(c19000011.desop)
	c:RegisterEffect(e3)

	--recover
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_TURN_END)
	e4:SetOperation(c19000011.recop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(c19000011.desfilter)
	c:RegisterEffect(e5)
end

function c19000011.desfilter(e, te)
	return te:GetOwner()~=e:GetOwner()
end

function c19000011.con(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_ONFIELD, 0, 1, nil, 19000010)
end

function c19000011.selfdes(e)
	return not Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil, 19000010)
end

function c19000011.descon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer()~=tp
end

function c19000011.descost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp, nil, 1, nil) end
	local g = Duel.SelectReleaseGroup(tp, nil, 1, 1, nil)
	Duel.Release(g, REASON_COST)
end

function c19000011.desop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetAttacker()
	Duel.Destroy(tc, REASON_EFFECT)
end

function c19000011.recop(e, tp, eg, ep, ev, re, r, rp)
	if ep~=tp then return end
	local rec = Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0)*500
	Duel.Recover(tp, rec, REASON_EFFECT)
end
--奥利哈刚-托利托斯
function c19000012.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c19000012.con)
	e1:SetCountLimit(1,19000012+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)

	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c19000012.selfdes)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c19000012.desfilter)
	c:RegisterEffect(e3)

	--cannot be effect
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE, 0)
	e4:SetValue(c19000012.nefilter)
	c:RegisterEffect(e4)
end

function c19000012.con(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_ONFIELD, 0, 1, nil, 19000010) and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_ONFIELD, 0, 1, nil, 19000011)
end

function c19000012.selfdes(e)
	return not (Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_ONFIELD, 0, 1, nil, 19000010) and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_ONFIELD, 0, 1, nil, 19000011))
end

function c19000012.desfilter(e, te)
	return te:GetOwner()~=e:GetOwner()
end

function c19000012.nefilter(e, re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
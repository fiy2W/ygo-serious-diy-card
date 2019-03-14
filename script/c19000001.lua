--艾克佐迪亚的亡灵
function c19000001.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)

	--cannot battle destroy
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c19000001.con1)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	--cannot destroy by spell
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c19000001.con2)
	e3:SetValue(c19000001.val2)
	c:RegisterEffect(e3)

	--cannot destroy by trap
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c19000001.con3)
	e4:SetValue(c19000001.val3)
	c:RegisterEffect(e4)

	--cannot destroy by monster effect
	local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c19000001.con4)
	e5:SetValue(c19000001.val4)
	c:RegisterEffect(e5)

	--atkup
	local e6 = Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(19000001, 0))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetCode(EVENT_BATTLED)
	e6:SetCondition(c19000001.con5)
	e6:SetOperation(c19000001.atkop)
	c:RegisterEffect(e6)
end

function c19000001.con1(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 33396948)
end

function c19000001.con2(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 44519536)
end

function c19000001.val2(e, re, rp, c)
	return re:IsActiveType(TYPE_SPELL)
end

function c19000001.con3(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 8124921)
end

function c19000001.val3(e, re, rp, c)
	return re:IsActiveType(TYPE_TRAP)
end

function c19000001.con4(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 7902349)
end

function c19000001.val4(e, re, rp, c)
	return re:IsActiveType(TYPE_MONSTER)
end

function c19000001.con5(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 70903634)
end

function c19000001.atkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end
--与艾克佐迪亚的契约
function c19000002.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c19000002.condition)
	e1:SetCost(c19000002.cost)
	e1:SetTarget(c19000002.target)
	e1:SetOperation(c19000002.activate)
	c:RegisterEffect(e1)
end

function c19000002.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.GetLP(tp)>2000 end
	Duel.PayLPCost(tp, 2000)
end

function c19000002.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 8124921)
		and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 44519536)
		and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 70903634)
		and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 7902349)
		and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 33396948)
end

function c19000002.filter(c, e, tp)
	return c:IsCode(19000001) and c:IsCanBeSpecialSummoned(e, 0, tp, true, true)
end

function c19000002.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.GetLocationCount(tp, LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19000002.filter, tp, LOCATION_HAND, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function c19000002.activate(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local tg = Duel.SelectMatchingCard(tp, c19000002.filter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp)
	if tg:GetCount()>0 then
		local tc = tg:GetFirst()
		Duel.SpecialSummon(tc, 0, tp, tp, true, true, POS_FACEUP)
		tc:CompleteProcedure()
	end
end
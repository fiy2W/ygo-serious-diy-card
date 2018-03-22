--灰度空间
function c18000010.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c18000010.activecon)
	c:RegisterEffect(e1)

	--disable
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e2:SetTarget(c18000010.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)

	--Destroy replace
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c18000010.desreptg)
	e3:SetOperation(c18000010.desrepop)
	c:RegisterEffect(e3)

	--Special Summon
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18000010, 1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCost(c18000010.spscost)
	e4:SetTarget(c18000010.spstg)
	e4:SetOperation(c18000010.spsop)
	c:RegisterEffect(e4)
end

function c18000010.activecon(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_DECK, nil)
	local tc = g:GetFirst()
	while tc do
		local code = tc:GetCode()
		if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_DECK, 0, 2, nil, code) then return false end
		tc = g:GetNext()
	end
	return true
end

function c18000010.disable(e, c)
	return c:IsType(TYPE_EFFECT)
end

function c18000010.desreptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and Duel.IsExistingMatchingCard(nil, tp, 0, LOCATION_EXTRA, 1, nil) end
	
	if Duel.SelectYesNo(tp, aux.Stringid(18000010, 0)) then
		--local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_EXTRA, nil)
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local gs = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_EXTRA, 0, 1, 1, nil)
		Duel.SetTargetCard(gs)
		return true
	else return false end
end

function c18000010.desrepop(e, tp, eg, ep, ev, re, r, rp)
	local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(tg, REASON_EFFECT+REASON_REPLACE)
end

function c18000010.costfilter(c, e, tp)
	return c:IsType(TYPE_NORMAL) 
	and Duel.IsExistingMatchingCard(c18000010.spsfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, c:GetAttribute(), c:GetRace())
end

function c18000010.spsfilter(c, e, tp, attr, race)
	return c:IsAttribute(attr) and c:IsRace(race)
		and c:IsCanBeSpecialSummoned(e, 0, tp, true, true)
end

function c18000010.spscost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp, c18000010.costfilter, 1, nil, e, tp) end
	local sg = Duel.SelectReleaseGroup(tp, c18000010.costfilter, 1, 1, nil, e, tp)
	e:SetLabel(sg:GetFirst():GetCode())
	--e:SetLabel(sg:GetFirst():GetRace())
	Duel.Release(sg, REASON_COST)
end

function c18000010.spstg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chk==0 then return Duel.GetLocationCount(tp, LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function c18000010.spsop(e, tp, eg, ep, ev, re, r, rp)
	local code = e:GetLabel()
	local tc = Duel.GetMatchingGroup(Card.IsCode, tp, LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_ONFIELD, LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_ONFIELD, nil, code):GetFirst()

	if Duel.GetLocationCount(tp, LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, c18000010.spsfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, tc:GetAttribute(), tc:GetRace())
	Duel.SpecialSummon(g, 0, tp, tp, true, true, POS_FACEUP)
end
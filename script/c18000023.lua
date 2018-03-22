--电子暗黑冲击！
function c18000023.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c18000023.target)
	e1:SetOperation(c18000023.activate)
	c:RegisterEffect(e1)
end

function c18000023.ffilter0(c)
	return c:IsCode(18000020, 18000021, 18000022) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end

function c18000023.ffilter(c,e)
	return c:IsCode(18000020, 18000021, 18000022) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
		and not c:IsImmuneToEffect(e)
end

function c18000023.spfilter(c,e,tp)
	return c:IsCode(18000024) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false)
end

function c18000023.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then
		if not Duel.IsExistingMatchingCard(c18000023.spfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp) then return false end
		local g = Duel.GetMatchingGroup(c18000023.ffilter0, tp, 0x1e, 0, nil)
		if Duel.GetLocationCount(tp, LOCATION_MZONE)<=0 and not g:IsExists(Card.IsLocation, 1, nil,LOCATION_MZONE) then return false end
		return g:IsExists(Card.IsCode, 1, nil, 18000020)
			and g:IsExists(Card.IsCode, 1, nil, 18000021)
			and g:IsExists(Card.IsCode, 1, nil, 18000022)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function c18000023.cfilter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsOnField() and c:IsFacedown())
end

function c18000023.activate(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(aux.NecroValleyFilter(c18000023.ffilter), tp, 0x1e, 0, nil, e)
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	if (ft<=0 and not g:IsExists(Card.IsLocation, 1, nil, LOCATION_MZONE))
		or not g:IsExists(Card.IsCode, 1, nil, 18000020)
		or not g:IsExists(Card.IsCode, 1, nil, 18000021)
		or not g:IsExists(Card.IsCode, 1, nil, 18000022) then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	if ft<=0 then g1 = g:FilterSelect(tp, Card.IsLocation, 1, 1, nil, LOCATION_MZONE)
	else g1 = g:Select(tp, 1, 1, nil) end
	g:Remove(Card.IsCode, nil, g1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g2 = g:Select(tp, 1, 1, nil)
	g:Remove(Card.IsCode, nil, g2:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g3 = g:Select(tp, 1, 1, nil)
	g1:Merge(g2)
	g1:Merge(g3)
	local cg = g1:Filter(c18000023.cfilter, nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp, cg)
		Duel.ShuffleHand(tp)
	end
	Duel.SendtoDeck(g1, nil, 2, REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sg = Duel.SelectMatchingCard(tp, c18000023.spfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
	Duel.SpecialSummon(sg, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
	sg:GetFirst():CompleteProcedure()
end
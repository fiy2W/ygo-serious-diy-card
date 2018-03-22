--代替演出
function c18000011.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c18000011.cost)
	e1:SetTarget(c18000011.target)
	e1:SetOperation(c18000011.operation)
	c:RegisterEffect(e1)
end

function c18000011.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.CheckLPCost(tp, 2000) end
	Duel.PayLPCost(tp, 2000)
end

function c18000011.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToDeck() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectTarget(tp, Card.IsAbleToHand, tp, LOCATION_MZONE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 1, 0, 0)
end

function c18000011.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc, tp, 2, REASON_EFFECT)
		
		local code = tc:GetCode()
		local tcg = Duel.GetMatchingGroup(Card.IsCode, tp, 0, LOCATION_DECK+LOCATION_EXTRA, nil, code):GetFirst()
		Duel.SpecialSummon(tcg, 0, tp, tp, true, true, POS_FACEUP)
	end
end

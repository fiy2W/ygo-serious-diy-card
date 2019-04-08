--源数改写·魔法
function c19008091.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c19008091.condition)
	e1:SetTarget(c19008091.target)
	e1:SetOperation(c19008091.activate)
	c:RegisterEffect(e1)
end

function c19008091.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,e:GetHandler())
end

function c19008091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c19008091.spfilter(c)
	return c:IsType(TYPE_SPELL) and c:CheckActivateEffect(false,false,false)~=nil
end

function c19008091.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)

		if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
		
		local g=Duel.GetMatchingGroup(c19008091.spfilter, tp, 0, LOCATION_DECK, nil)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local ag=g:Select(tp,1,1,nil)
		local tc=ag:GetFirst()
		if not tc then return end

		local tpe = tc:GetType()
		local te = tc:GetActivateEffect()
		local tg = te:GetTarget()
		local co = te:GetCost()
		local op = te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if bit.band(tpe, TYPE_EQUIP+TYPE_CONTINUOUS)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
			if Duel.GetLocationCount(1-tp, LOCATION_SZONE)<=0 then return end
			Duel.MoveToField(tc, 1-tp, 1-tp, LOCATION_SZONE, POS_FACEUP, true)
		elseif bit.band(tpe, TYPE_FIELD)~=0 then
			Duel.MoveToField(tc, 1-tp, 1-tp, LOCATION_SZONE, POS_FACEUP, true)
		end
		tc:CreateEffectRelation(te)
		if co then co(te, 1-tp, eg, ep, ev, re, r, rp, 1) end

		if tg then
			if tc:IsSetCard(0x95) then
				tg(e, 1-tp, eg, ep, ev, re, r, rp, 1)
			else
				tg(te, 1-tp, eg, ep, ev, re, r, rp, 1)
			end
		end
		Duel.BreakEffect()
		local gtc = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
		if gtc then
			local etc = gtc:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc = gtc:GetNext()
			end
		end
		if op then 
			if tc:IsSetCard(0x95) then
				op(e, 1-tp, eg, ep, ev, re, r, rp)
			else
				op(te, 1-tp, eg, ep, ev, re, r, rp)
			end
		end
		tc:ReleaseEffectRelation(te)
		if gtc then
			etc = gtc:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc = gtc:GetNext()
			end
		end
	end
end
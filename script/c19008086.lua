--源数网络
function c19008086.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--Activate in opponent's turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19008086,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(c19008086.actot_con)
	e2:SetTarget(c19008086.actot_tag)
	e2:SetOperation(c19008086.actot_act)
	c:RegisterEffect(e2)

	--overlap remove replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19008086,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c19008086.rcon)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19008086,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c19008086.effcon)
	e4:SetTarget(c19008086.target)
	e4:SetOperation(c19008086.operation)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(19008086,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c19008086.effcon2)
	e5:SetTarget(c19008086.target2)
	e5:SetOperation(c19008086.operation)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(19008086,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCondition(c19008086.effcon2)
	e6:SetTarget(c19008086.target3)
	e6:SetOperation(c19008086.operation)
	c:RegisterEffect(e6)
	--local e7=e6:Clone()
	--e7:SetCode(EVENT_FLIP_SUMMON)
	--c:RegisterEffect(e7)
	--local e8=e5:Clone()
	--e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	--c:RegisterEffect(e8)
end

function c19008086.filter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end

function c19008086.actot_con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_RULE)~=0 and not Duel.IsExistingMatchingCard(c19008086.filter,tp,LOCATION_ONFIELD,0,1,nil)
end

function c19008086.actot_tag(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,5) end
end

function c19008086.actot_act(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.CheckLocation(tp,LOCATION_SZONE,5) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function c19008086.rcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x1048)
end

function c19008086.effcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.CheckEvent(EVENT_CHAINING) and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end

function c19008086.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end

function c19008086.filter1(c)
	return c:IsAbleToGraveAsCost() and c:CheckActivateEffect(false,false,false)~=nil
end

function c19008086.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c19008086.filter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c19008086.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,false,true)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then 
		tgco=te:GetCost()
		if tgco then tgco(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end

function c19008086.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function c19008086.filter2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsAbleToGraveAsCost() then
		if c:CheckActivateEffect(false,false,false)~=nil then return true end
		local te=c:GetActivateEffect()
		if te==nil then return false end
		if te:GetCode()~=EVENT_CHAINING then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
	else return false end
end

function c19008086.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c19008086.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c19008086.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c19008086.filter1(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
	else
		te=tc:GetActivateEffect()
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		tgco = te:GetCost()
		if fchain then
			if tgco then tgco(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			if tgco then tgco(e,tp,eg,ep,ev,re,r,rp,1) end
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end

function c19008086.filter3(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsAbleToGraveAsCost() then
		if c:CheckActivateEffect(false,false,false)~=nil then return true end
		local te=c:GetActivateEffect()
		if te==nil then return false end
		if (te:GetCode()~=EVENT_SUMMON and te:GetCode()~=EVENT_SUMMON_SUCCESS and te:GetCode()~=EVENT_SPSUMMON and te:GetCode()~=EVENT_SPSUMMON_SUCCESS and te:GetCode()~=EVENT_FLIP_SUMMON and te:GetCode()~=EVENT_FLIP_SUMMON_SUCCESS) then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
	else return false end
end

function c19008086.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c19008086.filter3,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c19008086.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c19008086.filter1(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
	else
		te=tc:GetActivateEffect()
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		tgco = te:GetCost()
		if fchain then
			if tgco then tgco(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			if tgco then tgco(e,tp,eg,ep,ev,re,r,rp,1) end
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
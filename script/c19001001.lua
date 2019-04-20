--CiNo.1000 梦幻虚光神 原数天帝
function c19001001.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,13,5)
	c:EnableReviveLimit()

	--cannot battle destroy
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c19001001.indes)
	c:RegisterEffect(e1)

	--cannot be effect destroy
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	--cannot attack
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	--attack limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(c19001001.atlimit)
	c:RegisterEffect(e4)

	--battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c19001001.bbtop)
	c:RegisterEffect(e5)

	--win
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c19001001.wincon)
	e6:SetOperation(c19001001.winop)
	e6:SetCountLimit(1)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)

	--disable attack
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(19001001,0))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCategory(CATEGORY_RECOVER)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetCondition(c19001001.atkcon)
	e7:SetCost(c19001001.atkcost)
	e7:SetTarget(c19001001.atktag)
	e7:SetOperation(c19001001.atkop)
	c:RegisterEffect(e7)
end

function c19001001.indes(e,c)
	return not c:IsSetCard(0x48)
end

function c19001001.atlimit(e,c)
	return c~=e:GetHandler()
end

function c19001001.bbtop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)
end

function c19001001.wincon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end

function c19001001.winop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel() == 1 then
		e:GetLabelObject():SetLabel(0)
	else
		local WIN_REASON_CiNO1000=0x10
		local p=e:GetHandler():GetControler()
		Duel.Win(p,WIN_REASON_CiNO1000)
	end
end

function c19001001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end

function c19001001.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c19001001.atktag(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	local rec=tg:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end

function c19001001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackable() then
		if Duel.NegateAttack(tc) then
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		end
	end
end
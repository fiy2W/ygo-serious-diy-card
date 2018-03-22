--太阳神的翼神龙
function c18000001.initial_effect(c)
	--summon with 3 tribute
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18000001, 0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c18000001.ttcon1)
	e1:SetOperation(c18000001.ttop1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18000001, 1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetTargetRange(POS_FACEUP_ATTACK, 1)
	e2:SetCondition(c18000001.ttcon2)
	e2:SetOperation(c18000001.ttop2)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LIMIT_SET_PROC)
	e3:SetCondition(c18000001.setcon)
	c:RegisterEffect(e3)

	--control return
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetOperation(c18000001.retreg)
	c:RegisterEffect(e4)

	--summon
	local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e5)

	--cannot control
	----attack limit
	local e6 = Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetCondition(c18000001.cnctrlcon)
	c:RegisterEffect(e6)
	----cannot be attack target
	local e7 = e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	----cannot be effect
	local e8 = e6:Clone()
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c18000001.bsnefilter)
	c:RegisterEffect(e8)
	----can attack player
	local e9 = Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0, LOCATION_MZONE)
	e9:SetCode(EFFECT_DIRECT_ATTACK)
	e9:SetCondition(c18000001.cnctrlatkcon)
	e9:SetValue(1)
	c:RegisterEffect(e9)

	--cannot be effect destroy
	local e10 = Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetValue(1)
	c:RegisterEffect(e10)

	--cannot be target
	local e11 = Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(1)
	c:RegisterEffect(e11)

	--give atk effect
	local e12 = Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_MATERIAL_CHECK)
	e12:SetValue(c18000001.valcheck)
	c:RegisterEffect(e12)
	--give atk effect only when summon
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_SUMMON_COST)
	e13:SetOperation(c18000001.facechk)
	e13:SetLabelObject(e12)
	c:RegisterEffect(e13)

	--only owner can special summon
	--local e14=Effect.CreateEffect(c)
	--e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e14:SetType(EFFECT_TYPE_SINGLE)
	--e14:SetCode(EFFECT_SPSUMMON_CONDITION)
	--e14:SetValue(c17081520.spslimit)
	--c:RegisterEffect(e14)
	
	--LP up
	local e14 = Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(18000001, 3))
	e14:SetType(EFFECT_TYPE_QUICK_O)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1)
	e14:SetCode(EVENT_FREE_CHAIN)
	e14:SetCondition(c18000001.recovercon)
	e14:SetOperation(c18000001.recoverop)
	c:RegisterEffect(e14)

	--to grave
	local e15 = Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(18000001, 2))
	e15:SetCategory(CATEGORY_TOGRAVE)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCountLimit(1)
	e15:SetCode(EVENT_PHASE+PHASE_END)
	e15:SetCondition(c18000001.tgcon)
	e15:SetTarget(c18000001.tgtg)
	e15:SetOperation(c18000001.tgop)
	c:RegisterEffect(e15)

	--one turn kill
	local e16 = Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(18000001, 4))
	e16:SetType(EFFECT_TYPE_QUICK_O)
	e16:SetCode(EVENT_FREE_CHAIN)
	e16:SetRange(LOCATION_MZONE)
	e16:SetHintTiming(0, TIMING_DRAW_PHASE)
	e16:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e16:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e16:SetCondition(c18000001.tgcon)
	e16:SetCost(c18000001.otkcost)
	e16:SetOperation(c18000001.otkop)
	c:RegisterEffect(e16)

	--the secular bird
	local e17 = Effect.CreateEffect(c)
	e17:SetDescription(aux.Stringid(18000001, 5))
	e17:SetType(EFFECT_TYPE_QUICK_O)
	e17:SetCode(EVENT_FREE_CHAIN)
	e17:SetRange(LOCATION_MZONE)
	e17:SetHintTiming(0, TIMING_DRAW_PHASE)
	e17:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e17:SetCondition(c18000001.tgcon)
	e17:SetCost(c18000001.bsncost)
	e17:SetOperation(c18000001.bsnop)
	c:RegisterEffect(e17)
end

function c18000001.ttcon1(e, c, minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c, 3)
end

function c18000001.ttop1(e, tp, eg, ep, ev, re, r, rp, c)
	local g = Duel.SelectTribute(tp, c, 3, 3)
	c:SetMaterial(g)
	Duel.Release(g, REASON_SUMMON+REASON_MATERIAL)
end

function c18000001.ttcon2(e, c, minc)
	if c==nil then return true end
	local tp = c:GetControler()
	local mg = Duel.GetFieldGroup(tp, 0, LOCATION_MZONE)
	return minc<=3 and Duel.CheckTribute(c, 3, 3, mg, 1-tp)
end

function c18000001.ttop2(e, tp, eg, ep, ev, re, r, rp, c)
	local mg = Duel.GetFieldGroup(tp, 0, LOCATION_MZONE)
	local g = Duel.SelectTribute(tp, c, 3, 3, mg, true)
	c:SetMaterial(g)
	Duel.Release(g, REASON_SUMMON+REASON_MATERIAL)
end

function c18000001.setcon(e, c, minc)
	if not c then return true end
	return false
end

function c18000001.retreg(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	c:RegisterFlagEffect(18000001, RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END, 0, 2)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetLabel(Duel.GetTurnCount()+1)
	e1:SetCountLimit(1)
	e1:SetCondition(c18000001.retcon)
	e1:SetOperation(c18000001.retop)
	e1:SetReset(RESET_PHASE+PHASE_END, 2)
	Duel.RegisterEffect(e1, tp)
end

function c18000001.retcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnCount()==e:GetLabel() and e:GetOwner():GetFlagEffect(18000001)~=0
end

function c18000001.retop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetOwner()
	c:ResetEffect(EFFECT_SET_CONTROL, RESET_CODE)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_CONTROL)
	e1:SetValue(c:GetOwner())
	e1:SetReset(RESET_EVENT+0xec0000)
	c:RegisterEffect(e1)
end

function c18000001.cnctrlcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetOwner() ~= e:GetHandler():GetControler()
end

function c18000001.cnctrlatkcon(e)
	local tp = e:GetHandlerPlayer()
	return e:GetHandler():GetOwner() ~= e:GetHandler():GetControler() and Duel.GetFieldGroupCount(tp, LOCATION_ONFIELD, 0)==1
end

function c18000001.valcheck(e, c)
	local g = c:GetMaterial()
	local tc = g:GetFirst()
	local atk = 0
	local def = 0
	while tc do
		local catk = tc:GetAttack()--GetTextAttack()
		local cdef = tc:GetDefense()
		atk = atk+(catk>=0 and catk or 0)
		def = def+(cdef>=0 and cdef or 0)
		tc = g:GetNext()
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	end
end

function c18000001.facechk(e, tp, eg, ep, ev, re, r, rp)
	e:GetLabelObject():SetLabel(1)
end

function c18000001.spslimit(e, c)
	return e:GetHandler():GetOwner() == Duel:GetTurnPlayer()
end

function c18000001.tgcon(e, tp, eg, ep, ev, re, r, rp)
	return bit.band(e:GetHandler():GetSummonType(), SUMMON_TYPE_SPECIAL) == SUMMON_TYPE_SPECIAL and e:GetHandler():GetOwner() == e:GetHandler():GetControler()
end

function c18000001.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, e:GetHandler(), 1, 0, 0)
end

function c18000001.tgop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c, REASON_EFFECT)
	end
end

function c18000001.otkcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.GetLP(tp)>1 end
	local lp = Duel.GetLP(tp)
	e:SetLabel(lp-1)
	Duel.PayLPCost(tp, lp-1)
end

function c18000001.otkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)

		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetCost(c18000001.otkspcost)
		e2:SetOperation(c18000001.otkspop)
		c:RegisterEffect(e2)

		--cannot be target
		local e3 = Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(1)
		c:RegisterEffect(e3)
	end
end

function c18000001.otkspcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp, nil, 1, nil, e:GetHandler()) end
	if Duel.IsPlayerAffectedByEffect(tp, 59822133) then ct=1 end
	local rg = Duel.SelectReleaseGroup(tp, nil, 1, 4, e:GetHandler())
	local tc = rg:GetFirst()
	local atk = 0
	while tc do
		local catk = tc:GetAttack()--GetTextAttack()
		atk = atk+(catk>=0 and catk or 0)
		tc = rg:GetNext()
	end
	e:SetLabel(atk)
	ct = Duel.Release(rg, REASON_COST)
end

function c18000001.otkspop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end

function c18000001.bsncost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.GetLP(tp)>1000 end
	Duel.PayLPCost(tp, 1000)
end

function c18000001.bsnop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
		Duel.Destroy(g, REASON_RULE)

		--damage avoid
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)

		--cannot destroy
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3 = Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)

		--cannot be effect
		local e4 = e3:Clone()
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(c18000001.bsnefilter)
		c:RegisterEffect(e4)
	end
end

function c18000001.bsnefilter(e, te)
	return te:GetOwner()~=e:GetOwner()
end

function c18000001.recovercon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetOwner() == e:GetHandler():GetControler() and e:GetHandler():GetAttack() > 0
end

function c18000001.recoverop(e, tp, eg, ep, ev, re, r, rp)
	local tc = e:GetHandler()
	local atk = tc:GetAttack()--GetTextAttack()
	local e1 = Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-atk)
	e1:SetReset(RESET_EVENT+0xff0000)
	tc:RegisterEffect(e1)

	Duel.Recover(tp, atk, REASON_EFFECT)
end
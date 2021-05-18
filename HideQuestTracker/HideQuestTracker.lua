local QFrame = QuestWatchFrame

function HideQuestTracker()
	QuestTrackerFrame:SetScript("OnUpdate", function(self,...)
		if QFrame then
			QFrame:Hide()
			QFrame:UnregisterAllEvents()
			QFrame.Show = function() end
		end
		QFrame_CheckFrame = function () end
		self:SetScript("OnUpdate", nil)
	end)
end

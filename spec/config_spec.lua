local Config = require('lib/config')

describe("Config", function()
  describe("default values", function()
    it("has them", function()
      local config = Config:new()

      assert.are.equals(true, config.shouldShowAlertInNormalMode)
      assert.are.equals("Courier New", config.alert.font)
      assert.is_table(config.betaFeatures)
      assert.is_table(config.fallbackOnlyApps)
      assert.is_table(config.fallbackOnlyUrlPatterns)
      assert.are.equals(true, config.shouldDimScreenInNormalMode)
    end)

    it("accepts constructor options", function()
      local config = Config:new({
        shouldShowAlertInNormalMode = false,
        customProperty = "test"
      })
      
      assert.are.equals(false, config.shouldShowAlertInNormalMode)
      assert.are.equals("test", config.customProperty)
      assert.are.equals("Courier New", config.alert.font) -- should keep defaults
    end)
  end)

  describe("#setOptions", function()
    it("sets options", function()
      local config = Config:new()
      config:setOptions({ shouldDimScreenInNormalMode = false })

      assert.are.same(false, config.shouldDimScreenInNormalMode)
    end)

    it("sets multiple options", function()
      local config = Config:new()
      config:setOptions({
        shouldShowAlertInNormalMode = false,
        customValue = 123
      })

      assert.are.equals(false, config.shouldShowAlertInNormalMode)
      assert.are.equals(123, config.customValue)
    end)
  end)

  describe("beta features", function()
    local config

    before_each(function()
      config = Config:new()
    end)

    describe("#enableBetaFeature", function()
      it("enables a beta feature", function()
        config:enableBetaFeature("testFeature")
        assert.are.equals(true, config.betaFeatures.testFeature)
      end)
    end)

    describe("#disableBetaFeature", function()
      it("disables a beta feature", function()
        config:enableBetaFeature("testFeature")
        config:disableBetaFeature("testFeature")
        assert.are.equals(false, config.betaFeatures.testFeature)
      end)
    end)

    describe("#isBetaFeatureEnabled", function()
      it("returns true for enabled features", function()
        config:enableBetaFeature("enabledFeature")
        assert.are.equals(true, config:isBetaFeatureEnabled("enabledFeature"))
      end)

      it("returns false for disabled features", function()
        config:disableBetaFeature("disabledFeature")
        assert.are.equals(false, config:isBetaFeatureEnabled("disabledFeature"))
      end)

      it("returns false for non-existent features", function()
        assert.are.equals(false, config:isBetaFeatureEnabled("nonExistentFeature"))
      end)
    end)
  end)
end)

Settings::Settings([[maybe_unused]]Injector& injector):
	argumentParser(injector.inject<ArgumentParser>())
{ }

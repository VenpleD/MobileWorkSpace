%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
	%orig;
	UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"come to http://bbs.iosre.com for more fun!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
%end
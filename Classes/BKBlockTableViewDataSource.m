//
//  BKBlockTableViewDataSource.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 1/24/11.
//

#import "BKBlockTableViewDataSource.h"


@implementation BKBlockTableViewDataSource

#pragma mark Initialization

- (id)init;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    sections = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc;
{
    CCDealloc(sections);
    
    [super dealloc];
}

#pragma mark Public Methods

- (void)sectionWithBlock:(BKVoidBlock)sectionBlock;
{
    [self beginSection];
    
    if (sectionBlock) {
        sectionBlock();
    }
    
    [self endSection];
}

- (void)beginSection;
{
    lastSection = [NSMutableArray array];
    [sections addObject:lastSection];
}

- (void)beginSectionAtIndex:(NSInteger)index;
{
    if (index > sections.count) {
        return;
    }
    
    lastSection = [NSMutableArray array];
    [sections insertObject:lastSection atIndex:index];
}

- (UITableViewCell *)addCell:(UITableViewCell *)cell didSelectBlock:(BKIndexPathBlock)block;
{
    if (!lastSection) {
        return nil;
    }
    
    NSMutableDictionary *cellInfo = [NSMutableDictionary dictionary];
    if (block) {
        [cellInfo setObject:[[block copy] autorelease] forKey:@"block"];
    }
    
    [cellInfo setObject:cell forKey:@"cell"];
    [lastSection addObject:cellInfo];
    
    return cell;
}

- (void)endSection;
{
    lastSection = nil;
}

- (void)removeAllSections;
{
    [sections removeAllObjects];
    lastSection = nil;
}

- (void)removeSectionAtIndex:(NSUInteger)index;
{
    if (index >= sections.count) {
        return;
    }
    
    [sections removeObjectAtIndex:index];
    lastSection = nil;
}

#pragma mark Public DataSource/Delegate Methods

- (NSInteger)numberOfSections;
{
    return sections.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.numberOfSections;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
{
    if (section >= sections.count) {
        return 0; 
    }

    return [[sections objectAtIndex:section] count];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section >= sections.count || indexPath.row >= [[sections objectAtIndex:indexPath.section] count]) {
        return nil;
    }

    return [[[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"cell"];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section >= sections.count || indexPath.row >= [[sections objectAtIndex:indexPath.section] count]) {
        return;
    }

    BKIndexPathBlock block = [[[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"block"];
    if (block) {
        block(indexPath);
    }
}

#pragma mark UITableViewDataSource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self didSelectRowAtIndexPath:indexPath];
}

@end

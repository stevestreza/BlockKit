//
//  BKBlockTableViewDataSource.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 1/24/11.
//

#import <UIKit/UIKit.h>
#import "BKTypes.h"


@interface BKBlockTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *sections;
    NSMutableArray *lastSection;
}

- (void)sectionWithBlock:(BKVoidBlock)sectionBlock;
- (void)beginSection;
- (void)beginSectionAtIndex:(NSInteger)index;
- (UITableViewCell *)addCell:(UITableViewCell *)cell didSelectBlock:(BKIndexPathBlock)block;
- (void)endSection;

- (void)removeAllSections;
- (void)removeSectionAtIndex:(NSUInteger)index;

// DataSource/Delegate Methods
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

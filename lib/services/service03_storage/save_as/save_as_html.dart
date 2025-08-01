// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

/// Initializes a DOM container where we can host elements.
Element _ensureInitialized(String id) {
  Element? target = querySelector('#$id');
  if (target == null) {
    final Element targetElement = Element.tag('flt-x-file')..id = id;

    // requires an HTML with the 'body' property to work
    querySelector('body')!.children.add(targetElement);
    target = targetElement;
  }
  return target;
}

AnchorElement _createAnchorElement(String href, String suggestedName) {
  return AnchorElement(href: href)..download = suggestedName;
}

/// Add an element to a container and click it
void _addElementToContainerAndClick(Element container, Element element) {
  // Add the element and click it
  // All previous elements will be removed before adding the new one
  container.children.add(element);
  element.click();
}

/// Present a dialog so the user can save as... a bunch of bytes.
Future<void> saveAsBytes(Uint8List bytes, String suggestedName) async {
  // Convert bytes to an ObjectUrl through Blob
  final Blob blob = Blob(<Uint8List>[bytes]);
  final String path = Url.createObjectUrl(blob);

  // Create a DOM container where we can host the anchor.
  final Element target = _ensureInitialized('__x_file_dom_element');

  // Create an <a> tag with the appropriate download attributes and click it
  // May be overridden with XFileTestOverrides
  final AnchorElement element = _createAnchorElement(path, suggestedName);

  // Clear the children in our container so we can add an element to click
  target.children.clear();
  _addElementToContainerAndClick(target, element);
}

// Copyright 2025 Shantanu Sen Gupta
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

class Podcast {
  final String id;
  final String title;
  final String url;
  final String description;
  final String imageUrl;
  final String author;
  
  Podcast({
    required this.id,
    required this.title,
    required this.url,
    required this.description,
    required this.imageUrl,
    required this.author,
  });

  Podcast copyWith({
    String? id,
    String? title,
    String? url,
    String? description,
    String? imageUrl,
    String? author,
  }) {
    return Podcast(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'description': description,
      'imageUrl': imageUrl,
      'author': author,
    };
  }

  factory Podcast.fromMap(Map<String, dynamic> map) {
    return Podcast(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      author: map['author'] ?? '',
    );
  }
} 